import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../domain/model/operation.dart';
import '../domain/model/shape.dart';
import '../domain/model/sync_message.dart';
import '../domain/repository/board_repository.dart';

/// WebSocketを使用したBoardRepositoryの実装
class WebSocketBoardRepository implements BoardRepository {
  WebSocketBoardRepository({
    required this.serverUrl,
  });

  /// サーバーURL
  final String serverUrl;

  /// WebSocketチャンネル
  WebSocketChannel? _channel;

  /// 接続中かどうか
  bool _isConnected = false;

  /// 接続状態のコントローラー
  final _connectionStateController = StreamController<bool>.broadcast();

  /// メッセージのコントローラー
  final _messagesController = StreamController<SyncMessage>.broadcast();

  @override
  Stream<bool> get connectionState => _connectionStateController.stream;

  @override
  Stream<SyncMessage> get messages => _messagesController.stream;

  /// 接続中かどうか
  bool get isConnected => _isConnected;

  @override
  Future<void> connect() async {
    if (_channel != null) {
      return;
    }

    try {
      _channel = WebSocketChannel.connect(Uri.parse(serverUrl));

      // 接続完了を待つ
      await _channel!.ready;
      _isConnected = true;
      _connectionStateController.add(true);

      // メッセージをリッスン
      _channel!.stream.listen(
        (data) {
          try {
            final json = jsonDecode(data as String) as Map<String, dynamic>;
            final message = SyncMessage.fromJson(json);
            _messagesController.add(message);
          } catch (e) {
            // JSON解析エラーは無視
          }
        },
        onError: (error) {
          _isConnected = false;
          _connectionStateController.add(false);
        },
        onDone: () {
          _isConnected = false;
          _connectionStateController.add(false);
          _channel = null;
        },
      );
    } catch (e) {
      _isConnected = false;
      _connectionStateController.add(false);
      _channel = null;
      // 接続失敗はログに出力するだけで再スローしない
      // ignore: avoid_print
      print('WebSocket connection failed: $e');
    }
  }

  @override
  Future<void> disconnect() async {
    await _channel?.sink.close();
    _channel = null;
    _isConnected = false;
    _connectionStateController.add(false);
  }

  @override
  Future<void> sendOperation(Operation operation) async {
    if (!_isConnected || _channel == null) {
      // 接続されていない場合は静かに失敗
      // ignore: avoid_print
      print('WebSocket is not connected, operation not sent');
      return;
    }

    final message = SyncMessage(
      type: MessageType.operation,
      operation: operation,
    );

    _channel!.sink.add(jsonEncode(message.toJson()));
  }

  @override
  Future<void> upsertShape(Shape shape, String clientId) async {
    final operation = Operation(
      type: OperationType.upsert,
      shapeId: shape.id,
      shape: shape,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      clientId: clientId,
    );

    await sendOperation(operation);
  }

  @override
  Future<void> deleteShape(String shapeId, String clientId) async {
    final operation = Operation(
      type: OperationType.delete,
      shapeId: shapeId,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      clientId: clientId,
    );

    await sendOperation(operation);
  }

  /// リソースの解放
  void dispose() {
    _channel?.sink.close();
    _connectionStateController.close();
    _messagesController.close();
  }
}
