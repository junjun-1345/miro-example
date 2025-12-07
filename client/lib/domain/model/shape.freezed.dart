// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shape.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Shape {

/// 図形の一意識別子
 String get id;/// 図形の種類
 ShapeType get type;/// X座標
 double get x;/// Y座標
 double get y;/// 幅
 double get width;/// 高さ
 double get height;/// 塗りつぶし色（ARGB形式）
 int get color;/// テキスト（type=textの場合のみ使用）
 String? get text;
/// Create a copy of Shape
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShapeCopyWith<Shape> get copyWith => _$ShapeCopyWithImpl<Shape>(this as Shape, _$identity);

  /// Serializes this Shape to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Shape&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.color, color) || other.color == color)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,x,y,width,height,color,text);

@override
String toString() {
  return 'Shape(id: $id, type: $type, x: $x, y: $y, width: $width, height: $height, color: $color, text: $text)';
}


}

/// @nodoc
abstract mixin class $ShapeCopyWith<$Res>  {
  factory $ShapeCopyWith(Shape value, $Res Function(Shape) _then) = _$ShapeCopyWithImpl;
@useResult
$Res call({
 String id, ShapeType type, double x, double y, double width, double height, int color, String? text
});




}
/// @nodoc
class _$ShapeCopyWithImpl<$Res>
    implements $ShapeCopyWith<$Res> {
  _$ShapeCopyWithImpl(this._self, this._then);

  final Shape _self;
  final $Res Function(Shape) _then;

/// Create a copy of Shape
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? x = null,Object? y = null,Object? width = null,Object? height = null,Object? color = null,Object? text = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ShapeType,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Shape].
extension ShapePatterns on Shape {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Shape value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Shape() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Shape value)  $default,){
final _that = this;
switch (_that) {
case _Shape():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Shape value)?  $default,){
final _that = this;
switch (_that) {
case _Shape() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ShapeType type,  double x,  double y,  double width,  double height,  int color,  String? text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Shape() when $default != null:
return $default(_that.id,_that.type,_that.x,_that.y,_that.width,_that.height,_that.color,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ShapeType type,  double x,  double y,  double width,  double height,  int color,  String? text)  $default,) {final _that = this;
switch (_that) {
case _Shape():
return $default(_that.id,_that.type,_that.x,_that.y,_that.width,_that.height,_that.color,_that.text);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ShapeType type,  double x,  double y,  double width,  double height,  int color,  String? text)?  $default,) {final _that = this;
switch (_that) {
case _Shape() when $default != null:
return $default(_that.id,_that.type,_that.x,_that.y,_that.width,_that.height,_that.color,_that.text);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Shape implements Shape {
  const _Shape({required this.id, required this.type, required this.x, required this.y, required this.width, required this.height, required this.color, this.text});
  factory _Shape.fromJson(Map<String, dynamic> json) => _$ShapeFromJson(json);

/// 図形の一意識別子
@override final  String id;
/// 図形の種類
@override final  ShapeType type;
/// X座標
@override final  double x;
/// Y座標
@override final  double y;
/// 幅
@override final  double width;
/// 高さ
@override final  double height;
/// 塗りつぶし色（ARGB形式）
@override final  int color;
/// テキスト（type=textの場合のみ使用）
@override final  String? text;

/// Create a copy of Shape
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShapeCopyWith<_Shape> get copyWith => __$ShapeCopyWithImpl<_Shape>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShapeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Shape&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.color, color) || other.color == color)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,x,y,width,height,color,text);

@override
String toString() {
  return 'Shape(id: $id, type: $type, x: $x, y: $y, width: $width, height: $height, color: $color, text: $text)';
}


}

/// @nodoc
abstract mixin class _$ShapeCopyWith<$Res> implements $ShapeCopyWith<$Res> {
  factory _$ShapeCopyWith(_Shape value, $Res Function(_Shape) _then) = __$ShapeCopyWithImpl;
@override @useResult
$Res call({
 String id, ShapeType type, double x, double y, double width, double height, int color, String? text
});




}
/// @nodoc
class __$ShapeCopyWithImpl<$Res>
    implements _$ShapeCopyWith<$Res> {
  __$ShapeCopyWithImpl(this._self, this._then);

  final _Shape _self;
  final $Res Function(_Shape) _then;

/// Create a copy of Shape
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? x = null,Object? y = null,Object? width = null,Object? height = null,Object? color = null,Object? text = freezed,}) {
  return _then(_Shape(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ShapeType,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ShapeEntry {

/// 図形データ
 Shape get shape;/// 最終更新タイムスタンプ（ミリ秒）
 int get timestamp;/// 削除済みフラグ（tombstone）
 bool get deleted;
/// Create a copy of ShapeEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShapeEntryCopyWith<ShapeEntry> get copyWith => _$ShapeEntryCopyWithImpl<ShapeEntry>(this as ShapeEntry, _$identity);

  /// Serializes this ShapeEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShapeEntry&&(identical(other.shape, shape) || other.shape == shape)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.deleted, deleted) || other.deleted == deleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shape,timestamp,deleted);

@override
String toString() {
  return 'ShapeEntry(shape: $shape, timestamp: $timestamp, deleted: $deleted)';
}


}

/// @nodoc
abstract mixin class $ShapeEntryCopyWith<$Res>  {
  factory $ShapeEntryCopyWith(ShapeEntry value, $Res Function(ShapeEntry) _then) = _$ShapeEntryCopyWithImpl;
@useResult
$Res call({
 Shape shape, int timestamp, bool deleted
});


$ShapeCopyWith<$Res> get shape;

}
/// @nodoc
class _$ShapeEntryCopyWithImpl<$Res>
    implements $ShapeEntryCopyWith<$Res> {
  _$ShapeEntryCopyWithImpl(this._self, this._then);

  final ShapeEntry _self;
  final $Res Function(ShapeEntry) _then;

/// Create a copy of ShapeEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shape = null,Object? timestamp = null,Object? deleted = null,}) {
  return _then(_self.copyWith(
shape: null == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as Shape,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ShapeEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShapeCopyWith<$Res> get shape {
  
  return $ShapeCopyWith<$Res>(_self.shape, (value) {
    return _then(_self.copyWith(shape: value));
  });
}
}


/// Adds pattern-matching-related methods to [ShapeEntry].
extension ShapeEntryPatterns on ShapeEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShapeEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShapeEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShapeEntry value)  $default,){
final _that = this;
switch (_that) {
case _ShapeEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShapeEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ShapeEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Shape shape,  int timestamp,  bool deleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShapeEntry() when $default != null:
return $default(_that.shape,_that.timestamp,_that.deleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Shape shape,  int timestamp,  bool deleted)  $default,) {final _that = this;
switch (_that) {
case _ShapeEntry():
return $default(_that.shape,_that.timestamp,_that.deleted);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Shape shape,  int timestamp,  bool deleted)?  $default,) {final _that = this;
switch (_that) {
case _ShapeEntry() when $default != null:
return $default(_that.shape,_that.timestamp,_that.deleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShapeEntry implements ShapeEntry {
  const _ShapeEntry({required this.shape, required this.timestamp, this.deleted = false});
  factory _ShapeEntry.fromJson(Map<String, dynamic> json) => _$ShapeEntryFromJson(json);

/// 図形データ
@override final  Shape shape;
/// 最終更新タイムスタンプ（ミリ秒）
@override final  int timestamp;
/// 削除済みフラグ（tombstone）
@override@JsonKey() final  bool deleted;

/// Create a copy of ShapeEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShapeEntryCopyWith<_ShapeEntry> get copyWith => __$ShapeEntryCopyWithImpl<_ShapeEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShapeEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShapeEntry&&(identical(other.shape, shape) || other.shape == shape)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.deleted, deleted) || other.deleted == deleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shape,timestamp,deleted);

@override
String toString() {
  return 'ShapeEntry(shape: $shape, timestamp: $timestamp, deleted: $deleted)';
}


}

/// @nodoc
abstract mixin class _$ShapeEntryCopyWith<$Res> implements $ShapeEntryCopyWith<$Res> {
  factory _$ShapeEntryCopyWith(_ShapeEntry value, $Res Function(_ShapeEntry) _then) = __$ShapeEntryCopyWithImpl;
@override @useResult
$Res call({
 Shape shape, int timestamp, bool deleted
});


@override $ShapeCopyWith<$Res> get shape;

}
/// @nodoc
class __$ShapeEntryCopyWithImpl<$Res>
    implements _$ShapeEntryCopyWith<$Res> {
  __$ShapeEntryCopyWithImpl(this._self, this._then);

  final _ShapeEntry _self;
  final $Res Function(_ShapeEntry) _then;

/// Create a copy of ShapeEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shape = null,Object? timestamp = null,Object? deleted = null,}) {
  return _then(_ShapeEntry(
shape: null == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as Shape,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ShapeEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShapeCopyWith<$Res> get shape {
  
  return $ShapeCopyWith<$Res>(_self.shape, (value) {
    return _then(_self.copyWith(shape: value));
  });
}
}

// dart format on
