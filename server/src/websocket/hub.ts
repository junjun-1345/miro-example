/**
 * WebSocket Hub
 * クライアント接続の管理とメッセージブロードキャスト
 */

import type { ServerWebSocket } from "bun";
import type { Operation, SyncMessage } from "../domain";
import type { StateRepository } from "../repository";

/** クライアント接続のメタデータ */
export interface ClientData {
  clientId: string;
}

/**
 * WebSocket Hub
 * 複数クライアントの接続を管理し、操作をブロードキャスト
 */
export class Hub {
  /** 接続中のクライアント */
  private clients: Map<string, ServerWebSocket<ClientData>> = new Map();

  /** 状態リポジトリ */
  private readonly repository: StateRepository;

  constructor(repository: StateRepository) {
    this.repository = repository;
  }

  /**
   * 新しいクライアント接続を登録
   * @param ws WebSocket接続
   * @param clientId クライアントID
   */
  async onOpen(
    ws: ServerWebSocket<ClientData>,
    clientId: string
  ): Promise<void> {
    this.clients.set(clientId, ws);

    // 現在の状態を新しいクライアントに送信
    const state = await this.repository.getState();
    const syncMessage: SyncMessage = {
      type: "sync",
      state,
    };

    ws.send(JSON.stringify(syncMessage));
  }

  /**
   * クライアントからのメッセージを処理
   * @param ws WebSocket接続
   * @param message 受信したメッセージ
   */
  async onMessage(
    ws: ServerWebSocket<ClientData>,
    message: string | Buffer
  ): Promise<void> {
    const msgStr = typeof message === "string" ? message : message.toString();

    let syncMessage: SyncMessage;
    try {
      syncMessage = JSON.parse(msgStr);
    } catch {
      console.error("Invalid JSON message:", msgStr);
      return;
    }

    if (syncMessage.type === "operation" && syncMessage.op) {
      await this.handleOperation(ws, syncMessage.op);
    }
  }

  /**
   * 操作メッセージを処理
   * @param sender 送信元のWebSocket
   * @param op 操作
   */
  private async handleOperation(
    sender: ServerWebSocket<ClientData>,
    op: Operation
  ): Promise<void> {
    // リポジトリに操作を適用
    await this.repository.applyOperation(op);

    // 他のクライアントにブロードキャスト（送信元以外）
    const message: SyncMessage = {
      type: "operation",
      op,
    };
    const msgStr = JSON.stringify(message);

    for (const [clientId, client] of this.clients) {
      if (client !== sender) {
        try {
          client.send(msgStr);
        } catch (error) {
          console.error(`Failed to send to client ${clientId}:`, error);
          // 送信失敗したクライアントは削除
          this.clients.delete(clientId);
        }
      }
    }
  }

  /**
   * クライアント切断を処理
   * @param ws WebSocket接続
   */
  onClose(ws: ServerWebSocket<ClientData>): void {
    const clientId = ws.data?.clientId;
    if (clientId) {
      this.clients.delete(clientId);
    }
  }

  /**
   * 接続中のクライアント数を取得
   */
  getClientCount(): number {
    return this.clients.size;
  }

  /**
   * 全クライアントに状態を同期（再接続時など）
   */
  async broadcastFullState(): Promise<void> {
    const state = await this.repository.getState();
    const syncMessage: SyncMessage = {
      type: "sync",
      state,
    };
    const msgStr = JSON.stringify(syncMessage);

    for (const [clientId, client] of this.clients) {
      try {
        client.send(msgStr);
      } catch (error) {
        console.error(`Failed to sync to client ${clientId}:`, error);
        this.clients.delete(clientId);
      }
    }
  }
}
