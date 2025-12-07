// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'crdt_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CrdtState {

/// 図形エントリのマップ（shapeId -> ShapeEntry）
 Map<String, ShapeEntry> get entries;/// 自分のクライアントID
 String get clientId;/// 接続中のクライアント数
 int get clientCount;
/// Create a copy of CrdtState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CrdtStateCopyWith<CrdtState> get copyWith => _$CrdtStateCopyWithImpl<CrdtState>(this as CrdtState, _$identity);

  /// Serializes this CrdtState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CrdtState&&const DeepCollectionEquality().equals(other.entries, entries)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.clientCount, clientCount) || other.clientCount == clientCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(entries),clientId,clientCount);

@override
String toString() {
  return 'CrdtState(entries: $entries, clientId: $clientId, clientCount: $clientCount)';
}


}

/// @nodoc
abstract mixin class $CrdtStateCopyWith<$Res>  {
  factory $CrdtStateCopyWith(CrdtState value, $Res Function(CrdtState) _then) = _$CrdtStateCopyWithImpl;
@useResult
$Res call({
 Map<String, ShapeEntry> entries, String clientId, int clientCount
});




}
/// @nodoc
class _$CrdtStateCopyWithImpl<$Res>
    implements $CrdtStateCopyWith<$Res> {
  _$CrdtStateCopyWithImpl(this._self, this._then);

  final CrdtState _self;
  final $Res Function(CrdtState) _then;

/// Create a copy of CrdtState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entries = null,Object? clientId = null,Object? clientCount = null,}) {
  return _then(_self.copyWith(
entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as Map<String, ShapeEntry>,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,clientCount: null == clientCount ? _self.clientCount : clientCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CrdtState].
extension CrdtStatePatterns on CrdtState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CrdtState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CrdtState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CrdtState value)  $default,){
final _that = this;
switch (_that) {
case _CrdtState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CrdtState value)?  $default,){
final _that = this;
switch (_that) {
case _CrdtState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, ShapeEntry> entries,  String clientId,  int clientCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CrdtState() when $default != null:
return $default(_that.entries,_that.clientId,_that.clientCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, ShapeEntry> entries,  String clientId,  int clientCount)  $default,) {final _that = this;
switch (_that) {
case _CrdtState():
return $default(_that.entries,_that.clientId,_that.clientCount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, ShapeEntry> entries,  String clientId,  int clientCount)?  $default,) {final _that = this;
switch (_that) {
case _CrdtState() when $default != null:
return $default(_that.entries,_that.clientId,_that.clientCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CrdtState extends CrdtState {
  const _CrdtState({final  Map<String, ShapeEntry> entries = const {}, required this.clientId, this.clientCount = 1}): _entries = entries,super._();
  factory _CrdtState.fromJson(Map<String, dynamic> json) => _$CrdtStateFromJson(json);

/// 図形エントリのマップ（shapeId -> ShapeEntry）
 final  Map<String, ShapeEntry> _entries;
/// 図形エントリのマップ（shapeId -> ShapeEntry）
@override@JsonKey() Map<String, ShapeEntry> get entries {
  if (_entries is EqualUnmodifiableMapView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_entries);
}

/// 自分のクライアントID
@override final  String clientId;
/// 接続中のクライアント数
@override@JsonKey() final  int clientCount;

/// Create a copy of CrdtState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CrdtStateCopyWith<_CrdtState> get copyWith => __$CrdtStateCopyWithImpl<_CrdtState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CrdtStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CrdtState&&const DeepCollectionEquality().equals(other._entries, _entries)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.clientCount, clientCount) || other.clientCount == clientCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_entries),clientId,clientCount);

@override
String toString() {
  return 'CrdtState(entries: $entries, clientId: $clientId, clientCount: $clientCount)';
}


}

/// @nodoc
abstract mixin class _$CrdtStateCopyWith<$Res> implements $CrdtStateCopyWith<$Res> {
  factory _$CrdtStateCopyWith(_CrdtState value, $Res Function(_CrdtState) _then) = __$CrdtStateCopyWithImpl;
@override @useResult
$Res call({
 Map<String, ShapeEntry> entries, String clientId, int clientCount
});




}
/// @nodoc
class __$CrdtStateCopyWithImpl<$Res>
    implements _$CrdtStateCopyWith<$Res> {
  __$CrdtStateCopyWithImpl(this._self, this._then);

  final _CrdtState _self;
  final $Res Function(_CrdtState) _then;

/// Create a copy of CrdtState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entries = null,Object? clientId = null,Object? clientCount = null,}) {
  return _then(_CrdtState(
entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as Map<String, ShapeEntry>,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,clientCount: null == clientCount ? _self.clientCount : clientCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
