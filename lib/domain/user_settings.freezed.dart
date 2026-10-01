// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserSettings {

 String get userId; bool get morningEnabled; String get morningTime; bool get eveningEnabled; String get eveningTime; String get themeMode; int get weekStartsOn; String? get defaultCategoryId; DateTime get updatedAt; SyncState get syncState; DateTime get localChangedAt;
/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSettingsCopyWith<UserSettings> get copyWith => _$UserSettingsCopyWithImpl<UserSettings>(this as UserSettings, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UserSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSettings&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.morningEnabled, _this.morningEnabled) || other.morningEnabled == _this.morningEnabled)&&(identical(other.morningTime, _this.morningTime) || other.morningTime == _this.morningTime)&&(identical(other.eveningEnabled, _this.eveningEnabled) || other.eveningEnabled == _this.eveningEnabled)&&(identical(other.eveningTime, _this.eveningTime) || other.eveningTime == _this.eveningTime)&&(identical(other.themeMode, _this.themeMode) || other.themeMode == _this.themeMode)&&(identical(other.weekStartsOn, _this.weekStartsOn) || other.weekStartsOn == _this.weekStartsOn)&&(identical(other.defaultCategoryId, _this.defaultCategoryId) || other.defaultCategoryId == _this.defaultCategoryId)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.syncState, _this.syncState) || other.syncState == _this.syncState)&&(identical(other.localChangedAt, _this.localChangedAt) || other.localChangedAt == _this.localChangedAt));
}


@override
int get hashCode {
  final _this = this as UserSettings;
  return Object.hash(runtimeType,_this.userId,_this.morningEnabled,_this.morningTime,_this.eveningEnabled,_this.eveningTime,_this.themeMode,_this.weekStartsOn,_this.defaultCategoryId,_this.updatedAt,_this.syncState,_this.localChangedAt);
}

@override
String toString() {
  final _this = this as UserSettings;
  return 'UserSettings(userId: ${_this.userId}, morningEnabled: ${_this.morningEnabled}, morningTime: ${_this.morningTime}, eveningEnabled: ${_this.eveningEnabled}, eveningTime: ${_this.eveningTime}, themeMode: ${_this.themeMode}, weekStartsOn: ${_this.weekStartsOn}, defaultCategoryId: ${_this.defaultCategoryId}, updatedAt: ${_this.updatedAt}, syncState: ${_this.syncState}, localChangedAt: ${_this.localChangedAt})';
}


}

/// @nodoc
abstract mixin class $UserSettingsCopyWith<$Res>  {
  factory $UserSettingsCopyWith(UserSettings value, $Res Function(UserSettings) _then) = _$UserSettingsCopyWithImpl;
@useResult
$Res call({
 String userId, bool morningEnabled, String morningTime, bool eveningEnabled, String eveningTime, String themeMode, int weekStartsOn, String? defaultCategoryId, DateTime updatedAt, SyncState syncState, DateTime localChangedAt
});




}
/// @nodoc
class _$UserSettingsCopyWithImpl<$Res>
    implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._self, this._then);

  final UserSettings _self;
  final $Res Function(UserSettings) _then;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? morningEnabled = null,Object? morningTime = null,Object? eveningEnabled = null,Object? eveningTime = null,Object? themeMode = null,Object? weekStartsOn = null,Object? defaultCategoryId = freezed,Object? updatedAt = null,Object? syncState = null,Object? localChangedAt = null,}) {
  return _then(UserSettings(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,morningEnabled: null == morningEnabled ? _self.morningEnabled : morningEnabled // ignore: cast_nullable_to_non_nullable
as bool,morningTime: null == morningTime ? _self.morningTime : morningTime // ignore: cast_nullable_to_non_nullable
as String,eveningEnabled: null == eveningEnabled ? _self.eveningEnabled : eveningEnabled // ignore: cast_nullable_to_non_nullable
as bool,eveningTime: null == eveningTime ? _self.eveningTime : eveningTime // ignore: cast_nullable_to_non_nullable
as String,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String,weekStartsOn: null == weekStartsOn ? _self.weekStartsOn : weekStartsOn // ignore: cast_nullable_to_non_nullable
as int,defaultCategoryId: freezed == defaultCategoryId ? _self.defaultCategoryId : defaultCategoryId // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as SyncState,localChangedAt: null == localChangedAt ? _self.localChangedAt : localChangedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [UserSettings].
extension UserSettingsPatterns on UserSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserSettings value)  $default,){
final _that = this;
switch (_that) {
case _UserSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserSettings value)?  $default,){
final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  bool morningEnabled,  String morningTime,  bool eveningEnabled,  String eveningTime,  String themeMode,  int weekStartsOn,  String? defaultCategoryId,  DateTime updatedAt,  SyncState syncState,  DateTime localChangedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
return $default(_that.userId,_that.morningEnabled,_that.morningTime,_that.eveningEnabled,_that.eveningTime,_that.themeMode,_that.weekStartsOn,_that.defaultCategoryId,_that.updatedAt,_that.syncState,_that.localChangedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  bool morningEnabled,  String morningTime,  bool eveningEnabled,  String eveningTime,  String themeMode,  int weekStartsOn,  String? defaultCategoryId,  DateTime updatedAt,  SyncState syncState,  DateTime localChangedAt)  $default,) {final _that = this;
switch (_that) {
case _UserSettings():
return $default(_that.userId,_that.morningEnabled,_that.morningTime,_that.eveningEnabled,_that.eveningTime,_that.themeMode,_that.weekStartsOn,_that.defaultCategoryId,_that.updatedAt,_that.syncState,_that.localChangedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  bool morningEnabled,  String morningTime,  bool eveningEnabled,  String eveningTime,  String themeMode,  int weekStartsOn,  String? defaultCategoryId,  DateTime updatedAt,  SyncState syncState,  DateTime localChangedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
return $default(_that.userId,_that.morningEnabled,_that.morningTime,_that.eveningEnabled,_that.eveningTime,_that.themeMode,_that.weekStartsOn,_that.defaultCategoryId,_that.updatedAt,_that.syncState,_that.localChangedAt);case _:
  return null;

}
}

}

/// @nodoc


class _UserSettings implements UserSettings {
  const _UserSettings({required this.userId, this.morningEnabled = true, this.morningTime = '07:30:00', this.eveningEnabled = true, this.eveningTime = '21:00:00', this.themeMode = 'system', this.weekStartsOn = 1, this.defaultCategoryId, required this.updatedAt, this.syncState = SyncState.pending, required this.localChangedAt});
  

@override final  String userId;
@override@JsonKey() final  bool morningEnabled;
@override@JsonKey() final  String morningTime;
@override@JsonKey() final  bool eveningEnabled;
@override@JsonKey() final  String eveningTime;
@override@JsonKey() final  String themeMode;
@override@JsonKey() final  int weekStartsOn;
@override final  String? defaultCategoryId;
@override final  DateTime updatedAt;
@override@JsonKey() final  SyncState syncState;
@override final  DateTime localChangedAt;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserSettingsCopyWith<_UserSettings> get copyWith => __$UserSettingsCopyWithImpl<_UserSettings>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserSettings&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.morningEnabled, morningEnabled) || other.morningEnabled == morningEnabled)&&(identical(other.morningTime, morningTime) || other.morningTime == morningTime)&&(identical(other.eveningEnabled, eveningEnabled) || other.eveningEnabled == eveningEnabled)&&(identical(other.eveningTime, eveningTime) || other.eveningTime == eveningTime)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.weekStartsOn, weekStartsOn) || other.weekStartsOn == weekStartsOn)&&(identical(other.defaultCategoryId, defaultCategoryId) || other.defaultCategoryId == defaultCategoryId)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.localChangedAt, localChangedAt) || other.localChangedAt == localChangedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,userId,morningEnabled,morningTime,eveningEnabled,eveningTime,themeMode,weekStartsOn,defaultCategoryId,updatedAt,syncState,localChangedAt);
}

@override
String toString() {
    return 'UserSettings(userId: $userId, morningEnabled: $morningEnabled, morningTime: $morningTime, eveningEnabled: $eveningEnabled, eveningTime: $eveningTime, themeMode: $themeMode, weekStartsOn: $weekStartsOn, defaultCategoryId: $defaultCategoryId, updatedAt: $updatedAt, syncState: $syncState, localChangedAt: $localChangedAt)';
}


}

/// @nodoc
abstract mixin class _$UserSettingsCopyWith<$Res> implements $UserSettingsCopyWith<$Res> {
  factory _$UserSettingsCopyWith(_UserSettings value, $Res Function(_UserSettings) _then) = __$UserSettingsCopyWithImpl;
@override @useResult
$Res call({
 String userId, bool morningEnabled, String morningTime, bool eveningEnabled, String eveningTime, String themeMode, int weekStartsOn, String? defaultCategoryId, DateTime updatedAt, SyncState syncState, DateTime localChangedAt
});




}
/// @nodoc
class __$UserSettingsCopyWithImpl<$Res>
    implements _$UserSettingsCopyWith<$Res> {
  __$UserSettingsCopyWithImpl(this._self, this._then);

  final _UserSettings _self;
  final $Res Function(_UserSettings) _then;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? morningEnabled = null,Object? morningTime = null,Object? eveningEnabled = null,Object? eveningTime = null,Object? themeMode = null,Object? weekStartsOn = null,Object? defaultCategoryId = freezed,Object? updatedAt = null,Object? syncState = null,Object? localChangedAt = null,}) {
  return _then(_UserSettings(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,morningEnabled: null == morningEnabled ? _self.morningEnabled : morningEnabled // ignore: cast_nullable_to_non_nullable
as bool,morningTime: null == morningTime ? _self.morningTime : morningTime // ignore: cast_nullable_to_non_nullable
as String,eveningEnabled: null == eveningEnabled ? _self.eveningEnabled : eveningEnabled // ignore: cast_nullable_to_non_nullable
as bool,eveningTime: null == eveningTime ? _self.eveningTime : eveningTime // ignore: cast_nullable_to_non_nullable
as String,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String,weekStartsOn: null == weekStartsOn ? _self.weekStartsOn : weekStartsOn // ignore: cast_nullable_to_non_nullable
as int,defaultCategoryId: freezed == defaultCategoryId ? _self.defaultCategoryId : defaultCategoryId // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as SyncState,localChangedAt: null == localChangedAt ? _self.localChangedAt : localChangedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
