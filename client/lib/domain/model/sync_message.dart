import 'package:freezed_annotation/freezed_annotation.dart';
import 'operation.dart';
import 'shape.dart';

part 'sync_message.freezed.dart';
part 'sync_message.g.dart';

/// WebSocketメッセージの種類
enum MessageType {
  /// 操作の送信/受信
  @JsonValue('operation')
  operation,

  /// 初期状態の同期
  @JsonValue('sync')
  sync,

  /// クライアント参加通知
  @JsonValue('join')
  join,

  /// クライアント退出通知
  @JsonValue('leave')
  leave,
}

/// WebSocket同期メッセージ
@freezed
sealed class SyncMessage with _$SyncMessage {
  const factory SyncMessage({
    /// メッセージの種類
    required MessageType type,

    /// 操作データ（type=operationの場合）
    Operation? operation,

    /// 初期同期データ（type=syncの場合）
    List<ShapeEntry>? state,

    /// クライアントID（type=join/leaveの場合）
    String? clientId,

    /// 接続中のクライアント数
    int? clientCount,
  }) = _SyncMessage;

  factory SyncMessage.fromJson(Map<String, dynamic> json) =>
      _$SyncMessageFromJson(json);
}
