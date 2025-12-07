/**
 * メインサーバーエントリーポイント
 * Hono + Bun.serve() でHTTP/WebSocketサーバーを起動
 */

import { Hono } from "hono";
import { cors } from "hono/cors";
import type { ServerWebSocket } from "bun";
import { Hub, type ClientData } from "./websocket/index";
import { MemoryRepository } from "./repository/index";

const app = new Hono();
const repository = new MemoryRepository();
const hub = new Hub(repository);

// CORSを有効化
app.use("*", cors());

// ヘルスチェック
app.get("/health", (c) => c.json({ status: "ok" }));

// クライアント数取得
app.get("/clients", (c) => c.json({ count: hub.getClientCount() }));

const port = parseInt(process.env.PORT || "8080", 10);

console.log(`🚀 Server starting on http://localhost:${port}`);
console.log(`   WebSocket: ws://localhost:${port}/ws`);
console.log(`   Health: http://localhost:${port}/health`);

const server = Bun.serve<ClientData>({
  port,
  fetch(req, server) {
    const url = new URL(req.url);

    // WebSocketアップグレード
    if (url.pathname === "/ws") {
      const clientId = crypto.randomUUID();
      const success = server.upgrade(req, {
        data: { clientId },
      });
      if (success) {
        return undefined;
      }
      return new Response("WebSocket upgrade failed", { status: 400 });
    }

    // HonoでHTTPリクエストを処理
    return app.fetch(req);
  },
  websocket: {
    open(ws: ServerWebSocket<ClientData>) {
      const clientId = ws.data.clientId;
      hub.onOpen(ws, clientId);
      console.log(`Client connected: ${clientId} (total: ${hub.getClientCount()})`);
    },
    message(ws: ServerWebSocket<ClientData>, message) {
      hub.onMessage(ws, message);
    },
    close(ws: ServerWebSocket<ClientData>) {
      const clientId = ws.data?.clientId;
      hub.onClose(ws);
      console.log(`Client disconnected: ${clientId} (total: ${hub.getClientCount()})`);
    },
  },
});
