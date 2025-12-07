// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shape.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Shape _$ShapeFromJson(Map<String, dynamic> json) => _Shape(
  id: json['id'] as String,
  type: $enumDecode(_$ShapeTypeEnumMap, json['type']),
  x: (json['x'] as num).toDouble(),
  y: (json['y'] as num).toDouble(),
  width: (json['width'] as num).toDouble(),
  height: (json['height'] as num).toDouble(),
  color: (json['color'] as num).toInt(),
);

Map<String, dynamic> _$ShapeToJson(_Shape instance) => <String, dynamic>{
  'id': instance.id,
  'type': _$ShapeTypeEnumMap[instance.type]!,
  'x': instance.x,
  'y': instance.y,
  'width': instance.width,
  'height': instance.height,
  'color': instance.color,
};

const _$ShapeTypeEnumMap = {
  ShapeType.rectangle: 'rectangle',
  ShapeType.ellipse: 'ellipse',
  ShapeType.triangle: 'triangle',
};

_ShapeEntry _$ShapeEntryFromJson(Map<String, dynamic> json) => _ShapeEntry(
  shape: Shape.fromJson(json['shape'] as Map<String, dynamic>),
  timestamp: (json['timestamp'] as num).toInt(),
  deleted: json['deleted'] as bool? ?? false,
);

Map<String, dynamic> _$ShapeEntryToJson(_ShapeEntry instance) =>
    <String, dynamic>{
      'shape': instance.shape,
      'timestamp': instance.timestamp,
      'deleted': instance.deleted,
    };
