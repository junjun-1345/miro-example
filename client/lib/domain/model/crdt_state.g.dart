// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crdt_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CrdtState _$CrdtStateFromJson(Map<String, dynamic> json) => _CrdtState(
  entries:
      (json['entries'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, ShapeEntry.fromJson(e as Map<String, dynamic>)),
      ) ??
      const {},
  clientId: json['clientId'] as String,
  clientCount: (json['clientCount'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$CrdtStateToJson(_CrdtState instance) =>
    <String, dynamic>{
      'entries': instance.entries,
      'clientId': instance.clientId,
      'clientCount': instance.clientCount,
    };
