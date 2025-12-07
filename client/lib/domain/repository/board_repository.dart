import '../model/operation.dart';
import '../model/shape.dart';
import '../model/sync_message.dart';

/// ボードリポジトリのインターフェース
/// WebSocket通信を抽象化し、将来的な永続化層への拡張を可能にする
abstract class BoardRepository {
  /// WebSocket接続を開始
  Future<void> connect();

  /// WebSocket接続を終了
  Future<void> disconnect();

  /// 接続状態のストリーム
  Stream<bool> get connectionState;

  /// サーバーからのメッセージストリーム
  Stream<SyncMessage> get messages;

  /// 操作をサーバーに送信
  Future<void> sendOperation(Operation operation);

  /// 図形を追加/更新
  Future<void> upsertShape(Shape shape, String clientId);

  /// 図形を削除
  Future<void> deleteShape(String shapeId, String clientId);
}
