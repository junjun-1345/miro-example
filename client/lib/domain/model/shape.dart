import 'package:freezed_annotation/freezed_annotation.dart';

part 'shape.freezed.dart';
part 'shape.g.dart';

/// 図形の種類
enum ShapeType {
  @JsonValue('rectangle')
  rectangle,
  @JsonValue('ellipse')
  ellipse,
  @JsonValue('triangle')
  triangle,
}

/// キャンバス上の図形を表すモデル
@freezed
sealed class Shape with _$Shape {
  const factory Shape({
    /// 図形の一意識別子
    required String id,

    /// 図形の種類
    required ShapeType type,

    /// X座標
    required double x,

    /// Y座標
    required double y,

    /// 幅
    required double width,

    /// 高さ
    required double height,

    /// 塗りつぶし色（ARGB形式）
    required int color,

  }) = _Shape;

  factory Shape.fromJson(Map<String, dynamic> json) => _$ShapeFromJson(json);
}

/// CRDT用のタイムスタンプ付き図形エントリ
/// LWW-Element-Setで使用
@freezed
sealed class ShapeEntry with _$ShapeEntry {
  const factory ShapeEntry({
    /// 図形データ
    required Shape shape,

    /// 最終更新タイムスタンプ（ミリ秒）
    required int timestamp,

    /// 削除済みフラグ（tombstone）
    @Default(false) bool deleted,
  }) = _ShapeEntry;

  factory ShapeEntry.fromJson(Map<String, dynamic> json) =>
      _$ShapeEntryFromJson(json);
}
