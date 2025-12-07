/**
 * サーバーエントリーポイント
 * Hono + Bun.serve()でHTTP、WebSocket、Swagger UIを提供
 */

import { OpenAPIHono, createRoute, z } from "@hono/zod-openapi";
import { swaggerUI } from "@hono/swagger-ui";
import { type ClientData, Hub } from "./websocket";
import { MemoryRepository } from "./repository";

/** サーバー設定 */
const PORT = Number(process.env.PORT) || 8080;

/** リポジトリとHubの初期化 */
const repository = new MemoryRepository();
const hub = new Hub(repository);

/** OpenAPI設定 */
const app = new OpenAPIHono();

/** スキーマ定義 */
const HealthResponseSchema = z
  .object({
    status: z.string().openapi({ example: "ok" }),
    clients: z.number().openapi({ example: 2 }),
  })
  .openapi("HealthResponse");

const ShapeSchema = z
  .object({
    id: z.string().openapi({ example: "shape-123" }),
    type: z.enum(["rectangle", "circle"]).openapi({ example: "rectangle" }),
    x: z.number().openapi({ example: 100 }),
    y: z.number().openapi({ example: 100 }),
    width: z.number().openapi({ example: 50 }),
    height: z.number().openapi({ example: 50 }),
    color: z.string().openapi({ example: "#ff0000" }),
    timestamp: z.number().openapi({ example: 1699999999999 }),
    clientId: z.string().openapi({ example: "client-abc" }),
  })
  .openapi("Shape");

const StateResponseSchema = z
  .object({
    shapes: z.record(
      z.string(),
      z.object({
        shape: ShapeSchema,
        timestamp: z.number(),
        deleted: z.boolean(),
      })
    ),
  })
  .openapi("StateResponse");

/** ルート定義 */

// ヘルスチェック
const healthRoute = createRoute({
  method: "get",
  path: "/health",
  tags: ["Health"],
  summary: "ヘルスチェック",
  description: "サーバーの稼働状態と接続クライアント数を返す",
  responses: {
    200: {
      description: "サーバー正常",
      content: {
        "application/json": {
          schema: HealthResponseSchema,
        },
      },
    },
  },
});

app.openapi(healthRoute, (c) => {
  return c.json({
    status: "ok",
    clients: hub.getClientCount(),
  });
});

// 状態取得
const stateRoute = createRoute({
  method: "get",
  path: "/api/state",
  tags: ["State"],
  summary: "現在の状態を取得",
  description: "CRDT状態（全図形）を取得する",
  responses: {
    200: {
      description: "現在の状態",
      content: {
        "application/json": {
          schema: StateResponseSchema,
        },
      },
    },
  },
});

app.openapi(stateRoute, async (c) => {
  const state = await repository.getState();
  return c.json(state);
});

// OpenAPIドキュメント
app.doc("/doc", {
  openapi: "3.0.0",
  info: {
    title: "Miro Example API",
    version: "1.0.0",
    description: "リアルタイム協調編集ボードのAPIドキュメント",
  },
  servers: [
    {
      url: `http://localhost:${PORT}`,
      description: "ローカル開発サーバー",
    },
  ],
});

// Swagger UI
app.get("/swagger", swaggerUI({ url: "/doc" }));

// AsyncAPI YAMLを提供
app.get("/asyncapi.yaml", async (c) => {
  const file = Bun.file(new URL("./asyncapi.yaml", import.meta.url).pathname);
  const content = await file.text();
  return c.text(content, 200, {
    "Content-Type": "application/yaml",
  });
});

// AsyncAPI UI（Swagger UIと同様のWebビュー）
app.get("/asyncapi", async (c) => {
  const file = Bun.file(new URL("./asyncapi.yaml", import.meta.url).pathname);
  const spec = await file.text();

  return c.html(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>AsyncAPI - Miro Example WebSocket API</title>
      <link rel="stylesheet" href="https://unpkg.com/@asyncapi/react-component@1.4.10/styles/default.min.css">
      <style>
        body { margin: 0; padding: 0; }
      </style>
    </head>
    <body>
      <div id="asyncapi"></div>
      <script src="https://unpkg.com/@asyncapi/react-component@1.4.10/browser/standalone/index.js"></script>
      <script>
        const spec = ${JSON.stringify(spec)};
        AsyncApiStandalone.render({
          schema: {
            url: '/asyncapi.yaml',
            options: { method: 'GET', mode: 'cors' }
          },
          config: {
            show: {
              sidebar: true,
              info: true,
              servers: true,
              operations: true,
              messages: true,
              schemas: true,
            }
          }
        }, document.getElementById('asyncapi'));
      </script>
    </body>
    </html>
  `);
});

// ルートパス（APIドキュメントへのリンク）
app.get("/", (c) => {
  return c.html(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>Miro Example Server</title>
      <style>
        body { font-family: system-ui, sans-serif; max-width: 600px; margin: 50px auto; padding: 20px; }
        h1 { color: #333; }
        ul { list-style: none; padding: 0; }
        li { margin: 10px 0; }
        a { color: #0066cc; text-decoration: none; }
        a:hover { text-decoration: underline; }
        .badge { background: #eee; padding: 2px 8px; border-radius: 4px; font-size: 12px; }
      </style>
    </head>
    <body>
      <h1>Miro Example Server</h1>
      <p>リアルタイム協調編集ボード API</p>
      <h2>API Documentation</h2>
      <ul>
        <li><a href="/swagger">Swagger UI</a> <span class="badge">REST API</span></li>
        <li><a href="/asyncapi">AsyncAPI UI</a> <span class="badge">WebSocket</span></li>
      </ul>
      <h2>Endpoints</h2>
      <ul>
        <li><code>GET /health</code> - ヘルスチェック</li>
        <li><code>GET /api/state</code> - 現在の状態取得</li>
        <li><code>WS /ws</code> - WebSocket接続</li>
      </ul>
    </body>
    </html>
  `);
});

/** サーバー起動（Bun.serve） */
const server = Bun.serve<ClientData>({
  port: PORT,
  fetch: app.fetch,
  websocket: {
    async open(ws) {
      const clientId = ws.data.clientId;
      console.log(`Client connected: ${clientId}`);
      await hub.onOpen(ws, clientId);
    },
    async message(ws, message) {
      await hub.onMessage(ws, message);
    },
    close(ws) {
      const clientId = ws.data.clientId;
      console.log(`Client disconnected: ${clientId}`);
      hub.onClose(ws);
    },
  },
});

// WebSocketアップグレード用のミドルウェア
app.get("/ws", (c) => {
  const clientId =
    c.req.query("clientId") || crypto.randomUUID();

  const success = server.upgrade(c.req.raw, {
    data: { clientId },
  });

  if (success) {
    return new Response(null, { status: 101 });
  }
  return c.text("WebSocket upgrade failed", 400);
});

console.log(`Server running on http://localhost:${server.port}`);
console.log(`Swagger UI: http://localhost:${server.port}/swagger`);
console.log(`AsyncAPI UI: http://localhost:${server.port}/asyncapi`);
console.log(`WebSocket endpoint: ws://localhost:${server.port}/ws`);
