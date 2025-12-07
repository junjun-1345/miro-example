import 'package:freezed_annotation/freezed_annotation.dart';
import 'shape.dart';

part 'crdt_state.freezed.dart';
part 'crdt_state.g.dart';

/// CRDTの状態を管理するコンテナ
/// LWW-Element-Setとして図形を管理
@freezed
sealed class CrdtState with _$CrdtState {
  const CrdtState._();

  const factory CrdtState({
    /// 図形エントリのマップ（shapeId -> ShapeEntry）
    @Default({}) Map<String, ShapeEntry> entries,

    /// 自分のクライアントID
    required String clientId,

    /// 接続中のクライアント数
    @Default(1) int clientCount,
  }) = _CrdtState;

  factory CrdtState.fromJson(Map<String, dynamic> json) =>
      _$CrdtStateFromJson(json);

  /// 削除されていない図形のリストを取得
  List<Shape> get activeShapes => entries.values
      .where((entry) => !entry.deleted)
      .map((entry) => entry.shape)
      .toList();

  /// 図形を追加または更新（LWW: Last Write Wins）
  CrdtState upsertShape(Shape shape, int timestamp) {
    final existing = entries[shape.id];

    // 既存のエントリがあり、タイムスタンプが新しい場合のみ更新
    if (existing != null && existing.timestamp >= timestamp) {
      return this;
    }

    final newEntry = ShapeEntry(
      shape: shape,
      timestamp: timestamp,
      deleted: false,
    );

    return copyWith(
      entries: {...entries, shape.id: newEntry},
    );
  }

  /// 図形を削除（tombstone方式）
  CrdtState deleteShape(String shapeId, int timestamp) {
    final existing = entries[shapeId];

    if (existing == null) {
      return this;
    }

    // タイムスタンプが新しい場合のみ削除
    if (existing.timestamp >= timestamp) {
      return this;
    }

    final tombstone = existing.copyWith(
      timestamp: timestamp,
      deleted: true,
    );

    return copyWith(
      entries: {...entries, shapeId: tombstone},
    );
  }

  /// 初期状態をマージ（サーバーからのsync）
  CrdtState mergeState(List<ShapeEntry> serverEntries) {
    final newEntries = Map<String, ShapeEntry>.from(entries);

    for (final entry in serverEntries) {
      final existing = newEntries[entry.shape.id];

      // 既存がないか、サーバーの方が新しい場合のみマージ
      if (existing == null || existing.timestamp < entry.timestamp) {
        newEntries[entry.shape.id] = entry;
      }
    }

    return copyWith(entries: newEntries);
  }
}
