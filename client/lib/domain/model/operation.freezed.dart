// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'operation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Operation {

/// 操作の種類
 OperationType get type;/// 対象の図形ID
 String get shapeId;/// 図形データ（upsert時のみ）
 Shape? get shape;/// 操作のタイムスタンプ（ミリ秒）
 int get timestamp;/// 操作を行ったクライアントID
 String get clientId;
/// Create a copy of Operation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OperationCopyWith<Operation> get copyWith => _$OperationCopyWithImpl<Operation>(this as Operation, _$identity);

  /// Serializes this Operation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Operation&&(identical(other.type, type) || other.type == type)&&(identical(other.shapeId, shapeId) || other.shapeId == shapeId)&&(identical(other.shape, shape) || other.shape == shape)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.clientId, clientId) || other.clientId == clientId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,shapeId,shape,timestamp,clientId);

@override
String toString() {
  return 'Operation(type: $type, shapeId: $shapeId, shape: $shape, timestamp: $timestamp, clientId: $clientId)';
}


}

/// @nodoc
abstract mixin class $OperationCopyWith<$Res>  {
  factory $OperationCopyWith(Operation value, $Res Function(Operation) _then) = _$OperationCopyWithImpl;
@useResult
$Res call({
 OperationType type, String shapeId, Shape? shape, int timestamp, String clientId
});


$ShapeCopyWith<$Res>? get shape;

}
/// @nodoc
class _$OperationCopyWithImpl<$Res>
    implements $OperationCopyWith<$Res> {
  _$OperationCopyWithImpl(this._self, this._then);

  final Operation _self;
  final $Res Function(Operation) _then;

/// Create a copy of Operation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? shapeId = null,Object? shape = freezed,Object? timestamp = null,Object? clientId = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OperationType,shapeId: null == shapeId ? _self.shapeId : shapeId // ignore: cast_nullable_to_non_nullable
as String,shape: freezed == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as Shape?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of Operation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShapeCopyWith<$Res>? get shape {
    if (_self.shape == null) {
    return null;
  }

  return $ShapeCopyWith<$Res>(_self.shape!, (value) {
    return _then(_self.copyWith(shape: value));
  });
}
}


/// Adds pattern-matching-related methods to [Operation].
extension OperationPatterns on Operation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Operation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Operation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Operation value)  $default,){
final _that = this;
switch (_that) {
case _Operation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Operation value)?  $default,){
final _that = this;
switch (_that) {
case _Operation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OperationType type,  String shapeId,  Shape? shape,  int timestamp,  String clientId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Operation() when $default != null:
return $default(_that.type,_that.shapeId,_that.shape,_that.timestamp,_that.clientId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OperationType type,  String shapeId,  Shape? shape,  int timestamp,  String clientId)  $default,) {final _that = this;
switch (_that) {
case _Operation():
return $default(_that.type,_that.shapeId,_that.shape,_that.timestamp,_that.clientId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OperationType type,  String shapeId,  Shape? shape,  int timestamp,  String clientId)?  $default,) {final _that = this;
switch (_that) {
case _Operation() when $default != null:
return $default(_that.type,_that.shapeId,_that.shape,_that.timestamp,_that.clientId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Operation implements Operation {
  const _Operation({required this.type, required this.shapeId, this.shape, required this.timestamp, required this.clientId});
  factory _Operation.fromJson(Map<String, dynamic> json) => _$OperationFromJson(json);

/// 操作の種類
@override final  OperationType type;
/// 対象の図形ID
@override final  String shapeId;
/// 図形データ（upsert時のみ）
@override final  Shape? shape;
/// 操作のタイムスタンプ（ミリ秒）
@override final  int timestamp;
/// 操作を行ったクライアントID
@override final  String clientId;

/// Create a copy of Operation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OperationCopyWith<_Operation> get copyWith => __$OperationCopyWithImpl<_Operation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OperationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Operation&&(identical(other.type, type) || other.type == type)&&(identical(other.shapeId, shapeId) || other.shapeId == shapeId)&&(identical(other.shape, shape) || other.shape == shape)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.clientId, clientId) || other.clientId == clientId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,shapeId,shape,timestamp,clientId);

@override
String toString() {
  return 'Operation(type: $type, shapeId: $shapeId, shape: $shape, timestamp: $timestamp, clientId: $clientId)';
}


}

/// @nodoc
abstract mixin class _$OperationCopyWith<$Res> implements $OperationCopyWith<$Res> {
  factory _$OperationCopyWith(_Operation value, $Res Function(_Operation) _then) = __$OperationCopyWithImpl;
@override @useResult
$Res call({
 OperationType type, String shapeId, Shape? shape, int timestamp, String clientId
});


@override $ShapeCopyWith<$Res>? get shape;

}
/// @nodoc
class __$OperationCopyWithImpl<$Res>
    implements _$OperationCopyWith<$Res> {
  __$OperationCopyWithImpl(this._self, this._then);

  final _Operation _self;
  final $Res Function(_Operation) _then;

/// Create a copy of Operation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? shapeId = null,Object? shape = freezed,Object? timestamp = null,Object? clientId = null,}) {
  return _then(_Operation(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OperationType,shapeId: null == shapeId ? _self.shapeId : shapeId // ignore: cast_nullable_to_non_nullable
as String,shape: freezed == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as Shape?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of Operation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShapeCopyWith<$Res>? get shape {
    if (_self.shape == null) {
    return null;
  }

  return $ShapeCopyWith<$Res>(_self.shape!, (value) {
    return _then(_self.copyWith(shape: value));
  });
}
}

// dart format on
