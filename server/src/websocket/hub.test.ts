/**
 * Hub のテスト
 */

import { describe, expect, it, mock } from "bun:test";
import type { ServerWebSocket } from "bun";
import type { Operation, Shape, SyncMessage } from "../domain";
import { MemoryRepository } from "../repository";
import { type ClientData, Hub } from "./hub";

// モックWebSocketを作成するヘルパー
function createMockWebSocket(clientId: string): ServerWebSocket<ClientData> & {
  sentMessages: string[];
} {
  const sentMessages: string[] = [];

  return {
    data: { clientId },
    send: mock((msg: string) => {
      sentMessages.push(msg);
      return 0;
    }),
    sentMessages,
    // 必要な他のメソッドはスタブ
    close: mock(() => {}),
    publish: mock(() => {}),
    subscribe: mock(() => {}),
    unsubscribe: mock(() => {}),
    isSubscribed: mock(() => false),
    cork: mock(() => {}),
    ping: mock(() => {}),
    pong: mock(() => {}),
    binaryType: "arraybuffer" as const,
    readyState: 1,
    remoteAddress: "127.0.0.1",
  } as unknown as ServerWebSocket<ClientData> & { sentMessages: string[] };
}

// テスト用のヘルパー関数
function createShape(overrides: Partial<Shape> = {}): Shape {
  return {
    id: "shape-1",
    type: "rectangle",
    x: 100,
    y: 100,
    width: 50,
    height: 50,
    color: "#ff0000",
    timestamp: 1000,
    clientId: "client-a",
    ...overrides,
  };
}

describe("Hub", () => {
  it("接続時に現在の状態を送信する", async () => {
    const repo = new MemoryRepository();
    const hub = new Hub(repo);

    // 事前に図形を追加
    const shape = createShape();
    await repo.applyOperation({
      type: "upsert",
      shape,
      timestamp: 1000,
      clientId: "client-a",
    });

    const ws = createMockWebSocket("client-1");
    await hub.onOpen(ws, "client-1");

    expect(ws.sentMessages).toHaveLength(1);

    const syncMsg: SyncMessage = JSON.parse(ws.sentMessages[0]);
    expect(syncMsg.type).toBe("sync");
    // state は ShapeEntry[] 配列形式
    expect(syncMsg.state).toBeInstanceOf(Array);
    const entry = syncMsg.state?.find((e) => e.shape.id === "shape-1");
    expect(entry).toBeDefined();
  });

  it("クライアント数を正しくカウントする", async () => {
    const repo = new MemoryRepository();
    const hub = new Hub(repo);

    expect(hub.getClientCount()).toBe(0);

    const ws1 = createMockWebSocket("client-1");
    const ws2 = createMockWebSocket("client-2");

    await hub.onOpen(ws1, "client-1");
    expect(hub.getClientCount()).toBe(1);

    await hub.onOpen(ws2, "client-2");
    expect(hub.getClientCount()).toBe(2);

    hub.onClose(ws1);
    expect(hub.getClientCount()).toBe(1);
  });

  it("操作を他のクライアントにブロードキャストする", async () => {
    const repo = new MemoryRepository();
    const hub = new Hub(repo);

    const ws1 = createMockWebSocket("client-1");
    const ws2 = createMockWebSocket("client-2");
    const ws3 = createMockWebSocket("client-3");

    await hub.onOpen(ws1, "client-1");
    await hub.onOpen(ws2, "client-2");
    await hub.onOpen(ws3, "client-3");

    // 初期同期メッセージをクリア
    ws1.sentMessages.length = 0;
    ws2.sentMessages.length = 0;
    ws3.sentMessages.length = 0;

    // client-1から操作を送信
    const op: Operation = {
      type: "upsert",
      shape: createShape(),
      timestamp: 1000,
      clientId: "client-1",
    };

    const message: SyncMessage = { type: "operation", operation: op };
    await hub.onMessage(ws1, JSON.stringify(message));

    // 送信元には送らない
    expect(ws1.sentMessages).toHaveLength(0);

    // 他のクライアントには送る
    expect(ws2.sentMessages).toHaveLength(1);
    expect(ws3.sentMessages).toHaveLength(1);

    const received: SyncMessage = JSON.parse(ws2.sentMessages[0]);
    expect(received.type).toBe("operation");
    expect(received.operation?.shape?.id).toBe("shape-1");
  });

  it("リポジトリに操作が適用される", async () => {
    const repo = new MemoryRepository();
    const hub = new Hub(repo);

    const ws = createMockWebSocket("client-1");
    await hub.onOpen(ws, "client-1");

    const op: Operation = {
      type: "upsert",
      shape: createShape({ id: "new-shape" }),
      timestamp: 2000,
      clientId: "client-1",
    };

    const message: SyncMessage = { type: "operation", operation: op };
    await hub.onMessage(ws, JSON.stringify(message));

    const state = await repo.getState();
    expect(state.shapes["new-shape"]).toBeDefined();
  });

  it("不正なJSONメッセージを無視する", async () => {
    const repo = new MemoryRepository();
    const hub = new Hub(repo);

    const ws = createMockWebSocket("client-1");
    await hub.onOpen(ws, "client-1");

    // 不正なJSONを送信
    await hub.onMessage(ws, "invalid json {{{");

    // エラーにならずに処理される
    expect(hub.getClientCount()).toBe(1);
  });

  it("broadcastFullStateが全クライアントに状態を送信する", async () => {
    const repo = new MemoryRepository();
    const hub = new Hub(repo);

    const ws1 = createMockWebSocket("client-1");
    const ws2 = createMockWebSocket("client-2");

    await hub.onOpen(ws1, "client-1");
    await hub.onOpen(ws2, "client-2");

    // 図形を追加
    await repo.applyOperation({
      type: "upsert",
      shape: createShape(),
      timestamp: 1000,
      clientId: "server",
    });

    // メッセージをクリア
    ws1.sentMessages.length = 0;
    ws2.sentMessages.length = 0;

    await hub.broadcastFullState();

    expect(ws1.sentMessages).toHaveLength(1);
    expect(ws2.sentMessages).toHaveLength(1);

    const syncMsg1: SyncMessage = JSON.parse(ws1.sentMessages[0]);
    expect(syncMsg1.type).toBe("sync");
    // state は ShapeEntry[] 配列形式
    expect(syncMsg1.state).toBeInstanceOf(Array);
    const entry = syncMsg1.state?.find((e) => e.shape.id === "shape-1");
    expect(entry).toBeDefined();
  });
});
