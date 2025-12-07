// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncMessage {

/// メッセージの種類
 MessageType get type;/// 操作データ（type=operationの場合）
 Operation? get operation;/// 初期同期データ（type=syncの場合）
 List<ShapeEntry>? get state;/// クライアントID（type=join/leaveの場合）
 String? get clientId;/// 接続中のクライアント数
 int? get clientCount;
/// Create a copy of SyncMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncMessageCopyWith<SyncMessage> get copyWith => _$SyncMessageCopyWithImpl<SyncMessage>(this as SyncMessage, _$identity);

  /// Serializes this SyncMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncMessage&&(identical(other.type, type) || other.type == type)&&(identical(other.operation, operation) || other.operation == operation)&&const DeepCollectionEquality().equals(other.state, state)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.clientCount, clientCount) || other.clientCount == clientCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,operation,const DeepCollectionEquality().hash(state),clientId,clientCount);

@override
String toString() {
  return 'SyncMessage(type: $type, operation: $operation, state: $state, clientId: $clientId, clientCount: $clientCount)';
}


}

/// @nodoc
abstract mixin class $SyncMessageCopyWith<$Res>  {
  factory $SyncMessageCopyWith(SyncMessage value, $Res Function(SyncMessage) _then) = _$SyncMessageCopyWithImpl;
@useResult
$Res call({
 MessageType type, Operation? operation, List<ShapeEntry>? state, String? clientId, int? clientCount
});


$OperationCopyWith<$Res>? get operation;

}
/// @nodoc
class _$SyncMessageCopyWithImpl<$Res>
    implements $SyncMessageCopyWith<$Res> {
  _$SyncMessageCopyWithImpl(this._self, this._then);

  final SyncMessage _self;
  final $Res Function(SyncMessage) _then;

/// Create a copy of SyncMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? operation = freezed,Object? state = freezed,Object? clientId = freezed,Object? clientCount = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MessageType,operation: freezed == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as Operation?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as List<ShapeEntry>?,clientId: freezed == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String?,clientCount: freezed == clientCount ? _self.clientCount : clientCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of SyncMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OperationCopyWith<$Res>? get operation {
    if (_self.operation == null) {
    return null;
  }

  return $OperationCopyWith<$Res>(_self.operation!, (value) {
    return _then(_self.copyWith(operation: value));
  });
}
}


/// Adds pattern-matching-related methods to [SyncMessage].
extension SyncMessagePatterns on SyncMessage {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncMessage() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncMessage value)  $default,){
final _that = this;
switch (_that) {
case _SyncMessage():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncMessage value)?  $default,){
final _that = this;
switch (_that) {
case _SyncMessage() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MessageType type,  Operation? operation,  List<ShapeEntry>? state,  String? clientId,  int? clientCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncMessage() when $default != null:
return $default(_that.type,_that.operation,_that.state,_that.clientId,_that.clientCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MessageType type,  Operation? operation,  List<ShapeEntry>? state,  String? clientId,  int? clientCount)  $default,) {final _that = this;
switch (_that) {
case _SyncMessage():
return $default(_that.type,_that.operation,_that.state,_that.clientId,_that.clientCount);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MessageType type,  Operation? operation,  List<ShapeEntry>? state,  String? clientId,  int? clientCount)?  $default,) {final _that = this;
switch (_that) {
case _SyncMessage() when $default != null:
return $default(_that.type,_that.operation,_that.state,_that.clientId,_that.clientCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncMessage implements SyncMessage {
  const _SyncMessage({required this.type, this.operation, final  List<ShapeEntry>? state, this.clientId, this.clientCount}): _state = state;
  factory _SyncMessage.fromJson(Map<String, dynamic> json) => _$SyncMessageFromJson(json);

/// メッセージの種類
@override final  MessageType type;
/// 操作データ（type=operationの場合）
@override final  Operation? operation;
/// 初期同期データ（type=syncの場合）
 final  List<ShapeEntry>? _state;
/// 初期同期データ（type=syncの場合）
@override List<ShapeEntry>? get state {
  final value = _state;
  if (value == null) return null;
  if (_state is EqualUnmodifiableListView) return _state;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// クライアントID（type=join/leaveの場合）
@override final  String? clientId;
/// 接続中のクライアント数
@override final  int? clientCount;

/// Create a copy of SyncMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncMessageCopyWith<_SyncMessage> get copyWith => __$SyncMessageCopyWithImpl<_SyncMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncMessage&&(identical(other.type, type) || other.type == type)&&(identical(other.operation, operation) || other.operation == operation)&&const DeepCollectionEquality().equals(other._state, _state)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.clientCount, clientCount) || other.clientCount == clientCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,operation,const DeepCollectionEquality().hash(_state),clientId,clientCount);

@override
String toString() {
  return 'SyncMessage(type: $type, operation: $operation, state: $state, clientId: $clientId, clientCount: $clientCount)';
}


}

/// @nodoc
abstract mixin class _$SyncMessageCopyWith<$Res> implements $SyncMessageCopyWith<$Res> {
  factory _$SyncMessageCopyWith(_SyncMessage value, $Res Function(_SyncMessage) _then) = __$SyncMessageCopyWithImpl;
@override @useResult
$Res call({
 MessageType type, Operation? operation, List<ShapeEntry>? state, String? clientId, int? clientCount
});


@override $OperationCopyWith<$Res>? get operation;

}
/// @nodoc
class __$SyncMessageCopyWithImpl<$Res>
    implements _$SyncMessageCopyWith<$Res> {
  __$SyncMessageCopyWithImpl(this._self, this._then);

  final _SyncMessage _self;
  final $Res Function(_SyncMessage) _then;

/// Create a copy of SyncMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? operation = freezed,Object? state = freezed,Object? clientId = freezed,Object? clientCount = freezed,}) {
  return _then(_SyncMessage(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MessageType,operation: freezed == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as Operation?,state: freezed == state ? _self._state : state // ignore: cast_nullable_to_non_nullable
as List<ShapeEntry>?,clientId: freezed == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String?,clientCount: freezed == clientCount ? _self.clientCount : clientCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of SyncMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OperationCopyWith<$Res>? get operation {
    if (_self.operation == null) {
    return null;
  }

  return $OperationCopyWith<$Res>(_self.operation!, (value) {
    return _then(_self.copyWith(operation: value));
  });
}
}

// dart format on
