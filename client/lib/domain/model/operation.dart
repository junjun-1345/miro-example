import 'package:freezed_annotation/freezed_annotation.dart';
import 'shape.dart';

part 'operation.freezed.dart';
part 'operation.g.dart';

/// 操作の種類
enum OperationType {
  @JsonValue('upsert')
  upsert,
  @JsonValue('delete')
  delete,
}

/// CRDT操作を表すモデル
/// サーバーとクライアント間で同期される
@freezed
sealed class Operation with _$Operation {
  const factory Operation({
    /// 操作の種類
    required OperationType type,

    /// 対象の図形ID
    required String shapeId,

    /// 図形データ（upsert時のみ）
    Shape? shape,

    /// 操作のタイムスタンプ（ミリ秒）
    required int timestamp,

    /// 操作を行ったクライアントID
    required String clientId,
  }) = _Operation;

  factory Operation.fromJson(Map<String, dynamic> json) =>
      _$OperationFromJson(json);
}
