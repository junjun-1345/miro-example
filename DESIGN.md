# リアルタイム共同編集ボード - 設計書

## 概要

Miroライクなリアルタイム共同編集ボードのMVP。
複数ユーザーが同じキャンバス上で図形を配置・移動・編集できる。
**CRDTを使用して競合のない同期を実現する。**

## 技術スタック

| レイヤー | 技術 |
|---------|------|
| Backend | Go + gorilla/websocket |
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

```go
type Shape struct {
    ID        string  `json:"id"`
    Type      string  `json:"type"`      // "rectangle", "circle"
    X         float64 `json:"x"`
    Y         float64 `json:"y"`
    Width     float64 `json:"width"`
    Height    float64 `json:"height"`
    Color     string  `json:"color"`
    Timestamp int64   `json:"timestamp"` // LWW用のタイムスタンプ
    ClientID  string  `json:"clientId"`  // 競合時のタイブレーカー
}
```

### CRDT State

```go
type CRDTState struct {
    Shapes map[string]ShapeEntry `json:"shapes"` // ID -> Entry
}

type ShapeEntry struct {
    Shape     Shape `json:"shape"`
    Timestamp int64 `json:"timestamp"`
    Deleted   bool  `json:"deleted"`
}
```

### WebSocketメッセージ

```go
type Operation struct {
    Type      string `json:"type"`      // "upsert", "delete"
    Shape     Shape  `json:"shape"`
    Timestamp int64  `json:"timestamp"`
    ClientID  string `json:"clientId"`
}

type SyncMessage struct {
    Type  string    `json:"type"` // "sync", "operation"
    State CRDTState `json:"state,omitempty"`
    Op    Operation `json:"op,omitempty"`
}
```

## Repository パターン（永続化抽象化）

将来の永続化に備え、Repositoryインターフェースで状態管理を抽象化。
遅延を挿入可能な設計にする。

### インターフェース定義

```go
// repository/repository.go
type StateRepository interface {
    // 状態の取得
    GetState(ctx context.Context) (*CRDTState, error)

    // 操作の適用（遅延挿入ポイント）
    ApplyOperation(ctx context.Context, op Operation) error

    // 状態のマージ
    MergeState(ctx context.Context, state CRDTState) error
}
```

### インメモリ実装（MVP）

```go
// repository/memory.go
type MemoryRepository struct {
    state *CRDTState
    mu    sync.RWMutex
    delay time.Duration // テスト用遅延
}

func NewMemoryRepository(delay time.Duration) *MemoryRepository {
    return &MemoryRepository{
        state: NewCRDTState(),
        delay: delay,
    }
}

func (r *MemoryRepository) ApplyOperation(ctx context.Context, op Operation) error {
    // 遅延シミュレーション（将来のDB書き込みを想定）
    if r.delay > 0 {
        select {
        case <-time.After(r.delay):
        case <-ctx.Done():
            return ctx.Err()
        }
    }

    r.mu.Lock()
    defer r.mu.Unlock()

    r.state.Apply(op)
    return nil
}

func (r *MemoryRepository) GetState(ctx context.Context) (*CRDTState, error) {
    if r.delay > 0 {
        select {
        case <-time.After(r.delay):
        case <-ctx.Done():
            return nil, ctx.Err()
        }
    }

    r.mu.RLock()
    defer r.mu.RUnlock()

    return r.state.Clone(), nil
}
```

### 将来のDB実装（例）

```go
// repository/postgres.go （将来実装）
type PostgresRepository struct {
    db *sql.DB
}

func (r *PostgresRepository) ApplyOperation(ctx context.Context, op Operation) error {
    // 実際のDB書き込み
    _, err := r.db.ExecContext(ctx,
        "INSERT INTO operations (type, shape_id, data, timestamp) VALUES ($1, $2, $3, $4)",
        op.Type, op.Shape.ID, op.Shape, op.Timestamp)
    return err
}
```

### 使用例

```go
// main.go
func main() {
    // 開発時: 遅延なし
    repo := repository.NewMemoryRepository(0)

    // テスト時: 100ms遅延でDB書き込みをシミュレート
    // repo := repository.NewMemoryRepository(100 * time.Millisecond)

    // 本番時: PostgreSQL
    // repo := repository.NewPostgresRepository(db)

    hub := NewHub(repo)
    // ...
}
```

## CRDT操作

### Merge（マージ）

```go
func (s *CRDTState) Merge(other CRDTState) {
    for id, entry := range other.Shapes {
        existing, exists := s.Shapes[id]
        if !exists || entry.Timestamp > existing.Timestamp ||
           (entry.Timestamp == existing.Timestamp &&
            entry.Shape.ClientID > existing.Shape.ClientID) {
            s.Shapes[id] = entry
        }
    }
}
```

### Apply（操作適用）

```go
func (s *CRDTState) Apply(op Operation) {
    switch op.Type {
    case "upsert":
        existing, exists := s.Shapes[op.Shape.ID]
        if !exists || op.Timestamp > existing.Timestamp {
            s.Shapes[op.Shape.ID] = ShapeEntry{
                Shape:     op.Shape,
                Timestamp: op.Timestamp,
                Deleted:   false,
            }
        }
    case "delete":
        if existing, exists := s.Shapes[op.Shape.ID]; exists {
            if op.Timestamp > existing.Timestamp {
                existing.Deleted = true
                existing.Timestamp = op.Timestamp
                s.Shapes[op.Shape.ID] = existing
            }
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
├── server/                 # Go バックエンド
│   ├── main.go
│   ├── crdt/
│   │   └── state.go       # CRDT実装
│   ├── repository/
│   │   ├── repository.go  # インターフェース
│   │   └── memory.go      # インメモリ実装
│   ├── hub.go             # WebSocket接続管理
│   ├── client.go          # クライアント接続
│   └── go.mod
├── client/                 # Flutter フロントエンド
│   ├── lib/
│   │   ├── main.dart
│   │   ├── crdt/          # CRDT実装
│   │   │   └── state.dart
│   │   ├── models/
│   │   │   └── shape.dart
│   │   ├── repositories/  # Repository（ローカル状態管理）
│   │   │   └── board_repository.dart
│   │   ├── services/
│   │   │   └── websocket_service.dart
│   │   └── widgets/
│   │       ├── canvas_widget.dart
│   │       └── shape_painter.dart
│   └── pubspec.yaml
├── DESIGN.md
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
