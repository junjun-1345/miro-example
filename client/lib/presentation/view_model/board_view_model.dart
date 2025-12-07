import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../domain/model/crdt_state.dart';
import '../../domain/model/operation.dart';
import '../../domain/model/shape.dart';
import '../../domain/model/sync_message.dart';
import '../../domain/repository/board_repository.dart';
import '../../infrastructure/websocket_board_repository.dart';

part 'board_view_model.g.dart';

/// クライアントIDを生成するProvider
@riverpod
String clientId(Ref ref) {
  return const Uuid().v4();
}

/// WebSocketのURLを提供するProvider
@riverpod
String serverUrl(Ref ref) {
  // ローカル開発用のデフォルトURL
  return 'ws://localhost:8080/ws';
}

/// BoardRepositoryのProvider
@riverpod
BoardRepository boardRepository(Ref ref) {
  final serverUrl = ref.watch(serverUrlProvider);
  final repository = WebSocketBoardRepository(serverUrl: serverUrl);

  ref.onDispose(() {
    repository.dispose();
  });

  return repository;
}

/// CRDT状態を管理するNotifier
@riverpod
class BoardNotifier extends _$BoardNotifier {
  StreamSubscription<SyncMessage>? _messageSubscription;

  @override
  CrdtState build() {
    final clientId = ref.watch(clientIdProvider);
    final repository = ref.watch(boardRepositoryProvider);

    // WebSocket接続
    _connect(repository);

    // メッセージのリッスン
    _messageSubscription = repository.messages.listen(_handleMessage);

    ref.onDispose(() {
      _messageSubscription?.cancel();
      repository.disconnect();
    });

    return CrdtState(clientId: clientId);
  }

  Future<void> _connect(BoardRepository repository) async {
    try {
      await repository.connect();
    } catch (e) {
      // 接続エラーは無視（再接続ロジックは後で追加）
    }
  }

  /// サーバーからのメッセージを処理
  void _handleMessage(SyncMessage message) {
    switch (message.type) {
      case MessageType.operation:
        if (message.operation != null) {
          _applyOperation(message.operation!);
        }
      case MessageType.sync:
        if (message.state != null) {
          state = state.mergeState(message.state!);
        }
      case MessageType.join:
        if (message.clientCount != null) {
          state = state.copyWith(clientCount: message.clientCount!);
        }
      case MessageType.leave:
        if (message.clientCount != null) {
          state = state.copyWith(clientCount: message.clientCount!);
        }
    }
  }

  /// 操作を適用
  void _applyOperation(Operation operation) {
    switch (operation.type) {
      case OperationType.upsert:
        if (operation.shape != null) {
          state = state.upsertShape(operation.shape!, operation.timestamp);
        }
      case OperationType.delete:
        state = state.deleteShape(operation.shapeId, operation.timestamp);
    }
  }

  /// 図形を追加
  Future<void> addShape(ShapeType type, double x, double y) async {
    final repository = ref.read(boardRepositoryProvider);
    final newShape = Shape(
      id: const Uuid().v4(),
      type: type,
      x: x,
      y: y,
      width: 100,
      height: 100,
      color: 0xFF2196F3, // Blue
    );

    // ローカル状態を更新
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    state = state.upsertShape(newShape, timestamp);

    // サーバーに送信
    await repository.upsertShape(newShape, state.clientId);
  }

  /// 図形を更新
  Future<void> updateShape(Shape shape) async {
    final repository = ref.read(boardRepositoryProvider);

    // ローカル状態を更新
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    state = state.upsertShape(shape, timestamp);

    // サーバーに送信
    await repository.upsertShape(shape, state.clientId);
  }

  /// 図形を削除
  Future<void> deleteShape(String shapeId) async {
    final repository = ref.read(boardRepositoryProvider);

    // ローカル状態を更新
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    state = state.deleteShape(shapeId, timestamp);

    // サーバーに送信
    await repository.deleteShape(shapeId, state.clientId);
  }

  /// 図形を移動
  Future<void> moveShape(String shapeId, double dx, double dy) async {
    final shape = state.entries[shapeId]?.shape;
    if (shape == null || state.entries[shapeId]!.deleted) {
      return;
    }

    final updatedShape = shape.copyWith(
      x: shape.x + dx,
      y: shape.y + dy,
    );

    await updateShape(updatedShape);
  }

  /// 図形をリサイズ
  Future<void> resizeShape(
    String shapeId,
    double newWidth,
    double newHeight,
  ) async {
    final shape = state.entries[shapeId]?.shape;
    if (shape == null || state.entries[shapeId]!.deleted) {
      return;
    }

    final updatedShape = shape.copyWith(
      width: newWidth,
      height: newHeight,
    );

    await updateShape(updatedShape);
  }
}

/// 接続状態を監視するProvider
@riverpod
Stream<bool> connectionState(Ref ref) {
  final repository = ref.watch(boardRepositoryProvider);
  return repository.connectionState;
}
