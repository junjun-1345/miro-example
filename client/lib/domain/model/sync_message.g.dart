// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SyncMessage _$SyncMessageFromJson(Map<String, dynamic> json) => _SyncMessage(
  type: $enumDecode(_$MessageTypeEnumMap, json['type']),
  operation: json['operation'] == null
      ? null
      : Operation.fromJson(json['operation'] as Map<String, dynamic>),
  state: (json['state'] as List<dynamic>?)
      ?.map((e) => ShapeEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
  clientId: json['clientId'] as String?,
  clientCount: (json['clientCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$SyncMessageToJson(_SyncMessage instance) =>
    <String, dynamic>{
      'type': _$MessageTypeEnumMap[instance.type]!,
      'operation': instance.operation,
      'state': instance.state,
      'clientId': instance.clientId,
      'clientCount': instance.clientCount,
    };

const _$MessageTypeEnumMap = {
  MessageType.operation: 'operation',
  MessageType.sync: 'sync',
  MessageType.join: 'join',
  MessageType.leave: 'leave',
};
