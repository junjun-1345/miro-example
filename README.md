# リアルタイム共同編集ボード

Miroライクなリアルタイム共同編集ボードのMVP実装です。
複数ユーザーが同じキャンバス上で図形を配置・移動・削除できます。

**CRDT (Conflict-free Replicated Data Type)** を使用して、競合のない同期を実現しています。

![Demo](https://img.shields.io/badge/status-MVP-green)

## 特徴

- **リアルタイム同期**: 複数クライアント間で図形操作が即座に反映
- **競合解決**: CRDT (LWW-Element-Set) による自動競合解決
- **オフライン耐性**: ネットワーク切断後も操作可能、再接続時に自動同期
- **シンプルな構成**: モノレポ構成でフロントエンド・バックエンドを一元管理

## 技術スタック

| レイヤー | 技術 |
|---------|------|
| Backend | Hono + Bun (TypeScript) |
| Frontend | Flutter Web (Dart) |
| 状態管理 | Riverpod + flutter_hooks |
| モデル | Freezed (immutable, JSON serialization) |
| 通信 | WebSocket |
| 同期方式 | CRDT (LWW-Element-Set) |

## 必要要件

- [mise](https://mise.jdx.dev/) (推奨)

mise を使用すると、Bun と Flutter が自動的にインストールされます。

## セットアップ

### 1. リポジトリをクローン

```bash
git clone https://github.com/junjun-1345/miro-example.git
cd miro-example
```

### 2. mise でツールをインストール

```bash
mise install
```

### 3. 依存関係のインストールとコード生成

```bash
mise run setup
```

これで以下が実行されます：
- サーバーの依存関係インストール (`bun install`)
- クライアントの依存関係インストール (`flutter pub get`)
- Freezed/Riverpodのコード生成 (`build_runner`)

## 起動方法

### mise を使用する場合（推奨）

```bash
# サーバー + クライアントを起動
mise run dev
```

個別に起動する場合（複数ターミナルで）:

```bash
mise run server    # サーバー (port 8080)
mise run client    # クライアント1
mise run client2   # クライアント2
mise run client3   # クライアント3
```

全プロセスを停止:

```bash
mise run kill
```

### 手動で起動する場合

**サーバー:**

```bash
cd server && bun run src/index.ts
```

**クライアント:**

```bash
cd client && flutter run -d chrome --web-port=5000
```

複数クライアントを起動する場合は、異なるポートを指定:

```bash
flutter run -d chrome --web-port=5001
flutter run -d chrome --web-port=5002
```

## 使い方

1. ブラウザで `http://localhost:5000` を開く
2. ツールバーから図形（四角形、円、三角形）を選択
3. キャンバスをクリックして図形を配置
4. 図形をドラッグして移動
5. 図形を選択して削除ボタン or Delete/Backspaceキーで削除

複数のブラウザタブ/ウィンドウで開くと、リアルタイムに同期されます。

## プロジェクト構成

```
miro-example/
├── server/                 # バックエンド (Hono + Bun)
│   ├── src/
│   │   ├── index.ts       # エントリーポイント
│   │   ├── domain/        # ドメインロジック (CRDT)
│   │   ├── repository/    # 状態管理 (Repository pattern)
│   │   └── websocket/     # WebSocket Hub
│   └── package.json
│
├── client/                 # フロントエンド (Flutter)
│   ├── lib/
│   │   ├── main.dart
│   │   ├── domain/        # モデル (Freezed)
│   │   ├── infrastructure/# WebSocket実装
│   │   └── presentation/  # UI (Riverpod + hooks)
│   └── pubspec.yaml
│
├── DESIGN.md              # 設計ドキュメント
├── CLAUDE.md              # Claude Code用ガイドライン
└── README.md
```

## 開発コマンド

### mise タスク一覧

```bash
mise run setup      # 依存関係インストール + コード生成
mise run install    # 依存関係インストールのみ
mise run build      # Freezedコード生成
mise run watch      # Freezedコード生成（監視モード）
mise run server     # サーバー起動
mise run client     # クライアント起動
mise run dev        # サーバー + クライアント起動
mise run kill       # 全プロセス停止
mise run web-build  # Flutter Webビルド
```

### サーバー

```bash
cd server
bun run src/index.ts  # 開発サーバー起動
bun test              # テスト実行
bun test --watch      # テスト監視モード
```

### クライアント

```bash
cd client
flutter run -d chrome           # Web実行
flutter run -d macos            # macOS実行
flutter test                    # テスト実行
flutter analyze                 # 静的解析

# コード生成
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch     # 監視モード
```

## アーキテクチャ

```
┌─────────────────┐                    ┌─────────────────┐
│  Flutter Web A  │◄──────────────────►│   Bun Server    │
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

## CRDT について

このプロジェクトでは **LWW-Element-Set (Last-Writer-Wins Element Set)** を採用しています。

- **タイムスタンプベース**: 最新の操作が優先される
- **タイブレーカー**: 同一タイムスタンプの場合はクライアントIDで決定
- **Tombstone方式**: 削除は論理削除として記録

詳細は [DESIGN.md](./DESIGN.md) を参照してください。

## API ドキュメント

サーバー起動後、以下のURLでAPIドキュメントを確認できます:

- Swagger UI: http://localhost:8080/docs
- AsyncAPI (WebSocket): `server/src/asyncapi.yaml`

## ライセンス

MIT License

Copyright (c) 2024

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
