# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Miroライクなリアルタイム共同編集ボードのMVP。CRDTを使用して競合のない同期を実現する。

## Tech Stack

- **Backend**: Hono + Bun (TypeScript)
- **Frontend**: Flutter Web (Dart)
- **State Management**: Riverpod + flutter_hooks
- **Models**: Freezed (immutable, JSON serialization)
- **Sync**: CRDT (LWW-Element-Set) via WebSocket
- **Persistence**: In-memory (Repository pattern for future DB)

## Architecture

モノレポ構成:
- `server/` - Hono + Bun バックエンド（domain, repository, websocket層）
- `client/` - Flutter フロントエンド（MVVM + Repository pattern）

各クライアントとサーバーがCRDT状態を持ち、WebSocketでOperationをブロードキャスト。全ノードで状態が収束する。

## Commands

### mise tasks（推奨）

```bash
# サーバー + クライアント3つを同時起動
mise run dev

# 個別起動
mise run server              # サーバー起動（port 8080）
mise run client              # クライアント1（port 5000）
mise run client2             # クライアント2（port 5001）
mise run client3             # クライアント3（port 5002）

# コード生成
mise run build               # freezed/riverpod生成
mise run watch               # 監視モード
```

### Backend (Hono + Bun)

```bash
cd server && bun run dev           # 開発サーバー起動
cd server && bun test              # 全テスト実行
cd server && bun test --grep "test name"  # 単一テスト
```

### Frontend (Flutter)

```bash
cd client && flutter run -d chrome       # Web実行
cd client && flutter test                # 全テスト
cd client && flutter test test/xxx.dart  # 単一テスト
cd client && flutter analyze             # 静的解析

# コード生成（freezed, json_serializable, riverpod_generator）
cd client && dart run build_runner build --delete-conflicting-outputs
```

## Key Concepts

### CRDT (LWW-Element-Set)

- タイムスタンプが新しい操作が勝つ
- 同一タイムスタンプの場合はClientID（辞書順）で決定
- 詳細は DESIGN.md を参照

### Repository Pattern

永続化を抽象化。`StateRepository`インターフェースで遅延挿入可能。
- MVP: `MemoryRepository`（インメモリ）
- 将来: DB実装に差し替え可能

### Flutter Client Architecture

MVVM + Clean Architecture:
- `domain/model/` - Freezedモデル（sealed class必須）
- `domain/repository/` - Repositoryインターフェース
- `infrastructure/` - WebSocket実装
- `presentation/view_model/` - Riverpod Notifier（@riverpodアノテーション）
- `presentation/view/` - HookConsumerWidget（StatefulWidget禁止）
- `presentation/widget/` - 再利用可能なウィジェット

## Coding Conventions

- コメントは日本語
- FlutterはRiverpod 3系 + hooks + Freezed 3系を使用
- Freezedクラスにはsealedキーワードをつける
- StatefulWidgetは使用禁止、HookConsumerWidgetを使う
- 生成ファイル（*.freezed.dart, *.g.dart）はソース管理対象外
