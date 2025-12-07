# リアルタイム共同編集ボード - 設計書

## 概要

Miroライクなリアルタイム共同編集ボードのMVP。
複数ユーザーが同じキャンバス上で図形を配置・移動・編集できる。
**CRDTを使用して競合のない同期を実現する。**

## 技術スタック

| レイヤー | 技術 |
|---------|------|
| Backend | **Hono + Bun** |
| Frontend | Flutter Web |
| 通信 | WebSocket |
| 同期方式 | **CRDT (LWW-Element-Set)** |
| 永続化 | なし（インメモリ）※将来対応可能な設計 |

## CRDTの選定

### なぜCRDTか？

- サーバーを経由せずにクライアント同士で状態を収束できる
- ネットワーク遅延や切断に強い
- 競合解決のロジックがシンプル

### 採用するCRDT: LWW-Element-Set

図形の集合を管理するのに適した **LWW-Element-Set (Last-Writer-Wins Element Set)** を採用。

```text
LWW-Element-Set = {
  addSet:    { (element, timestamp), ... }
  removeSet: { (element, timestamp), ... }
}

lookup(element):
  if element in addSet:
    if element not in removeSet:
      return true
    else:
      return addSet[element].timestamp > removeSet[element].timestamp
  return false
```

**特徴:**

- 追加・削除が同時に発生しても、タイムスタンプで解決
- 各図形のプロパティ変更もLWW Registerで管理

## アーキテクチャ

```text
┌─────────────────┐                    ┌─────────────────┐
│  Flutter Web A  │◄──────────────────►│   Go Server     │
│  (CRDT State)   │     WebSocket      │  (CRDT State)   │
└─────────────────┘                    └─────────────────┘
                                              ▲
┌─────────────────┐                           │
│  Flutter Web B  │◄──────────────────────────┘
│  (CRDT State)   │     WebSocket
└─────────────────┘

各クライアントが独自のCRDT状態を持ち、
操作をサーバー経由でブロードキャスト。
全ノードで状態が収束する。
```

## データモデル

### Shape（図形）

```typescript
interface Shape {
  id: string;
  type: "rectangle" | "circle";
  x: number;
  y: number;
  width: number;
  height: number;
  color: string;
  timestamp: number;  // LWW用のタイムスタンプ
  clientId: string;   // 競合時のタイブレーカー
}
```

### CRDT State

```typescript
interface ShapeEntry {
  shape: Shape;
  timestamp: number;
  deleted: boolean;
}

interface CRDTState {
  shapes: Record<string, ShapeEntry>;  // ID -> Entry
}
```

### WebSocketメッセージ

```typescript
interface Operation {
  type: "upsert" | "delete";
  shape: Shape;
  timestamp: number;
  clientId: string;
}

interface SyncMessage {
  type: "sync" | "operation";
  state?: CRDTState;  // type=sync の場合
  op?: Operation;     // type=operation の場合
}
```

## Repository パターン（永続化抽象化）

将来の永続化に備え、Repositoryインターフェースで状態管理を抽象化。
遅延を挿入可能な設計にする。

### インターフェース定義

```typescript
// src/repository/repository.ts
interface StateRepository {
  // 状態の取得
  getState(): Promise<CRDTState>;

  // 操作の適用（遅延挿入ポイント）
  applyOperation(op: Operation): Promise<void>;

  // 状態のマージ
  mergeState(state: CRDTState): Promise<void>;
}
```

### インメモリ実装（MVP）

```typescript
// src/repository/memory.ts
class MemoryRepository implements StateRepository {
  private state: CRDTState = { shapes: {} };
  private delay: number;  // テスト用遅延（ms）

  constructor(delay = 0) {
    this.delay = delay;
  }

  async applyOperation(op: Operation): Promise<void> {
    // 遅延シミュレーション（将来のDB書き込みを想定）
    if (this.delay > 0) {
      await new Promise(resolve => setTimeout(resolve, this.delay));
    }

    applyToCRDTState(this.state, op);
  }

  async getState(): Promise<CRDTState> {
    if (this.delay > 0) {
      await new Promise(resolve => setTimeout(resolve, this.delay));
    }

    return structuredClone(this.state);
  }
}
```

### 使用例

```typescript
// src/index.ts
// 開発時: 遅延なし
const repo = new MemoryRepository(0);

// テスト時: 100ms遅延でDB書き込みをシミュレート
// const repo = new MemoryRepository(100);

// 本番時: PostgreSQL
// const repo = new PostgresRepository(db);

const hub = new Hub(repo);
```

## CRDT操作

### Merge（マージ）

```typescript
function mergeCRDTState(state: CRDTState, other: CRDTState): void {
  for (const [id, entry] of Object.entries(other.shapes)) {
    const existing = state.shapes[id];
    if (!existing || entry.timestamp > existing.timestamp ||
        (entry.timestamp === existing.timestamp &&
         entry.shape.clientId > existing.shape.clientId)) {
      state.shapes[id] = entry;
    }
  }
}
```

### Apply（操作適用）

```typescript
function applyToCRDTState(state: CRDTState, op: Operation): void {
  switch (op.type) {
    case "upsert": {
      const existing = state.shapes[op.shape.id];
      if (!existing || op.timestamp > existing.timestamp ||
          (op.timestamp === existing.timestamp && op.clientId > existing.shape.clientId)) {
        state.shapes[op.shape.id] = {
          shape: op.shape,
          timestamp: op.timestamp,
          deleted: false,
        };
      }
      break;
    }
    case "delete": {
      const existing = state.shapes[op.shape.id];
      if (existing && op.timestamp > existing.timestamp) {
        state.shapes[op.shape.id] = {
          ...existing,
          timestamp: op.timestamp,
          deleted: true,
        };
      }
      break;
    }
  }
}
```

## WebSocket通信フロー

### 接続時

```text
Client                          Server
   │                               │
   │──── connect ─────────────────►│
   │                               │
   │◄─── sync (full state) ────────│
   │                               │
```

### 操作時

```text
Client A                        Server                      Client B
   │                               │                           │
   │── operation (upsert) ────────►│                           │
   │                               │── operation (upsert) ────►│
   │                               │                           │
   │                               │◄── operation (move) ──────│
   │◄── operation (move) ──────────│                           │
   │                               │                           │
```

## ディレクトリ構成

```text
miro-example/
├── server/                      # Hono + Bun バックエンド
│   ├── src/
│   │   ├── index.ts            # エントリーポイント
│   │   ├── domain/
│   │   │   ├── types.ts        # Shape, Operation等の型定義
│   │   │   └── crdt.ts         # CRDT操作
│   │   ├── repository/
│   │   │   ├── repository.ts   # インターフェース
│   │   │   └── memory.ts       # インメモリ実装
│   │   └── websocket/
│   │       └── hub.ts          # WebSocket接続管理
│   ├── package.json
│   └── tsconfig.json
├── client/                      # Flutter フロントエンド
│   ├── lib/
│   │   ├── main.dart
│   │   ├── domain/
│   │   │   ├── shape.dart
│   │   │   └── crdt.dart
│   │   ├── repository/
│   │   │   └── board_repository.dart
│   │   ├── service/
│   │   │   └── websocket_service.dart
│   │   └── presentation/
│   │       ├── board_page.dart
│   │       └── widgets/
│   │           ├── canvas_widget.dart
│   │           └── shape_painter.dart
│   └── pubspec.yaml
├── DESIGN.md
├── CLAUDE.md
└── README.md
```

## 画面設計

```text
┌────────────────────────────────────────┐
│ ツールバー: [□ 四角] [○ 円] [🗑️ 削除]  │
├────────────────────────────────────────┤
│                                        │
│                                        │
│           キャンバス領域                │
│     （図形をドラッグで配置・移動）       │
│                                        │
│                                        │
├────────────────────────────────────────┤
│ 接続状態: ● Connected  参加者: 2人      │
└────────────────────────────────────────┘
```

## MVP機能スコープ

### 含める

- [x] 四角形の追加・移動・削除
- [x] 円形の追加・移動・削除
- [x] CRDTによるリアルタイム同期
- [x] 複数ユーザー対応
- [x] オフライン操作後の再同期
- [x] Repository抽象化（永続化準備）

### 含めない（将来対応）

- [ ] テキスト/付箋
- [ ] 線/矢印で接続
- [ ] 永続化（Repository実装を差し替えるだけ）
- [ ] ルーム機能
- [ ] ズーム/パン
- [ ] Undo/Redo

## 開発フェーズ

### Phase 1: CRDT実装

1. Go側のCRDT State実装
2. Dart側のCRDT State実装
3. マージロジックのテスト

### Phase 2: バックエンド

1. Goプロジェクト初期化
2. Repositoryインターフェース実装
3. WebSocketサーバー実装
4. 接続管理とブロードキャスト

### Phase 3: フロントエンド

1. Flutterプロジェクト初期化
2. WebSocket接続
3. Canvas描画とCustomPainter

### Phase 4: 統合

1. 図形の追加・移動・削除
2. 複数ブラウザでの同期テスト
3. ネットワーク切断/再接続テスト
