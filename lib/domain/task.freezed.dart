// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Task {

 String get id; String? get userId; String? get categoryId; String get title; String? get notes; List<ChecklistItem> get checklist;/// Date-only (year/month/day); time-of-day is ignored.
 DateTime get taskDate; TimeMode get timeMode; LocalTime? get startTime; LocalTime? get endTime; TaskStatus get status; DateTime? get completedAt; double get sortOrder; String? get recurrenceRule; String? get recurrenceParentId; DateTime get createdAt; DateTime get updatedAt; DateTime? get deletedAt;
/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskCopyWith<Task> get copyWith => _$TaskCopyWithImpl<Task>(this as Task, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Task;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Task&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&const DeepCollectionEquality().equals(other.checklist, _this.checklist)&&(identical(other.taskDate, _this.taskDate) || other.taskDate == _this.taskDate)&&(identical(other.timeMode, _this.timeMode) || other.timeMode == _this.timeMode)&&(identical(other.startTime, _this.startTime) || other.startTime == _this.startTime)&&(identical(other.endTime, _this.endTime) || other.endTime == _this.endTime)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.completedAt, _this.completedAt) || other.completedAt == _this.completedAt)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder)&&(identical(other.recurrenceRule, _this.recurrenceRule) || other.recurrenceRule == _this.recurrenceRule)&&(identical(other.recurrenceParentId, _this.recurrenceParentId) || other.recurrenceParentId == _this.recurrenceParentId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt));
}


@override
int get hashCode {
  final _this = this as Task;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.categoryId,_this.title,_this.notes,const DeepCollectionEquality().hash(_this.checklist),_this.taskDate,_this.timeMode,_this.startTime,_this.endTime,_this.status,_this.completedAt,_this.sortOrder,_this.recurrenceRule,_this.recurrenceParentId,_this.createdAt,_this.updatedAt,_this.deletedAt);
}

@override
String toString() {
  final _this = this as Task;
  return 'Task(id: ${_this.id}, userId: ${_this.userId}, categoryId: ${_this.categoryId}, title: ${_this.title}, notes: ${_this.notes}, checklist: ${_this.checklist}, taskDate: ${_this.taskDate}, timeMode: ${_this.timeMode}, startTime: ${_this.startTime}, endTime: ${_this.endTime}, status: ${_this.status}, completedAt: ${_this.completedAt}, sortOrder: ${_this.sortOrder}, recurrenceRule: ${_this.recurrenceRule}, recurrenceParentId: ${_this.recurrenceParentId}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, deletedAt: ${_this.deletedAt})';
}


}

/// @nodoc
abstract mixin class $TaskCopyWith<$Res>  {
  factory $TaskCopyWith(Task value, $Res Function(Task) _then) = _$TaskCopyWithImpl;
@useResult
$Res call({
 String id, String? userId, String? categoryId, String title, String? notes, List<ChecklistItem> checklist, DateTime taskDate, TimeMode timeMode, LocalTime? startTime, LocalTime? endTime, TaskStatus status, DateTime? completedAt, double sortOrder, String? recurrenceRule, String? recurrenceParentId, DateTime createdAt, DateTime updatedAt, DateTime? deletedAt
});




}
/// @nodoc
class _$TaskCopyWithImpl<$Res>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._self, this._then);

  final Task _self;
  final $Res Function(Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = freezed,Object? categoryId = freezed,Object? title = null,Object? notes = freezed,Object? checklist = null,Object? taskDate = null,Object? timeMode = null,Object? startTime = freezed,Object? endTime = freezed,Object? status = null,Object? completedAt = freezed,Object? sortOrder = null,Object? recurrenceRule = freezed,Object? recurrenceParentId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,}) {
  return _then(Task(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,checklist: null == checklist ? _self.checklist : checklist // ignore: cast_nullable_to_non_nullable
as List<ChecklistItem>,taskDate: null == taskDate ? _self.taskDate : taskDate // ignore: cast_nullable_to_non_nullable
as DateTime,timeMode: null == timeMode ? _self.timeMode : timeMode // ignore: cast_nullable_to_non_nullable
as TimeMode,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as LocalTime?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as LocalTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as double,recurrenceRule: freezed == recurrenceRule ? _self.recurrenceRule : recurrenceRule // ignore: cast_nullable_to_non_nullable
as String?,recurrenceParentId: freezed == recurrenceParentId ? _self.recurrenceParentId : recurrenceParentId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Task].
extension TaskPatterns on Task {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Task value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Task() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Task value)  $default,){
final _that = this;
switch (_that) {
case _Task():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Task value)?  $default,){
final _that = this;
switch (_that) {
case _Task() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? userId,  String? categoryId,  String title,  String? notes,  List<ChecklistItem> checklist,  DateTime taskDate,  TimeMode timeMode,  LocalTime? startTime,  LocalTime? endTime,  TaskStatus status,  DateTime? completedAt,  double sortOrder,  String? recurrenceRule,  String? recurrenceParentId,  DateTime createdAt,  DateTime updatedAt,  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.id,_that.userId,_that.categoryId,_that.title,_that.notes,_that.checklist,_that.taskDate,_that.timeMode,_that.startTime,_that.endTime,_that.status,_that.completedAt,_that.sortOrder,_that.recurrenceRule,_that.recurrenceParentId,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? userId,  String? categoryId,  String title,  String? notes,  List<ChecklistItem> checklist,  DateTime taskDate,  TimeMode timeMode,  LocalTime? startTime,  LocalTime? endTime,  TaskStatus status,  DateTime? completedAt,  double sortOrder,  String? recurrenceRule,  String? recurrenceParentId,  DateTime createdAt,  DateTime updatedAt,  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _Task():
return $default(_that.id,_that.userId,_that.categoryId,_that.title,_that.notes,_that.checklist,_that.taskDate,_that.timeMode,_that.startTime,_that.endTime,_that.status,_that.completedAt,_that.sortOrder,_that.recurrenceRule,_that.recurrenceParentId,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? userId,  String? categoryId,  String title,  String? notes,  List<ChecklistItem> checklist,  DateTime taskDate,  TimeMode timeMode,  LocalTime? startTime,  LocalTime? endTime,  TaskStatus status,  DateTime? completedAt,  double sortOrder,  String? recurrenceRule,  String? recurrenceParentId,  DateTime createdAt,  DateTime updatedAt,  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.id,_that.userId,_that.categoryId,_that.title,_that.notes,_that.checklist,_that.taskDate,_that.timeMode,_that.startTime,_that.endTime,_that.status,_that.completedAt,_that.sortOrder,_that.recurrenceRule,_that.recurrenceParentId,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Task implements Task {
  const _Task({required this.id, this.userId, this.categoryId, required this.title, this.notes,  List<ChecklistItem> checklist = const [], required this.taskDate, this.timeMode = TimeMode.none, this.startTime, this.endTime, this.status = TaskStatus.todo, this.completedAt, required this.sortOrder, this.recurrenceRule, this.recurrenceParentId, required this.createdAt, required this.updatedAt, this.deletedAt}): _checklist = checklist;
  

@override final  String id;
@override final  String? userId;
@override final  String? categoryId;
@override final  String title;
@override final  String? notes;
 final  List<ChecklistItem> _checklist;
@override@JsonKey() List<ChecklistItem> get checklist {
  if (_checklist is EqualUnmodifiableListView) return _checklist;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_checklist);
}

/// Date-only (year/month/day); time-of-day is ignored.
@override final  DateTime taskDate;
@override@JsonKey() final  TimeMode timeMode;
@override final  LocalTime? startTime;
@override final  LocalTime? endTime;
@override@JsonKey() final  TaskStatus status;
@override final  DateTime? completedAt;
@override final  double sortOrder;
@override final  String? recurrenceRule;
@override final  String? recurrenceParentId;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  DateTime? deletedAt;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskCopyWith<_Task> get copyWith => __$TaskCopyWithImpl<_Task>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Task&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.title, title) || other.title == title)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.checklist, _checklist)&&(identical(other.taskDate, taskDate) || other.taskDate == taskDate)&&(identical(other.timeMode, timeMode) || other.timeMode == timeMode)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.recurrenceRule, recurrenceRule) || other.recurrenceRule == recurrenceRule)&&(identical(other.recurrenceParentId, recurrenceParentId) || other.recurrenceParentId == recurrenceParentId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,categoryId,title,notes,const DeepCollectionEquality().hash(_checklist),taskDate,timeMode,startTime,endTime,status,completedAt,sortOrder,recurrenceRule,recurrenceParentId,createdAt,updatedAt,deletedAt);
}

@override
String toString() {
    return 'Task(id: $id, userId: $userId, categoryId: $categoryId, title: $title, notes: $notes, checklist: $checklist, taskDate: $taskDate, timeMode: $timeMode, startTime: $startTime, endTime: $endTime, status: $status, completedAt: $completedAt, sortOrder: $sortOrder, recurrenceRule: $recurrenceRule, recurrenceParentId: $recurrenceParentId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$TaskCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$TaskCopyWith(_Task value, $Res Function(_Task) _then) = __$TaskCopyWithImpl;
@override @useResult
$Res call({
 String id, String? userId, String? categoryId, String title, String? notes, List<ChecklistItem> checklist, DateTime taskDate, TimeMode timeMode, LocalTime? startTime, LocalTime? endTime, TaskStatus status, DateTime? completedAt, double sortOrder, String? recurrenceRule, String? recurrenceParentId, DateTime createdAt, DateTime updatedAt, DateTime? deletedAt
});




}
/// @nodoc
class __$TaskCopyWithImpl<$Res>
    implements _$TaskCopyWith<$Res> {
  __$TaskCopyWithImpl(this._self, this._then);

  final _Task _self;
  final $Res Function(_Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = freezed,Object? categoryId = freezed,Object? title = null,Object? notes = freezed,Object? checklist = null,Object? taskDate = null,Object? timeMode = null,Object? startTime = freezed,Object? endTime = freezed,Object? status = null,Object? completedAt = freezed,Object? sortOrder = null,Object? recurrenceRule = freezed,Object? recurrenceParentId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,}) {
  return _then(_Task(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,checklist: null == checklist ? _self._checklist : checklist // ignore: cast_nullable_to_non_nullable
as List<ChecklistItem>,taskDate: null == taskDate ? _self.taskDate : taskDate // ignore: cast_nullable_to_non_nullable
as DateTime,timeMode: null == timeMode ? _self.timeMode : timeMode // ignore: cast_nullable_to_non_nullable
as TimeMode,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as LocalTime?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as LocalTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as double,recurrenceRule: freezed == recurrenceRule ? _self.recurrenceRule : recurrenceRule // ignore: cast_nullable_to_non_nullable
as String?,recurrenceParentId: freezed == recurrenceParentId ? _self.recurrenceParentId : recurrenceParentId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
