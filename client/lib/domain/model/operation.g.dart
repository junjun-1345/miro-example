// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Operation _$OperationFromJson(Map<String, dynamic> json) => _Operation(
  type: $enumDecode(_$OperationTypeEnumMap, json['type']),
  shapeId: json['shapeId'] as String,
  shape: json['shape'] == null
      ? null
      : Shape.fromJson(json['shape'] as Map<String, dynamic>),
  timestamp: (json['timestamp'] as num).toInt(),
  clientId: json['clientId'] as String,
);

Map<String, dynamic> _$OperationToJson(_Operation instance) =>
    <String, dynamic>{
      'type': _$OperationTypeEnumMap[instance.type]!,
      'shapeId': instance.shapeId,
      'shape': instance.shape,
      'timestamp': instance.timestamp,
      'clientId': instance.clientId,
    };

const _$OperationTypeEnumMap = {
  OperationType.upsert: 'upsert',
  OperationType.delete: 'delete',
};
