# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Miroライクなリアルタイム共同編集ボードのMVP。CRDTを使用して競合のない同期を実現する。

## Tech Stack

- **Backend**: Hono + Bun
- **Frontend**: Flutter Web
- **Sync**: CRDT (LWW-Element-Set)
- **Persistence**: In-memory (Repository pattern for future DB)

## Architecture

モノレポ構成:
- `server/` - Hono + Bun バックエンド
- `client/` - Flutter フロントエンド

各クライアントとサーバーがCRDT状態を持ち、WebSocketでOperationをブロードキャスト。全ノードで状態が収束する。

## Commands

### Backend (Hono + Bun)

```bash
# Run server
cd server && bun run dev

# Run tests
cd server && bun test

# Run single test
cd server && bun test --grep "test name"
```

### Frontend (Flutter)

```bash
# Run web
cd client && flutter run -d chrome

# Run tests
cd client && flutter test

# Run single test
cd client && flutter test test/path_to_test.dart
```

## Key Concepts

### CRDT (LWW-Element-Set)

- タイムスタンプが新しい操作が勝つ
- 同一タイムスタンプの場合はClientIDで決定
- 詳細は DESIGN.md を参照

### Repository Pattern

永続化を抽象化。`StateRepository`インターフェースで遅延挿入可能。
- MVP: `MemoryRepository`（インメモリ）
- 将来: DB実装に差し替え可能
