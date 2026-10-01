// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LocalSettings {

 String? get defaultCategoryId; String? get selectedFilterCategoryId; String? get lastSignedInUserId;
/// Create a copy of LocalSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalSettingsCopyWith<LocalSettings> get copyWith => _$LocalSettingsCopyWithImpl<LocalSettings>(this as LocalSettings, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LocalSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalSettings&&(identical(other.defaultCategoryId, _this.defaultCategoryId) || other.defaultCategoryId == _this.defaultCategoryId)&&(identical(other.selectedFilterCategoryId, _this.selectedFilterCategoryId) || other.selectedFilterCategoryId == _this.selectedFilterCategoryId)&&(identical(other.lastSignedInUserId, _this.lastSignedInUserId) || other.lastSignedInUserId == _this.lastSignedInUserId));
}


@override
int get hashCode {
  final _this = this as LocalSettings;
  return Object.hash(runtimeType,_this.defaultCategoryId,_this.selectedFilterCategoryId,_this.lastSignedInUserId);
}

@override
String toString() {
  final _this = this as LocalSettings;
  return 'LocalSettings(defaultCategoryId: ${_this.defaultCategoryId}, selectedFilterCategoryId: ${_this.selectedFilterCategoryId}, lastSignedInUserId: ${_this.lastSignedInUserId})';
}


}

/// @nodoc
abstract mixin class $LocalSettingsCopyWith<$Res>  {
  factory $LocalSettingsCopyWith(LocalSettings value, $Res Function(LocalSettings) _then) = _$LocalSettingsCopyWithImpl;
@useResult
$Res call({
 String? defaultCategoryId, String? selectedFilterCategoryId, String? lastSignedInUserId
});




}
/// @nodoc
class _$LocalSettingsCopyWithImpl<$Res>
    implements $LocalSettingsCopyWith<$Res> {
  _$LocalSettingsCopyWithImpl(this._self, this._then);

  final LocalSettings _self;
  final $Res Function(LocalSettings) _then;

/// Create a copy of LocalSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? defaultCategoryId = freezed,Object? selectedFilterCategoryId = freezed,Object? lastSignedInUserId = freezed,}) {
  return _then(LocalSettings(
defaultCategoryId: freezed == defaultCategoryId ? _self.defaultCategoryId : defaultCategoryId // ignore: cast_nullable_to_non_nullable
as String?,selectedFilterCategoryId: freezed == selectedFilterCategoryId ? _self.selectedFilterCategoryId : selectedFilterCategoryId // ignore: cast_nullable_to_non_nullable
as String?,lastSignedInUserId: freezed == lastSignedInUserId ? _self.lastSignedInUserId : lastSignedInUserId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LocalSettings].
extension LocalSettingsPatterns on LocalSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocalSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocalSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocalSettings value)  $default,){
final _that = this;
switch (_that) {
case _LocalSettings():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocalSettings value)?  $default,){
final _that = this;
switch (_that) {
case _LocalSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? defaultCategoryId,  String? selectedFilterCategoryId,  String? lastSignedInUserId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalSettings() when $default != null:
return $default(_that.defaultCategoryId,_that.selectedFilterCategoryId,_that.lastSignedInUserId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? defaultCategoryId,  String? selectedFilterCategoryId,  String? lastSignedInUserId)  $default,) {final _that = this;
switch (_that) {
case _LocalSettings():
return $default(_that.defaultCategoryId,_that.selectedFilterCategoryId,_that.lastSignedInUserId);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? defaultCategoryId,  String? selectedFilterCategoryId,  String? lastSignedInUserId)?  $default,) {final _that = this;
switch (_that) {
case _LocalSettings() when $default != null:
return $default(_that.defaultCategoryId,_that.selectedFilterCategoryId,_that.lastSignedInUserId);case _:
  return null;

}
}

}

/// @nodoc


class _LocalSettings implements LocalSettings {
  const _LocalSettings({this.defaultCategoryId, this.selectedFilterCategoryId, this.lastSignedInUserId});
  

@override final  String? defaultCategoryId;
@override final  String? selectedFilterCategoryId;
@override final  String? lastSignedInUserId;

/// Create a copy of LocalSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalSettingsCopyWith<_LocalSettings> get copyWith => __$LocalSettingsCopyWithImpl<_LocalSettings>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalSettings&&(identical(other.defaultCategoryId, defaultCategoryId) || other.defaultCategoryId == defaultCategoryId)&&(identical(other.selectedFilterCategoryId, selectedFilterCategoryId) || other.selectedFilterCategoryId == selectedFilterCategoryId)&&(identical(other.lastSignedInUserId, lastSignedInUserId) || other.lastSignedInUserId == lastSignedInUserId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,defaultCategoryId,selectedFilterCategoryId,lastSignedInUserId);
}

@override
String toString() {
    return 'LocalSettings(defaultCategoryId: $defaultCategoryId, selectedFilterCategoryId: $selectedFilterCategoryId, lastSignedInUserId: $lastSignedInUserId)';
}


}

/// @nodoc
abstract mixin class _$LocalSettingsCopyWith<$Res> implements $LocalSettingsCopyWith<$Res> {
  factory _$LocalSettingsCopyWith(_LocalSettings value, $Res Function(_LocalSettings) _then) = __$LocalSettingsCopyWithImpl;
@override @useResult
$Res call({
 String? defaultCategoryId, String? selectedFilterCategoryId, String? lastSignedInUserId
});




}
/// @nodoc
class __$LocalSettingsCopyWithImpl<$Res>
    implements _$LocalSettingsCopyWith<$Res> {
  __$LocalSettingsCopyWithImpl(this._self, this._then);

  final _LocalSettings _self;
  final $Res Function(_LocalSettings) _then;

/// Create a copy of LocalSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? defaultCategoryId = freezed,Object? selectedFilterCategoryId = freezed,Object? lastSignedInUserId = freezed,}) {
  return _then(_LocalSettings(
defaultCategoryId: freezed == defaultCategoryId ? _self.defaultCategoryId : defaultCategoryId // ignore: cast_nullable_to_non_nullable
as String?,selectedFilterCategoryId: freezed == selectedFilterCategoryId ? _self.selectedFilterCategoryId : selectedFilterCategoryId // ignore: cast_nullable_to_non_nullable
as String?,lastSignedInUserId: freezed == lastSignedInUserId ? _self.lastSignedInUserId : lastSignedInUserId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
