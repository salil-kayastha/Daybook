// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<double> sortOrder = GeneratedColumn<double>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncState, String> syncState =
      GeneratedColumn<String>(
        'sync_state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(SyncState.pending.name),
      ).withConverter<SyncState>($CategoriesTable.$convertersyncState);
  static const VerificationMeta _localChangedAtMeta = const VerificationMeta(
    'localChangedAt',
  );
  @override
  late final GeneratedColumn<DateTime> localChangedAt =
      GeneratedColumn<DateTime>(
        'local_changed_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: Constant(syncEpoch),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    name,
    color,
    icon,
    sortOrder,
    isArchived,
    createdAt,
    updatedAt,
    deletedAt,
    syncState,
    localChangedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('local_changed_at')) {
      context.handle(
        _localChangedAtMeta,
        localChangedAt.isAcceptableOrUnknown(
          data['local_changed_at']!,
          _localChangedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sort_order'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncState: $CategoriesTable.$convertersyncState.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_state'],
        )!,
      ),
      localChangedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}local_changed_at'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncState, String, String> $convertersyncState =
      const EnumNameConverter<SyncState>(SyncState.values);
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final String? userId;
  final String name;
  final String color;
  final String? icon;
  final double sortOrder;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final SyncState syncState;
  final DateTime localChangedAt;
  const Category({
    required this.id,
    this.userId,
    required this.name,
    required this.color,
    this.icon,
    required this.sortOrder,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.syncState,
    required this.localChangedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['name'] = Variable<String>(name);
    map['color'] = Variable<String>(color);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['sort_order'] = Variable<double>(sortOrder);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    {
      map['sync_state'] = Variable<String>(
        $CategoriesTable.$convertersyncState.toSql(syncState),
      );
    }
    map['local_changed_at'] = Variable<DateTime>(localChangedAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      name: Value(name),
      color: Value(color),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      sortOrder: Value(sortOrder),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncState: Value(syncState),
      localChangedAt: Value(localChangedAt),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String>(json['color']),
      icon: serializer.fromJson<String?>(json['icon']),
      sortOrder: serializer.fromJson<double>(json['sortOrder']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncState: $CategoriesTable.$convertersyncState.fromJson(
        serializer.fromJson<String>(json['syncState']),
      ),
      localChangedAt: serializer.fromJson<DateTime>(json['localChangedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String>(color),
      'icon': serializer.toJson<String?>(icon),
      'sortOrder': serializer.toJson<double>(sortOrder),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncState': serializer.toJson<String>(
        $CategoriesTable.$convertersyncState.toJson(syncState),
      ),
      'localChangedAt': serializer.toJson<DateTime>(localChangedAt),
    };
  }

  Category copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    String? name,
    String? color,
    Value<String?> icon = const Value.absent(),
    double? sortOrder,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    SyncState? syncState,
    DateTime? localChangedAt,
  }) => Category(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    name: name ?? this.name,
    color: color ?? this.color,
    icon: icon.present ? icon.value : this.icon,
    sortOrder: sortOrder ?? this.sortOrder,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncState: syncState ?? this.syncState,
    localChangedAt: localChangedAt ?? this.localChangedAt,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      icon: data.icon.present ? data.icon.value : this.icon,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      localChangedAt: data.localChangedAt.present
          ? data.localChangedAt.value
          : this.localChangedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncState: $syncState, ')
          ..write('localChangedAt: $localChangedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    name,
    color,
    icon,
    sortOrder,
    isArchived,
    createdAt,
    updatedAt,
    deletedAt,
    syncState,
    localChangedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.color == this.color &&
          other.icon == this.icon &&
          other.sortOrder == this.sortOrder &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncState == this.syncState &&
          other.localChangedAt == this.localChangedAt);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<String> name;
  final Value<String> color;
  final Value<String?> icon;
  final Value<double> sortOrder;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<SyncState> syncState;
  final Value<DateTime> localChangedAt;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.localChangedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    required String name,
    required String color,
    this.icon = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.localChangedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       color = Value(color),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? color,
    Expression<String>? icon,
    Expression<double>? sortOrder,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncState,
    Expression<DateTime>? localChangedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncState != null) 'sync_state': syncState,
      if (localChangedAt != null) 'local_changed_at': localChangedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<String>? name,
    Value<String>? color,
    Value<String?>? icon,
    Value<double>? sortOrder,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<SyncState>? syncState,
    Value<DateTime>? localChangedAt,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      sortOrder: sortOrder ?? this.sortOrder,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncState: syncState ?? this.syncState,
      localChangedAt: localChangedAt ?? this.localChangedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<double>(sortOrder.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(
        $CategoriesTable.$convertersyncState.toSql(syncState.value),
      );
    }
    if (localChangedAt.present) {
      map['local_changed_at'] = Variable<DateTime>(localChangedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncState: $syncState, ')
          ..write('localChangedAt: $localChangedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 300,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _checklistMeta = const VerificationMeta(
    'checklist',
  );
  @override
  late final GeneratedColumn<String> checklist = GeneratedColumn<String>(
    'checklist',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _taskDateMeta = const VerificationMeta(
    'taskDate',
  );
  @override
  late final GeneratedColumn<DateTime> taskDate = GeneratedColumn<DateTime>(
    'task_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TimeMode, String> timeMode =
      GeneratedColumn<String>(
        'time_mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(TimeMode.none.name),
      ).withConverter<TimeMode>($TasksTable.$convertertimeMode);
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
    'start_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TaskStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(TaskStatus.todo.name),
      ).withConverter<TaskStatus>($TasksTable.$converterstatus);
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<double> sortOrder = GeneratedColumn<double>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _recurrenceRuleMeta = const VerificationMeta(
    'recurrenceRule',
  );
  @override
  late final GeneratedColumn<String> recurrenceRule = GeneratedColumn<String>(
    'recurrence_rule',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recurrenceParentIdMeta =
      const VerificationMeta('recurrenceParentId');
  @override
  late final GeneratedColumn<String> recurrenceParentId =
      GeneratedColumn<String>(
        'recurrence_parent_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncState, String> syncState =
      GeneratedColumn<String>(
        'sync_state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(SyncState.pending.name),
      ).withConverter<SyncState>($TasksTable.$convertersyncState);
  static const VerificationMeta _localChangedAtMeta = const VerificationMeta(
    'localChangedAt',
  );
  @override
  late final GeneratedColumn<DateTime> localChangedAt =
      GeneratedColumn<DateTime>(
        'local_changed_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: Constant(syncEpoch),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    categoryId,
    title,
    notes,
    checklist,
    taskDate,
    timeMode,
    startTime,
    endTime,
    status,
    completedAt,
    sortOrder,
    recurrenceRule,
    recurrenceParentId,
    createdAt,
    updatedAt,
    deletedAt,
    syncState,
    localChangedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Task> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('checklist')) {
      context.handle(
        _checklistMeta,
        checklist.isAcceptableOrUnknown(data['checklist']!, _checklistMeta),
      );
    }
    if (data.containsKey('task_date')) {
      context.handle(
        _taskDateMeta,
        taskDate.isAcceptableOrUnknown(data['task_date']!, _taskDateMeta),
      );
    } else if (isInserting) {
      context.missing(_taskDateMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('recurrence_rule')) {
      context.handle(
        _recurrenceRuleMeta,
        recurrenceRule.isAcceptableOrUnknown(
          data['recurrence_rule']!,
          _recurrenceRuleMeta,
        ),
      );
    }
    if (data.containsKey('recurrence_parent_id')) {
      context.handle(
        _recurrenceParentIdMeta,
        recurrenceParentId.isAcceptableOrUnknown(
          data['recurrence_parent_id']!,
          _recurrenceParentIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('local_changed_at')) {
      context.handle(
        _localChangedAtMeta,
        localChangedAt.isAcceptableOrUnknown(
          data['local_changed_at']!,
          _localChangedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      checklist: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checklist'],
      )!,
      taskDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}task_date'],
      )!,
      timeMode: $TasksTable.$convertertimeMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}time_mode'],
        )!,
      ),
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_time'],
      ),
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_time'],
      ),
      status: $TasksTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sort_order'],
      )!,
      recurrenceRule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurrence_rule'],
      ),
      recurrenceParentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurrence_parent_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncState: $TasksTable.$convertersyncState.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_state'],
        )!,
      ),
      localChangedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}local_changed_at'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TimeMode, String, String> $convertertimeMode =
      const EnumNameConverter<TimeMode>(TimeMode.values);
  static JsonTypeConverter2<TaskStatus, String, String> $converterstatus =
      const EnumNameConverter<TaskStatus>(TaskStatus.values);
  static JsonTypeConverter2<SyncState, String, String> $convertersyncState =
      const EnumNameConverter<SyncState>(SyncState.values);
}

class Task extends DataClass implements Insertable<Task> {
  final String id;
  final String? userId;
  final String? categoryId;
  final String title;
  final String? notes;
  final String checklist;
  final DateTime taskDate;
  final TimeMode timeMode;
  final String? startTime;
  final String? endTime;
  final TaskStatus status;
  final DateTime? completedAt;
  final double sortOrder;
  final String? recurrenceRule;
  final String? recurrenceParentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final SyncState syncState;
  final DateTime localChangedAt;
  const Task({
    required this.id,
    this.userId,
    this.categoryId,
    required this.title,
    this.notes,
    required this.checklist,
    required this.taskDate,
    required this.timeMode,
    this.startTime,
    this.endTime,
    required this.status,
    this.completedAt,
    required this.sortOrder,
    this.recurrenceRule,
    this.recurrenceParentId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.syncState,
    required this.localChangedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['checklist'] = Variable<String>(checklist);
    map['task_date'] = Variable<DateTime>(taskDate);
    {
      map['time_mode'] = Variable<String>(
        $TasksTable.$convertertimeMode.toSql(timeMode),
      );
    }
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = Variable<String>(startTime);
    }
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<String>(endTime);
    }
    {
      map['status'] = Variable<String>(
        $TasksTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['sort_order'] = Variable<double>(sortOrder);
    if (!nullToAbsent || recurrenceRule != null) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule);
    }
    if (!nullToAbsent || recurrenceParentId != null) {
      map['recurrence_parent_id'] = Variable<String>(recurrenceParentId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    {
      map['sync_state'] = Variable<String>(
        $TasksTable.$convertersyncState.toSql(syncState),
      );
    }
    map['local_changed_at'] = Variable<DateTime>(localChangedAt);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      title: Value(title),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      checklist: Value(checklist),
      taskDate: Value(taskDate),
      timeMode: Value(timeMode),
      startTime: startTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      status: Value(status),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      sortOrder: Value(sortOrder),
      recurrenceRule: recurrenceRule == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceRule),
      recurrenceParentId: recurrenceParentId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceParentId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncState: Value(syncState),
      localChangedAt: Value(localChangedAt),
    );
  }

  factory Task.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String?>(json['notes']),
      checklist: serializer.fromJson<String>(json['checklist']),
      taskDate: serializer.fromJson<DateTime>(json['taskDate']),
      timeMode: $TasksTable.$convertertimeMode.fromJson(
        serializer.fromJson<String>(json['timeMode']),
      ),
      startTime: serializer.fromJson<String?>(json['startTime']),
      endTime: serializer.fromJson<String?>(json['endTime']),
      status: $TasksTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      sortOrder: serializer.fromJson<double>(json['sortOrder']),
      recurrenceRule: serializer.fromJson<String?>(json['recurrenceRule']),
      recurrenceParentId: serializer.fromJson<String?>(
        json['recurrenceParentId'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncState: $TasksTable.$convertersyncState.fromJson(
        serializer.fromJson<String>(json['syncState']),
      ),
      localChangedAt: serializer.fromJson<DateTime>(json['localChangedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'title': serializer.toJson<String>(title),
      'notes': serializer.toJson<String?>(notes),
      'checklist': serializer.toJson<String>(checklist),
      'taskDate': serializer.toJson<DateTime>(taskDate),
      'timeMode': serializer.toJson<String>(
        $TasksTable.$convertertimeMode.toJson(timeMode),
      ),
      'startTime': serializer.toJson<String?>(startTime),
      'endTime': serializer.toJson<String?>(endTime),
      'status': serializer.toJson<String>(
        $TasksTable.$converterstatus.toJson(status),
      ),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'sortOrder': serializer.toJson<double>(sortOrder),
      'recurrenceRule': serializer.toJson<String?>(recurrenceRule),
      'recurrenceParentId': serializer.toJson<String?>(recurrenceParentId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncState': serializer.toJson<String>(
        $TasksTable.$convertersyncState.toJson(syncState),
      ),
      'localChangedAt': serializer.toJson<DateTime>(localChangedAt),
    };
  }

  Task copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    String? title,
    Value<String?> notes = const Value.absent(),
    String? checklist,
    DateTime? taskDate,
    TimeMode? timeMode,
    Value<String?> startTime = const Value.absent(),
    Value<String?> endTime = const Value.absent(),
    TaskStatus? status,
    Value<DateTime?> completedAt = const Value.absent(),
    double? sortOrder,
    Value<String?> recurrenceRule = const Value.absent(),
    Value<String?> recurrenceParentId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    SyncState? syncState,
    DateTime? localChangedAt,
  }) => Task(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    title: title ?? this.title,
    notes: notes.present ? notes.value : this.notes,
    checklist: checklist ?? this.checklist,
    taskDate: taskDate ?? this.taskDate,
    timeMode: timeMode ?? this.timeMode,
    startTime: startTime.present ? startTime.value : this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    status: status ?? this.status,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    sortOrder: sortOrder ?? this.sortOrder,
    recurrenceRule: recurrenceRule.present
        ? recurrenceRule.value
        : this.recurrenceRule,
    recurrenceParentId: recurrenceParentId.present
        ? recurrenceParentId.value
        : this.recurrenceParentId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncState: syncState ?? this.syncState,
    localChangedAt: localChangedAt ?? this.localChangedAt,
  );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      checklist: data.checklist.present ? data.checklist.value : this.checklist,
      taskDate: data.taskDate.present ? data.taskDate.value : this.taskDate,
      timeMode: data.timeMode.present ? data.timeMode.value : this.timeMode,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      status: data.status.present ? data.status.value : this.status,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      recurrenceRule: data.recurrenceRule.present
          ? data.recurrenceRule.value
          : this.recurrenceRule,
      recurrenceParentId: data.recurrenceParentId.present
          ? data.recurrenceParentId.value
          : this.recurrenceParentId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      localChangedAt: data.localChangedAt.present
          ? data.localChangedAt.value
          : this.localChangedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('categoryId: $categoryId, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('checklist: $checklist, ')
          ..write('taskDate: $taskDate, ')
          ..write('timeMode: $timeMode, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('status: $status, ')
          ..write('completedAt: $completedAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('recurrenceParentId: $recurrenceParentId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncState: $syncState, ')
          ..write('localChangedAt: $localChangedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    categoryId,
    title,
    notes,
    checklist,
    taskDate,
    timeMode,
    startTime,
    endTime,
    status,
    completedAt,
    sortOrder,
    recurrenceRule,
    recurrenceParentId,
    createdAt,
    updatedAt,
    deletedAt,
    syncState,
    localChangedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.categoryId == this.categoryId &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.checklist == this.checklist &&
          other.taskDate == this.taskDate &&
          other.timeMode == this.timeMode &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.status == this.status &&
          other.completedAt == this.completedAt &&
          other.sortOrder == this.sortOrder &&
          other.recurrenceRule == this.recurrenceRule &&
          other.recurrenceParentId == this.recurrenceParentId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncState == this.syncState &&
          other.localChangedAt == this.localChangedAt);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<String?> categoryId;
  final Value<String> title;
  final Value<String?> notes;
  final Value<String> checklist;
  final Value<DateTime> taskDate;
  final Value<TimeMode> timeMode;
  final Value<String?> startTime;
  final Value<String?> endTime;
  final Value<TaskStatus> status;
  final Value<DateTime?> completedAt;
  final Value<double> sortOrder;
  final Value<String?> recurrenceRule;
  final Value<String?> recurrenceParentId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<SyncState> syncState;
  final Value<DateTime> localChangedAt;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.checklist = const Value.absent(),
    this.taskDate = const Value.absent(),
    this.timeMode = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.status = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.recurrenceParentId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.localChangedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    this.categoryId = const Value.absent(),
    required String title,
    this.notes = const Value.absent(),
    this.checklist = const Value.absent(),
    required DateTime taskDate,
    this.timeMode = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.status = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.recurrenceParentId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.localChangedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       taskDate = Value(taskDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Task> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? categoryId,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<String>? checklist,
    Expression<DateTime>? taskDate,
    Expression<String>? timeMode,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<String>? status,
    Expression<DateTime>? completedAt,
    Expression<double>? sortOrder,
    Expression<String>? recurrenceRule,
    Expression<String>? recurrenceParentId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncState,
    Expression<DateTime>? localChangedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (categoryId != null) 'category_id': categoryId,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (checklist != null) 'checklist': checklist,
      if (taskDate != null) 'task_date': taskDate,
      if (timeMode != null) 'time_mode': timeMode,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (status != null) 'status': status,
      if (completedAt != null) 'completed_at': completedAt,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (recurrenceRule != null) 'recurrence_rule': recurrenceRule,
      if (recurrenceParentId != null)
        'recurrence_parent_id': recurrenceParentId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncState != null) 'sync_state': syncState,
      if (localChangedAt != null) 'local_changed_at': localChangedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<String?>? categoryId,
    Value<String>? title,
    Value<String?>? notes,
    Value<String>? checklist,
    Value<DateTime>? taskDate,
    Value<TimeMode>? timeMode,
    Value<String?>? startTime,
    Value<String?>? endTime,
    Value<TaskStatus>? status,
    Value<DateTime?>? completedAt,
    Value<double>? sortOrder,
    Value<String?>? recurrenceRule,
    Value<String?>? recurrenceParentId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<SyncState>? syncState,
    Value<DateTime>? localChangedAt,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      checklist: checklist ?? this.checklist,
      taskDate: taskDate ?? this.taskDate,
      timeMode: timeMode ?? this.timeMode,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      sortOrder: sortOrder ?? this.sortOrder,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      recurrenceParentId: recurrenceParentId ?? this.recurrenceParentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncState: syncState ?? this.syncState,
      localChangedAt: localChangedAt ?? this.localChangedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (checklist.present) {
      map['checklist'] = Variable<String>(checklist.value);
    }
    if (taskDate.present) {
      map['task_date'] = Variable<DateTime>(taskDate.value);
    }
    if (timeMode.present) {
      map['time_mode'] = Variable<String>(
        $TasksTable.$convertertimeMode.toSql(timeMode.value),
      );
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $TasksTable.$converterstatus.toSql(status.value),
      );
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<double>(sortOrder.value);
    }
    if (recurrenceRule.present) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule.value);
    }
    if (recurrenceParentId.present) {
      map['recurrence_parent_id'] = Variable<String>(recurrenceParentId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(
        $TasksTable.$convertersyncState.toSql(syncState.value),
      );
    }
    if (localChangedAt.present) {
      map['local_changed_at'] = Variable<DateTime>(localChangedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('categoryId: $categoryId, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('checklist: $checklist, ')
          ..write('taskDate: $taskDate, ')
          ..write('timeMode: $timeMode, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('status: $status, ')
          ..write('completedAt: $completedAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('recurrenceParentId: $recurrenceParentId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncState: $syncState, ')
          ..write('localChangedAt: $localChangedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalSettingsTable extends LocalSettings
    with TableInfo<$LocalSettingsTable, LocalSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _defaultCategoryIdMeta = const VerificationMeta(
    'defaultCategoryId',
  );
  @override
  late final GeneratedColumn<String> defaultCategoryId =
      GeneratedColumn<String>(
        'default_category_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES categories (id)',
        ),
      );
  static const VerificationMeta _selectedFilterCategoryIdMeta =
      const VerificationMeta('selectedFilterCategoryId');
  @override
  late final GeneratedColumn<String> selectedFilterCategoryId =
      GeneratedColumn<String>(
        'selected_filter_category_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES categories (id)',
        ),
      );
  static const VerificationMeta _lastSignedInUserIdMeta =
      const VerificationMeta('lastSignedInUserId');
  @override
  late final GeneratedColumn<String> lastSignedInUserId =
      GeneratedColumn<String>(
        'last_signed_in_user_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _useExactAlarmsMeta = const VerificationMeta(
    'useExactAlarms',
  );
  @override
  late final GeneratedColumn<bool> useExactAlarms = GeneratedColumn<bool>(
    'use_exact_alarms',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("use_exact_alarms" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notificationPermissionRequestedMeta =
      const VerificationMeta('notificationPermissionRequested');
  @override
  late final GeneratedColumn<bool> notificationPermissionRequested =
      GeneratedColumn<bool>(
        'notification_permission_requested',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("notification_permission_requested" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    defaultCategoryId,
    selectedFilterCategoryId,
    lastSignedInUserId,
    useExactAlarms,
    notificationPermissionRequested,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('default_category_id')) {
      context.handle(
        _defaultCategoryIdMeta,
        defaultCategoryId.isAcceptableOrUnknown(
          data['default_category_id']!,
          _defaultCategoryIdMeta,
        ),
      );
    }
    if (data.containsKey('selected_filter_category_id')) {
      context.handle(
        _selectedFilterCategoryIdMeta,
        selectedFilterCategoryId.isAcceptableOrUnknown(
          data['selected_filter_category_id']!,
          _selectedFilterCategoryIdMeta,
        ),
      );
    }
    if (data.containsKey('last_signed_in_user_id')) {
      context.handle(
        _lastSignedInUserIdMeta,
        lastSignedInUserId.isAcceptableOrUnknown(
          data['last_signed_in_user_id']!,
          _lastSignedInUserIdMeta,
        ),
      );
    }
    if (data.containsKey('use_exact_alarms')) {
      context.handle(
        _useExactAlarmsMeta,
        useExactAlarms.isAcceptableOrUnknown(
          data['use_exact_alarms']!,
          _useExactAlarmsMeta,
        ),
      );
    }
    if (data.containsKey('notification_permission_requested')) {
      context.handle(
        _notificationPermissionRequestedMeta,
        notificationPermissionRequested.isAcceptableOrUnknown(
          data['notification_permission_requested']!,
          _notificationPermissionRequestedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      defaultCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_category_id'],
      ),
      selectedFilterCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_filter_category_id'],
      ),
      lastSignedInUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_signed_in_user_id'],
      ),
      useExactAlarms: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}use_exact_alarms'],
      )!,
      notificationPermissionRequested: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notification_permission_requested'],
      )!,
    );
  }

  @override
  $LocalSettingsTable createAlias(String alias) {
    return $LocalSettingsTable(attachedDatabase, alias);
  }
}

class LocalSetting extends DataClass implements Insertable<LocalSetting> {
  final int id;
  final String? defaultCategoryId;
  final String? selectedFilterCategoryId;

  /// The Supabase user id last signed in on this device (M4). Used to
  /// detect an account switch — see `AppDatabase.clearAllLocalData`.
  final String? lastSignedInUserId;

  /// Android only (M6): use exact alarms (`SCHEDULE_EXACT_ALARM`) instead
  /// of the default inexact `AlarmManagerPlus` scheduling. Device-local —
  /// battery/permission tradeoffs don't travel with the account.
  final bool useExactAlarms;

  /// Whether the OS notification-permission prompt has been shown on this
  /// device yet (M6) — requested after the first task is created, not at
  /// launch, and only once (SPEC §8).
  final bool notificationPermissionRequested;
  const LocalSetting({
    required this.id,
    this.defaultCategoryId,
    this.selectedFilterCategoryId,
    this.lastSignedInUserId,
    required this.useExactAlarms,
    required this.notificationPermissionRequested,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || defaultCategoryId != null) {
      map['default_category_id'] = Variable<String>(defaultCategoryId);
    }
    if (!nullToAbsent || selectedFilterCategoryId != null) {
      map['selected_filter_category_id'] = Variable<String>(
        selectedFilterCategoryId,
      );
    }
    if (!nullToAbsent || lastSignedInUserId != null) {
      map['last_signed_in_user_id'] = Variable<String>(lastSignedInUserId);
    }
    map['use_exact_alarms'] = Variable<bool>(useExactAlarms);
    map['notification_permission_requested'] = Variable<bool>(
      notificationPermissionRequested,
    );
    return map;
  }

  LocalSettingsCompanion toCompanion(bool nullToAbsent) {
    return LocalSettingsCompanion(
      id: Value(id),
      defaultCategoryId: defaultCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultCategoryId),
      selectedFilterCategoryId: selectedFilterCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedFilterCategoryId),
      lastSignedInUserId: lastSignedInUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSignedInUserId),
      useExactAlarms: Value(useExactAlarms),
      notificationPermissionRequested: Value(notificationPermissionRequested),
    );
  }

  factory LocalSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalSetting(
      id: serializer.fromJson<int>(json['id']),
      defaultCategoryId: serializer.fromJson<String?>(
        json['defaultCategoryId'],
      ),
      selectedFilterCategoryId: serializer.fromJson<String?>(
        json['selectedFilterCategoryId'],
      ),
      lastSignedInUserId: serializer.fromJson<String?>(
        json['lastSignedInUserId'],
      ),
      useExactAlarms: serializer.fromJson<bool>(json['useExactAlarms']),
      notificationPermissionRequested: serializer.fromJson<bool>(
        json['notificationPermissionRequested'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'defaultCategoryId': serializer.toJson<String?>(defaultCategoryId),
      'selectedFilterCategoryId': serializer.toJson<String?>(
        selectedFilterCategoryId,
      ),
      'lastSignedInUserId': serializer.toJson<String?>(lastSignedInUserId),
      'useExactAlarms': serializer.toJson<bool>(useExactAlarms),
      'notificationPermissionRequested': serializer.toJson<bool>(
        notificationPermissionRequested,
      ),
    };
  }

  LocalSetting copyWith({
    int? id,
    Value<String?> defaultCategoryId = const Value.absent(),
    Value<String?> selectedFilterCategoryId = const Value.absent(),
    Value<String?> lastSignedInUserId = const Value.absent(),
    bool? useExactAlarms,
    bool? notificationPermissionRequested,
  }) => LocalSetting(
    id: id ?? this.id,
    defaultCategoryId: defaultCategoryId.present
        ? defaultCategoryId.value
        : this.defaultCategoryId,
    selectedFilterCategoryId: selectedFilterCategoryId.present
        ? selectedFilterCategoryId.value
        : this.selectedFilterCategoryId,
    lastSignedInUserId: lastSignedInUserId.present
        ? lastSignedInUserId.value
        : this.lastSignedInUserId,
    useExactAlarms: useExactAlarms ?? this.useExactAlarms,
    notificationPermissionRequested:
        notificationPermissionRequested ?? this.notificationPermissionRequested,
  );
  LocalSetting copyWithCompanion(LocalSettingsCompanion data) {
    return LocalSetting(
      id: data.id.present ? data.id.value : this.id,
      defaultCategoryId: data.defaultCategoryId.present
          ? data.defaultCategoryId.value
          : this.defaultCategoryId,
      selectedFilterCategoryId: data.selectedFilterCategoryId.present
          ? data.selectedFilterCategoryId.value
          : this.selectedFilterCategoryId,
      lastSignedInUserId: data.lastSignedInUserId.present
          ? data.lastSignedInUserId.value
          : this.lastSignedInUserId,
      useExactAlarms: data.useExactAlarms.present
          ? data.useExactAlarms.value
          : this.useExactAlarms,
      notificationPermissionRequested:
          data.notificationPermissionRequested.present
          ? data.notificationPermissionRequested.value
          : this.notificationPermissionRequested,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalSetting(')
          ..write('id: $id, ')
          ..write('defaultCategoryId: $defaultCategoryId, ')
          ..write('selectedFilterCategoryId: $selectedFilterCategoryId, ')
          ..write('lastSignedInUserId: $lastSignedInUserId, ')
          ..write('useExactAlarms: $useExactAlarms, ')
          ..write(
            'notificationPermissionRequested: $notificationPermissionRequested',
          )
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    defaultCategoryId,
    selectedFilterCategoryId,
    lastSignedInUserId,
    useExactAlarms,
    notificationPermissionRequested,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalSetting &&
          other.id == this.id &&
          other.defaultCategoryId == this.defaultCategoryId &&
          other.selectedFilterCategoryId == this.selectedFilterCategoryId &&
          other.lastSignedInUserId == this.lastSignedInUserId &&
          other.useExactAlarms == this.useExactAlarms &&
          other.notificationPermissionRequested ==
              this.notificationPermissionRequested);
}

class LocalSettingsCompanion extends UpdateCompanion<LocalSetting> {
  final Value<int> id;
  final Value<String?> defaultCategoryId;
  final Value<String?> selectedFilterCategoryId;
  final Value<String?> lastSignedInUserId;
  final Value<bool> useExactAlarms;
  final Value<bool> notificationPermissionRequested;
  const LocalSettingsCompanion({
    this.id = const Value.absent(),
    this.defaultCategoryId = const Value.absent(),
    this.selectedFilterCategoryId = const Value.absent(),
    this.lastSignedInUserId = const Value.absent(),
    this.useExactAlarms = const Value.absent(),
    this.notificationPermissionRequested = const Value.absent(),
  });
  LocalSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.defaultCategoryId = const Value.absent(),
    this.selectedFilterCategoryId = const Value.absent(),
    this.lastSignedInUserId = const Value.absent(),
    this.useExactAlarms = const Value.absent(),
    this.notificationPermissionRequested = const Value.absent(),
  });
  static Insertable<LocalSetting> custom({
    Expression<int>? id,
    Expression<String>? defaultCategoryId,
    Expression<String>? selectedFilterCategoryId,
    Expression<String>? lastSignedInUserId,
    Expression<bool>? useExactAlarms,
    Expression<bool>? notificationPermissionRequested,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (defaultCategoryId != null) 'default_category_id': defaultCategoryId,
      if (selectedFilterCategoryId != null)
        'selected_filter_category_id': selectedFilterCategoryId,
      if (lastSignedInUserId != null)
        'last_signed_in_user_id': lastSignedInUserId,
      if (useExactAlarms != null) 'use_exact_alarms': useExactAlarms,
      if (notificationPermissionRequested != null)
        'notification_permission_requested': notificationPermissionRequested,
    });
  }

  LocalSettingsCompanion copyWith({
    Value<int>? id,
    Value<String?>? defaultCategoryId,
    Value<String?>? selectedFilterCategoryId,
    Value<String?>? lastSignedInUserId,
    Value<bool>? useExactAlarms,
    Value<bool>? notificationPermissionRequested,
  }) {
    return LocalSettingsCompanion(
      id: id ?? this.id,
      defaultCategoryId: defaultCategoryId ?? this.defaultCategoryId,
      selectedFilterCategoryId:
          selectedFilterCategoryId ?? this.selectedFilterCategoryId,
      lastSignedInUserId: lastSignedInUserId ?? this.lastSignedInUserId,
      useExactAlarms: useExactAlarms ?? this.useExactAlarms,
      notificationPermissionRequested:
          notificationPermissionRequested ??
          this.notificationPermissionRequested,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (defaultCategoryId.present) {
      map['default_category_id'] = Variable<String>(defaultCategoryId.value);
    }
    if (selectedFilterCategoryId.present) {
      map['selected_filter_category_id'] = Variable<String>(
        selectedFilterCategoryId.value,
      );
    }
    if (lastSignedInUserId.present) {
      map['last_signed_in_user_id'] = Variable<String>(
        lastSignedInUserId.value,
      );
    }
    if (useExactAlarms.present) {
      map['use_exact_alarms'] = Variable<bool>(useExactAlarms.value);
    }
    if (notificationPermissionRequested.present) {
      map['notification_permission_requested'] = Variable<bool>(
        notificationPermissionRequested.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSettingsCompanion(')
          ..write('id: $id, ')
          ..write('defaultCategoryId: $defaultCategoryId, ')
          ..write('selectedFilterCategoryId: $selectedFilterCategoryId, ')
          ..write('lastSignedInUserId: $lastSignedInUserId, ')
          ..write('useExactAlarms: $useExactAlarms, ')
          ..write(
            'notificationPermissionRequested: $notificationPermissionRequested',
          )
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTableTable extends UserSettingsTable
    with TableInfo<$UserSettingsTableTable, UserSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _morningEnabledMeta = const VerificationMeta(
    'morningEnabled',
  );
  @override
  late final GeneratedColumn<bool> morningEnabled = GeneratedColumn<bool>(
    'morning_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("morning_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _morningTimeMeta = const VerificationMeta(
    'morningTime',
  );
  @override
  late final GeneratedColumn<String> morningTime = GeneratedColumn<String>(
    'morning_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('07:30:00'),
  );
  static const VerificationMeta _eveningEnabledMeta = const VerificationMeta(
    'eveningEnabled',
  );
  @override
  late final GeneratedColumn<bool> eveningEnabled = GeneratedColumn<bool>(
    'evening_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("evening_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _eveningTimeMeta = const VerificationMeta(
    'eveningTime',
  );
  @override
  late final GeneratedColumn<String> eveningTime = GeneratedColumn<String>(
    'evening_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('21:00:00'),
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _weekStartsOnMeta = const VerificationMeta(
    'weekStartsOn',
  );
  @override
  late final GeneratedColumn<int> weekStartsOn = GeneratedColumn<int>(
    'week_starts_on',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _defaultCategoryIdMeta = const VerificationMeta(
    'defaultCategoryId',
  );
  @override
  late final GeneratedColumn<String> defaultCategoryId =
      GeneratedColumn<String>(
        'default_category_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES categories (id)',
        ),
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncState, String> syncState =
      GeneratedColumn<String>(
        'sync_state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(SyncState.pending.name),
      ).withConverter<SyncState>($UserSettingsTableTable.$convertersyncState);
  static const VerificationMeta _localChangedAtMeta = const VerificationMeta(
    'localChangedAt',
  );
  @override
  late final GeneratedColumn<DateTime> localChangedAt =
      GeneratedColumn<DateTime>(
        'local_changed_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: Constant(syncEpoch),
      );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    morningEnabled,
    morningTime,
    eveningEnabled,
    eveningTime,
    themeMode,
    weekStartsOn,
    defaultCategoryId,
    updatedAt,
    syncState,
    localChangedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('morning_enabled')) {
      context.handle(
        _morningEnabledMeta,
        morningEnabled.isAcceptableOrUnknown(
          data['morning_enabled']!,
          _morningEnabledMeta,
        ),
      );
    }
    if (data.containsKey('morning_time')) {
      context.handle(
        _morningTimeMeta,
        morningTime.isAcceptableOrUnknown(
          data['morning_time']!,
          _morningTimeMeta,
        ),
      );
    }
    if (data.containsKey('evening_enabled')) {
      context.handle(
        _eveningEnabledMeta,
        eveningEnabled.isAcceptableOrUnknown(
          data['evening_enabled']!,
          _eveningEnabledMeta,
        ),
      );
    }
    if (data.containsKey('evening_time')) {
      context.handle(
        _eveningTimeMeta,
        eveningTime.isAcceptableOrUnknown(
          data['evening_time']!,
          _eveningTimeMeta,
        ),
      );
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('week_starts_on')) {
      context.handle(
        _weekStartsOnMeta,
        weekStartsOn.isAcceptableOrUnknown(
          data['week_starts_on']!,
          _weekStartsOnMeta,
        ),
      );
    }
    if (data.containsKey('default_category_id')) {
      context.handle(
        _defaultCategoryIdMeta,
        defaultCategoryId.isAcceptableOrUnknown(
          data['default_category_id']!,
          _defaultCategoryIdMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('local_changed_at')) {
      context.handle(
        _localChangedAtMeta,
        localChangedAt.isAcceptableOrUnknown(
          data['local_changed_at']!,
          _localChangedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  UserSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSettingsRow(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      morningEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}morning_enabled'],
      )!,
      morningTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}morning_time'],
      )!,
      eveningEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}evening_enabled'],
      )!,
      eveningTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evening_time'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      weekStartsOn: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}week_starts_on'],
      )!,
      defaultCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_category_id'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncState: $UserSettingsTableTable.$convertersyncState.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_state'],
        )!,
      ),
      localChangedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}local_changed_at'],
      )!,
    );
  }

  @override
  $UserSettingsTableTable createAlias(String alias) {
    return $UserSettingsTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncState, String, String> $convertersyncState =
      const EnumNameConverter<SyncState>(SyncState.values);
}

class UserSettingsRow extends DataClass implements Insertable<UserSettingsRow> {
  final String userId;
  final bool morningEnabled;

  /// "HH:mm:ss" floating local time (CLAUDE.md rule 5), mirrors Postgres
  /// `time`. Not yet read by any screen — M6 wires notification scheduling.
  final String morningTime;
  final bool eveningEnabled;
  final String eveningTime;
  final String themeMode;
  final int weekStartsOn;
  final String? defaultCategoryId;
  final DateTime updatedAt;
  final SyncState syncState;
  final DateTime localChangedAt;
  const UserSettingsRow({
    required this.userId,
    required this.morningEnabled,
    required this.morningTime,
    required this.eveningEnabled,
    required this.eveningTime,
    required this.themeMode,
    required this.weekStartsOn,
    this.defaultCategoryId,
    required this.updatedAt,
    required this.syncState,
    required this.localChangedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['morning_enabled'] = Variable<bool>(morningEnabled);
    map['morning_time'] = Variable<String>(morningTime);
    map['evening_enabled'] = Variable<bool>(eveningEnabled);
    map['evening_time'] = Variable<String>(eveningTime);
    map['theme_mode'] = Variable<String>(themeMode);
    map['week_starts_on'] = Variable<int>(weekStartsOn);
    if (!nullToAbsent || defaultCategoryId != null) {
      map['default_category_id'] = Variable<String>(defaultCategoryId);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_state'] = Variable<String>(
        $UserSettingsTableTable.$convertersyncState.toSql(syncState),
      );
    }
    map['local_changed_at'] = Variable<DateTime>(localChangedAt);
    return map;
  }

  UserSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsTableCompanion(
      userId: Value(userId),
      morningEnabled: Value(morningEnabled),
      morningTime: Value(morningTime),
      eveningEnabled: Value(eveningEnabled),
      eveningTime: Value(eveningTime),
      themeMode: Value(themeMode),
      weekStartsOn: Value(weekStartsOn),
      defaultCategoryId: defaultCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultCategoryId),
      updatedAt: Value(updatedAt),
      syncState: Value(syncState),
      localChangedAt: Value(localChangedAt),
    );
  }

  factory UserSettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSettingsRow(
      userId: serializer.fromJson<String>(json['userId']),
      morningEnabled: serializer.fromJson<bool>(json['morningEnabled']),
      morningTime: serializer.fromJson<String>(json['morningTime']),
      eveningEnabled: serializer.fromJson<bool>(json['eveningEnabled']),
      eveningTime: serializer.fromJson<String>(json['eveningTime']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      weekStartsOn: serializer.fromJson<int>(json['weekStartsOn']),
      defaultCategoryId: serializer.fromJson<String?>(
        json['defaultCategoryId'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncState: $UserSettingsTableTable.$convertersyncState.fromJson(
        serializer.fromJson<String>(json['syncState']),
      ),
      localChangedAt: serializer.fromJson<DateTime>(json['localChangedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'morningEnabled': serializer.toJson<bool>(morningEnabled),
      'morningTime': serializer.toJson<String>(morningTime),
      'eveningEnabled': serializer.toJson<bool>(eveningEnabled),
      'eveningTime': serializer.toJson<String>(eveningTime),
      'themeMode': serializer.toJson<String>(themeMode),
      'weekStartsOn': serializer.toJson<int>(weekStartsOn),
      'defaultCategoryId': serializer.toJson<String?>(defaultCategoryId),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncState': serializer.toJson<String>(
        $UserSettingsTableTable.$convertersyncState.toJson(syncState),
      ),
      'localChangedAt': serializer.toJson<DateTime>(localChangedAt),
    };
  }

  UserSettingsRow copyWith({
    String? userId,
    bool? morningEnabled,
    String? morningTime,
    bool? eveningEnabled,
    String? eveningTime,
    String? themeMode,
    int? weekStartsOn,
    Value<String?> defaultCategoryId = const Value.absent(),
    DateTime? updatedAt,
    SyncState? syncState,
    DateTime? localChangedAt,
  }) => UserSettingsRow(
    userId: userId ?? this.userId,
    morningEnabled: morningEnabled ?? this.morningEnabled,
    morningTime: morningTime ?? this.morningTime,
    eveningEnabled: eveningEnabled ?? this.eveningEnabled,
    eveningTime: eveningTime ?? this.eveningTime,
    themeMode: themeMode ?? this.themeMode,
    weekStartsOn: weekStartsOn ?? this.weekStartsOn,
    defaultCategoryId: defaultCategoryId.present
        ? defaultCategoryId.value
        : this.defaultCategoryId,
    updatedAt: updatedAt ?? this.updatedAt,
    syncState: syncState ?? this.syncState,
    localChangedAt: localChangedAt ?? this.localChangedAt,
  );
  UserSettingsRow copyWithCompanion(UserSettingsTableCompanion data) {
    return UserSettingsRow(
      userId: data.userId.present ? data.userId.value : this.userId,
      morningEnabled: data.morningEnabled.present
          ? data.morningEnabled.value
          : this.morningEnabled,
      morningTime: data.morningTime.present
          ? data.morningTime.value
          : this.morningTime,
      eveningEnabled: data.eveningEnabled.present
          ? data.eveningEnabled.value
          : this.eveningEnabled,
      eveningTime: data.eveningTime.present
          ? data.eveningTime.value
          : this.eveningTime,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      weekStartsOn: data.weekStartsOn.present
          ? data.weekStartsOn.value
          : this.weekStartsOn,
      defaultCategoryId: data.defaultCategoryId.present
          ? data.defaultCategoryId.value
          : this.defaultCategoryId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      localChangedAt: data.localChangedAt.present
          ? data.localChangedAt.value
          : this.localChangedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsRow(')
          ..write('userId: $userId, ')
          ..write('morningEnabled: $morningEnabled, ')
          ..write('morningTime: $morningTime, ')
          ..write('eveningEnabled: $eveningEnabled, ')
          ..write('eveningTime: $eveningTime, ')
          ..write('themeMode: $themeMode, ')
          ..write('weekStartsOn: $weekStartsOn, ')
          ..write('defaultCategoryId: $defaultCategoryId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('localChangedAt: $localChangedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    morningEnabled,
    morningTime,
    eveningEnabled,
    eveningTime,
    themeMode,
    weekStartsOn,
    defaultCategoryId,
    updatedAt,
    syncState,
    localChangedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSettingsRow &&
          other.userId == this.userId &&
          other.morningEnabled == this.morningEnabled &&
          other.morningTime == this.morningTime &&
          other.eveningEnabled == this.eveningEnabled &&
          other.eveningTime == this.eveningTime &&
          other.themeMode == this.themeMode &&
          other.weekStartsOn == this.weekStartsOn &&
          other.defaultCategoryId == this.defaultCategoryId &&
          other.updatedAt == this.updatedAt &&
          other.syncState == this.syncState &&
          other.localChangedAt == this.localChangedAt);
}

class UserSettingsTableCompanion extends UpdateCompanion<UserSettingsRow> {
  final Value<String> userId;
  final Value<bool> morningEnabled;
  final Value<String> morningTime;
  final Value<bool> eveningEnabled;
  final Value<String> eveningTime;
  final Value<String> themeMode;
  final Value<int> weekStartsOn;
  final Value<String?> defaultCategoryId;
  final Value<DateTime> updatedAt;
  final Value<SyncState> syncState;
  final Value<DateTime> localChangedAt;
  final Value<int> rowid;
  const UserSettingsTableCompanion({
    this.userId = const Value.absent(),
    this.morningEnabled = const Value.absent(),
    this.morningTime = const Value.absent(),
    this.eveningEnabled = const Value.absent(),
    this.eveningTime = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.weekStartsOn = const Value.absent(),
    this.defaultCategoryId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.localChangedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserSettingsTableCompanion.insert({
    required String userId,
    this.morningEnabled = const Value.absent(),
    this.morningTime = const Value.absent(),
    this.eveningEnabled = const Value.absent(),
    this.eveningTime = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.weekStartsOn = const Value.absent(),
    this.defaultCategoryId = const Value.absent(),
    required DateTime updatedAt,
    this.syncState = const Value.absent(),
    this.localChangedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       updatedAt = Value(updatedAt);
  static Insertable<UserSettingsRow> custom({
    Expression<String>? userId,
    Expression<bool>? morningEnabled,
    Expression<String>? morningTime,
    Expression<bool>? eveningEnabled,
    Expression<String>? eveningTime,
    Expression<String>? themeMode,
    Expression<int>? weekStartsOn,
    Expression<String>? defaultCategoryId,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncState,
    Expression<DateTime>? localChangedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (morningEnabled != null) 'morning_enabled': morningEnabled,
      if (morningTime != null) 'morning_time': morningTime,
      if (eveningEnabled != null) 'evening_enabled': eveningEnabled,
      if (eveningTime != null) 'evening_time': eveningTime,
      if (themeMode != null) 'theme_mode': themeMode,
      if (weekStartsOn != null) 'week_starts_on': weekStartsOn,
      if (defaultCategoryId != null) 'default_category_id': defaultCategoryId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncState != null) 'sync_state': syncState,
      if (localChangedAt != null) 'local_changed_at': localChangedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserSettingsTableCompanion copyWith({
    Value<String>? userId,
    Value<bool>? morningEnabled,
    Value<String>? morningTime,
    Value<bool>? eveningEnabled,
    Value<String>? eveningTime,
    Value<String>? themeMode,
    Value<int>? weekStartsOn,
    Value<String?>? defaultCategoryId,
    Value<DateTime>? updatedAt,
    Value<SyncState>? syncState,
    Value<DateTime>? localChangedAt,
    Value<int>? rowid,
  }) {
    return UserSettingsTableCompanion(
      userId: userId ?? this.userId,
      morningEnabled: morningEnabled ?? this.morningEnabled,
      morningTime: morningTime ?? this.morningTime,
      eveningEnabled: eveningEnabled ?? this.eveningEnabled,
      eveningTime: eveningTime ?? this.eveningTime,
      themeMode: themeMode ?? this.themeMode,
      weekStartsOn: weekStartsOn ?? this.weekStartsOn,
      defaultCategoryId: defaultCategoryId ?? this.defaultCategoryId,
      updatedAt: updatedAt ?? this.updatedAt,
      syncState: syncState ?? this.syncState,
      localChangedAt: localChangedAt ?? this.localChangedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (morningEnabled.present) {
      map['morning_enabled'] = Variable<bool>(morningEnabled.value);
    }
    if (morningTime.present) {
      map['morning_time'] = Variable<String>(morningTime.value);
    }
    if (eveningEnabled.present) {
      map['evening_enabled'] = Variable<bool>(eveningEnabled.value);
    }
    if (eveningTime.present) {
      map['evening_time'] = Variable<String>(eveningTime.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (weekStartsOn.present) {
      map['week_starts_on'] = Variable<int>(weekStartsOn.value);
    }
    if (defaultCategoryId.present) {
      map['default_category_id'] = Variable<String>(defaultCategoryId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(
        $UserSettingsTableTable.$convertersyncState.toSql(syncState.value),
      );
    }
    if (localChangedAt.present) {
      map['local_changed_at'] = Variable<DateTime>(localChangedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsTableCompanion(')
          ..write('userId: $userId, ')
          ..write('morningEnabled: $morningEnabled, ')
          ..write('morningTime: $morningTime, ')
          ..write('eveningEnabled: $eveningEnabled, ')
          ..write('eveningTime: $eveningTime, ')
          ..write('themeMode: $themeMode, ')
          ..write('weekStartsOn: $weekStartsOn, ')
          ..write('defaultCategoryId: $defaultCategoryId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('localChangedAt: $localChangedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxEntriesTable extends OutboxEntries
    with TableInfo<$OutboxEntriesTable, OutboxEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _targetTableMeta = const VerificationMeta(
    'targetTable',
  );
  @override
  late final GeneratedColumn<String> targetTable = GeneratedColumn<String>(
    'target_table',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<String> rowId = GeneratedColumn<String>(
    'row_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opMeta = const VerificationMeta('op');
  @override
  late final GeneratedColumn<String> op = GeneratedColumn<String>(
    'op',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('upsert'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    targetTable,
    rowId,
    op,
    createdAt,
    attempts,
    status,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('target_table')) {
      context.handle(
        _targetTableMeta,
        targetTable.isAcceptableOrUnknown(
          data['target_table']!,
          _targetTableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetTableMeta);
    }
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rowIdMeta);
    }
    if (data.containsKey('op')) {
      context.handle(_opMeta, op.isAcceptableOrUnknown(data['op']!, _opMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      targetTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_table'],
      )!,
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}row_id'],
      )!,
      op: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $OutboxEntriesTable createAlias(String alias) {
    return $OutboxEntriesTable(attachedDatabase, alias);
  }
}

class OutboxEntry extends DataClass implements Insertable<OutboxEntry> {
  final int id;

  /// Which local table the row lives in (`tableNameCategories` etc. from
  /// `outbox_dao.dart`). Named `targetTable`, not `tableName` — the latter
  /// is reserved by drift's `Table.tableName` (the SQL table name override).
  final String targetTable;
  final String rowId;

  /// Always `'upsert'` today — soft deletes are just a `deleted_at` field
  /// upsert (CLAUDE.md rule 6, no hard deletes). Kept as a column so a
  /// future hard-delete op doesn't need a schema change.
  final String op;
  final DateTime createdAt;
  final int attempts;

  /// `'pending'` (still retrying) or `'failed'` (a non-retriable 4xx — shown
  /// in Settings; `SyncEngine.retryFailed` or a fresh local write on the
  /// same row moves it back to `'pending'`).
  final String status;
  final String? lastError;
  const OutboxEntry({
    required this.id,
    required this.targetTable,
    required this.rowId,
    required this.op,
    required this.createdAt,
    required this.attempts,
    required this.status,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['target_table'] = Variable<String>(targetTable);
    map['row_id'] = Variable<String>(rowId);
    map['op'] = Variable<String>(op);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['attempts'] = Variable<int>(attempts);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  OutboxEntriesCompanion toCompanion(bool nullToAbsent) {
    return OutboxEntriesCompanion(
      id: Value(id),
      targetTable: Value(targetTable),
      rowId: Value(rowId),
      op: Value(op),
      createdAt: Value(createdAt),
      attempts: Value(attempts),
      status: Value(status),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory OutboxEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxEntry(
      id: serializer.fromJson<int>(json['id']),
      targetTable: serializer.fromJson<String>(json['targetTable']),
      rowId: serializer.fromJson<String>(json['rowId']),
      op: serializer.fromJson<String>(json['op']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
      status: serializer.fromJson<String>(json['status']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'targetTable': serializer.toJson<String>(targetTable),
      'rowId': serializer.toJson<String>(rowId),
      'op': serializer.toJson<String>(op),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'attempts': serializer.toJson<int>(attempts),
      'status': serializer.toJson<String>(status),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  OutboxEntry copyWith({
    int? id,
    String? targetTable,
    String? rowId,
    String? op,
    DateTime? createdAt,
    int? attempts,
    String? status,
    Value<String?> lastError = const Value.absent(),
  }) => OutboxEntry(
    id: id ?? this.id,
    targetTable: targetTable ?? this.targetTable,
    rowId: rowId ?? this.rowId,
    op: op ?? this.op,
    createdAt: createdAt ?? this.createdAt,
    attempts: attempts ?? this.attempts,
    status: status ?? this.status,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  OutboxEntry copyWithCompanion(OutboxEntriesCompanion data) {
    return OutboxEntry(
      id: data.id.present ? data.id.value : this.id,
      targetTable: data.targetTable.present
          ? data.targetTable.value
          : this.targetTable,
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      op: data.op.present ? data.op.value : this.op,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      status: data.status.present ? data.status.value : this.status,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntry(')
          ..write('id: $id, ')
          ..write('targetTable: $targetTable, ')
          ..write('rowId: $rowId, ')
          ..write('op: $op, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('status: $status, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    targetTable,
    rowId,
    op,
    createdAt,
    attempts,
    status,
    lastError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxEntry &&
          other.id == this.id &&
          other.targetTable == this.targetTable &&
          other.rowId == this.rowId &&
          other.op == this.op &&
          other.createdAt == this.createdAt &&
          other.attempts == this.attempts &&
          other.status == this.status &&
          other.lastError == this.lastError);
}

class OutboxEntriesCompanion extends UpdateCompanion<OutboxEntry> {
  final Value<int> id;
  final Value<String> targetTable;
  final Value<String> rowId;
  final Value<String> op;
  final Value<DateTime> createdAt;
  final Value<int> attempts;
  final Value<String> status;
  final Value<String?> lastError;
  const OutboxEntriesCompanion({
    this.id = const Value.absent(),
    this.targetTable = const Value.absent(),
    this.rowId = const Value.absent(),
    this.op = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.status = const Value.absent(),
    this.lastError = const Value.absent(),
  });
  OutboxEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String targetTable,
    required String rowId,
    this.op = const Value.absent(),
    required DateTime createdAt,
    this.attempts = const Value.absent(),
    this.status = const Value.absent(),
    this.lastError = const Value.absent(),
  }) : targetTable = Value(targetTable),
       rowId = Value(rowId),
       createdAt = Value(createdAt);
  static Insertable<OutboxEntry> custom({
    Expression<int>? id,
    Expression<String>? targetTable,
    Expression<String>? rowId,
    Expression<String>? op,
    Expression<DateTime>? createdAt,
    Expression<int>? attempts,
    Expression<String>? status,
    Expression<String>? lastError,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (targetTable != null) 'target_table': targetTable,
      if (rowId != null) 'row_id': rowId,
      if (op != null) 'op': op,
      if (createdAt != null) 'created_at': createdAt,
      if (attempts != null) 'attempts': attempts,
      if (status != null) 'status': status,
      if (lastError != null) 'last_error': lastError,
    });
  }

  OutboxEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? targetTable,
    Value<String>? rowId,
    Value<String>? op,
    Value<DateTime>? createdAt,
    Value<int>? attempts,
    Value<String>? status,
    Value<String?>? lastError,
  }) {
    return OutboxEntriesCompanion(
      id: id ?? this.id,
      targetTable: targetTable ?? this.targetTable,
      rowId: rowId ?? this.rowId,
      op: op ?? this.op,
      createdAt: createdAt ?? this.createdAt,
      attempts: attempts ?? this.attempts,
      status: status ?? this.status,
      lastError: lastError ?? this.lastError,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (targetTable.present) {
      map['target_table'] = Variable<String>(targetTable.value);
    }
    if (rowId.present) {
      map['row_id'] = Variable<String>(rowId.value);
    }
    if (op.present) {
      map['op'] = Variable<String>(op.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntriesCompanion(')
          ..write('id: $id, ')
          ..write('targetTable: $targetTable, ')
          ..write('rowId: $rowId, ')
          ..write('op: $op, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('status: $status, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }
}

class $SyncCursorsTable extends SyncCursors
    with TableInfo<$SyncCursorsTable, SyncCursor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncCursorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _targetTableMeta = const VerificationMeta(
    'targetTable',
  );
  @override
  late final GeneratedColumn<String> targetTable = GeneratedColumn<String>(
    'target_table',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastPulledAtMeta = const VerificationMeta(
    'lastPulledAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastPulledAt = GeneratedColumn<DateTime>(
    'last_pulled_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [targetTable, lastPulledAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_cursors';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncCursor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('target_table')) {
      context.handle(
        _targetTableMeta,
        targetTable.isAcceptableOrUnknown(
          data['target_table']!,
          _targetTableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetTableMeta);
    }
    if (data.containsKey('last_pulled_at')) {
      context.handle(
        _lastPulledAtMeta,
        lastPulledAt.isAcceptableOrUnknown(
          data['last_pulled_at']!,
          _lastPulledAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {targetTable};
  @override
  SyncCursor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncCursor(
      targetTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_table'],
      )!,
      lastPulledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_pulled_at'],
      ),
    );
  }

  @override
  $SyncCursorsTable createAlias(String alias) {
    return $SyncCursorsTable(attachedDatabase, alias);
  }
}

class SyncCursor extends DataClass implements Insertable<SyncCursor> {
  final String targetTable;
  final DateTime? lastPulledAt;
  const SyncCursor({required this.targetTable, this.lastPulledAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['target_table'] = Variable<String>(targetTable);
    if (!nullToAbsent || lastPulledAt != null) {
      map['last_pulled_at'] = Variable<DateTime>(lastPulledAt);
    }
    return map;
  }

  SyncCursorsCompanion toCompanion(bool nullToAbsent) {
    return SyncCursorsCompanion(
      targetTable: Value(targetTable),
      lastPulledAt: lastPulledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPulledAt),
    );
  }

  factory SyncCursor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncCursor(
      targetTable: serializer.fromJson<String>(json['targetTable']),
      lastPulledAt: serializer.fromJson<DateTime?>(json['lastPulledAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'targetTable': serializer.toJson<String>(targetTable),
      'lastPulledAt': serializer.toJson<DateTime?>(lastPulledAt),
    };
  }

  SyncCursor copyWith({
    String? targetTable,
    Value<DateTime?> lastPulledAt = const Value.absent(),
  }) => SyncCursor(
    targetTable: targetTable ?? this.targetTable,
    lastPulledAt: lastPulledAt.present ? lastPulledAt.value : this.lastPulledAt,
  );
  SyncCursor copyWithCompanion(SyncCursorsCompanion data) {
    return SyncCursor(
      targetTable: data.targetTable.present
          ? data.targetTable.value
          : this.targetTable,
      lastPulledAt: data.lastPulledAt.present
          ? data.lastPulledAt.value
          : this.lastPulledAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncCursor(')
          ..write('targetTable: $targetTable, ')
          ..write('lastPulledAt: $lastPulledAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(targetTable, lastPulledAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncCursor &&
          other.targetTable == this.targetTable &&
          other.lastPulledAt == this.lastPulledAt);
}

class SyncCursorsCompanion extends UpdateCompanion<SyncCursor> {
  final Value<String> targetTable;
  final Value<DateTime?> lastPulledAt;
  final Value<int> rowid;
  const SyncCursorsCompanion({
    this.targetTable = const Value.absent(),
    this.lastPulledAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncCursorsCompanion.insert({
    required String targetTable,
    this.lastPulledAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : targetTable = Value(targetTable);
  static Insertable<SyncCursor> custom({
    Expression<String>? targetTable,
    Expression<DateTime>? lastPulledAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (targetTable != null) 'target_table': targetTable,
      if (lastPulledAt != null) 'last_pulled_at': lastPulledAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncCursorsCompanion copyWith({
    Value<String>? targetTable,
    Value<DateTime?>? lastPulledAt,
    Value<int>? rowid,
  }) {
    return SyncCursorsCompanion(
      targetTable: targetTable ?? this.targetTable,
      lastPulledAt: lastPulledAt ?? this.lastPulledAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (targetTable.present) {
      map['target_table'] = Variable<String>(targetTable.value);
    }
    if (lastPulledAt.present) {
      map['last_pulled_at'] = Variable<DateTime>(lastPulledAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncCursorsCompanion(')
          ..write('targetTable: $targetTable, ')
          ..write('lastPulledAt: $lastPulledAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetaTable extends SyncMeta
    with TableInfo<$SyncMetaTable, SyncMetaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _initialSyncDoneUserIdMeta =
      const VerificationMeta('initialSyncDoneUserId');
  @override
  late final GeneratedColumn<String> initialSyncDoneUserId =
      GeneratedColumn<String>(
        'initial_sync_done_user_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [id, initialSyncDoneUserId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMetaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('initial_sync_done_user_id')) {
      context.handle(
        _initialSyncDoneUserIdMeta,
        initialSyncDoneUserId.isAcceptableOrUnknown(
          data['initial_sync_done_user_id']!,
          _initialSyncDoneUserIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncMetaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetaRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      initialSyncDoneUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}initial_sync_done_user_id'],
      ),
    );
  }

  @override
  $SyncMetaTable createAlias(String alias) {
    return $SyncMetaTable(attachedDatabase, alias);
  }
}

class SyncMetaRow extends DataClass implements Insertable<SyncMetaRow> {
  final int id;
  final String? initialSyncDoneUserId;
  const SyncMetaRow({required this.id, this.initialSyncDoneUserId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || initialSyncDoneUserId != null) {
      map['initial_sync_done_user_id'] = Variable<String>(
        initialSyncDoneUserId,
      );
    }
    return map;
  }

  SyncMetaCompanion toCompanion(bool nullToAbsent) {
    return SyncMetaCompanion(
      id: Value(id),
      initialSyncDoneUserId: initialSyncDoneUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(initialSyncDoneUserId),
    );
  }

  factory SyncMetaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetaRow(
      id: serializer.fromJson<int>(json['id']),
      initialSyncDoneUserId: serializer.fromJson<String?>(
        json['initialSyncDoneUserId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'initialSyncDoneUserId': serializer.toJson<String?>(
        initialSyncDoneUserId,
      ),
    };
  }

  SyncMetaRow copyWith({
    int? id,
    Value<String?> initialSyncDoneUserId = const Value.absent(),
  }) => SyncMetaRow(
    id: id ?? this.id,
    initialSyncDoneUserId: initialSyncDoneUserId.present
        ? initialSyncDoneUserId.value
        : this.initialSyncDoneUserId,
  );
  SyncMetaRow copyWithCompanion(SyncMetaCompanion data) {
    return SyncMetaRow(
      id: data.id.present ? data.id.value : this.id,
      initialSyncDoneUserId: data.initialSyncDoneUserId.present
          ? data.initialSyncDoneUserId.value
          : this.initialSyncDoneUserId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaRow(')
          ..write('id: $id, ')
          ..write('initialSyncDoneUserId: $initialSyncDoneUserId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, initialSyncDoneUserId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetaRow &&
          other.id == this.id &&
          other.initialSyncDoneUserId == this.initialSyncDoneUserId);
}

class SyncMetaCompanion extends UpdateCompanion<SyncMetaRow> {
  final Value<int> id;
  final Value<String?> initialSyncDoneUserId;
  const SyncMetaCompanion({
    this.id = const Value.absent(),
    this.initialSyncDoneUserId = const Value.absent(),
  });
  SyncMetaCompanion.insert({
    this.id = const Value.absent(),
    this.initialSyncDoneUserId = const Value.absent(),
  });
  static Insertable<SyncMetaRow> custom({
    Expression<int>? id,
    Expression<String>? initialSyncDoneUserId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (initialSyncDoneUserId != null)
        'initial_sync_done_user_id': initialSyncDoneUserId,
    });
  }

  SyncMetaCompanion copyWith({
    Value<int>? id,
    Value<String?>? initialSyncDoneUserId,
  }) {
    return SyncMetaCompanion(
      id: id ?? this.id,
      initialSyncDoneUserId:
          initialSyncDoneUserId ?? this.initialSyncDoneUserId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (initialSyncDoneUserId.present) {
      map['initial_sync_done_user_id'] = Variable<String>(
        initialSyncDoneUserId.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaCompanion(')
          ..write('id: $id, ')
          ..write('initialSyncDoneUserId: $initialSyncDoneUserId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $LocalSettingsTable localSettings = $LocalSettingsTable(this);
  late final $UserSettingsTableTable userSettingsTable =
      $UserSettingsTableTable(this);
  late final $OutboxEntriesTable outboxEntries = $OutboxEntriesTable(this);
  late final $SyncCursorsTable syncCursors = $SyncCursorsTable(this);
  late final $SyncMetaTable syncMeta = $SyncMetaTable(this);
  late final CategoryDao categoryDao = CategoryDao(this as AppDatabase);
  late final TaskDao taskDao = TaskDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  late final UserSettingsDao userSettingsDao = UserSettingsDao(
    this as AppDatabase,
  );
  late final OutboxDao outboxDao = OutboxDao(this as AppDatabase);
  late final SyncCursorDao syncCursorDao = SyncCursorDao(this as AppDatabase);
  late final SyncMetaDao syncMetaDao = SyncMetaDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    tasks,
    localSettings,
    userSettingsTable,
    outboxEntries,
    syncCursors,
    syncMeta,
  ];
}

typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  required String id,
  Value<String?> userId,
  required String name,
  required String color,
  Value<String?> icon,
  Value<double> sortOrder,
  Value<bool> isArchived,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<SyncState> syncState,
  Value<DateTime> localChangedAt,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<String?> userId,
  Value<String> name,
  Value<String> color,
  Value<String?> icon,
  Value<double> sortOrder,
  Value<bool> isArchived,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<SyncState> syncState,
  Value<DateTime> localChangedAt,
  Value<int> rowid,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TasksTable, List<Task>> _tasksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tasks,
    aliasName: 'categories__id__tasks__category_id',
  );

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$UserSettingsTableTable, List<UserSettingsRow>>
  _userSettingsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.userSettingsTable,
        aliasName: 'categories__id__user_settings_table__default_category_id',
      );

  $$UserSettingsTableTableProcessedTableManager get userSettingsTableRefs {
    final manager =
        $$UserSettingsTableTableTableManager(
          $_db,
          $_db.userSettingsTable,
        ).filter(
          (f) => f.defaultCategoryId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _userSettingsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncState, SyncState, String> get syncState =>
      $composableBuilder(
        column: $table.syncState,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get localChangedAt => $composableBuilder(
    column: $table.localChangedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tasksRefs(
    Expression<bool> Function($$TasksTableFilterComposer f) f,
  ) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> userSettingsTableRefs(
    Expression<bool> Function($$UserSettingsTableTableFilterComposer f) f,
  ) {
    final $$UserSettingsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userSettingsTable,
      getReferencedColumn: (t) => t.defaultCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserSettingsTableTableFilterComposer(
            $db: $db,
            $table: $db.userSettingsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get localChangedAt => $composableBuilder(
    column: $table.localChangedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<double> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncState, String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<DateTime> get localChangedAt => $composableBuilder(
    column: $table.localChangedAt,
    builder: (column) => column,
  );

  Expression<T> tasksRefs<T extends Object>(
    Expression<T> Function($$TasksTableAnnotationComposer a) f,
  ) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> userSettingsTableRefs<T extends Object>(
    Expression<T> Function($$UserSettingsTableTableAnnotationComposer a) f,
  ) {
    final $$UserSettingsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.userSettingsTable,
          getReferencedColumn: (t) => t.defaultCategoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserSettingsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.userSettingsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({bool tasksRefs, bool userSettingsTableRefs})
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<double> sortOrder = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<SyncState> syncState = const Value.absent(),
                Value<DateTime> localChangedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                userId: userId,
                name: name,
                color: color,
                icon: icon,
                sortOrder: sortOrder,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncState: syncState,
                localChangedAt: localChangedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> userId = const Value.absent(),
                required String name,
                required String color,
                Value<String?> icon = const Value.absent(),
                Value<double> sortOrder = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<SyncState> syncState = const Value.absent(),
                Value<DateTime> localChangedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                color: color,
                icon: icon,
                sortOrder: sortOrder,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncState: syncState,
                localChangedAt: localChangedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, Category>(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({tasksRefs = false, userSettingsTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (tasksRefs) db.tasks,
                    if (userSettingsTableRefs) db.userSettingsTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (tasksRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          Task
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._tasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).tasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (userSettingsTableRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          UserSettingsRow
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._userSettingsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).userSettingsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.defaultCategoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({bool tasksRefs, bool userSettingsTableRefs})
    >;
typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  required String id,
  Value<String?> userId,
  Value<String?> categoryId,
  required String title,
  Value<String?> notes,
  Value<String> checklist,
  required DateTime taskDate,
  Value<TimeMode> timeMode,
  Value<String?> startTime,
  Value<String?> endTime,
  Value<TaskStatus> status,
  Value<DateTime?> completedAt,
  Value<double> sortOrder,
  Value<String?> recurrenceRule,
  Value<String?> recurrenceParentId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<SyncState> syncState,
  Value<DateTime> localChangedAt,
  Value<int> rowid,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<String> id,
  Value<String?> userId,
  Value<String?> categoryId,
  Value<String> title,
  Value<String?> notes,
  Value<String> checklist,
  Value<DateTime> taskDate,
  Value<TimeMode> timeMode,
  Value<String?> startTime,
  Value<String?> endTime,
  Value<TaskStatus> status,
  Value<DateTime?> completedAt,
  Value<double> sortOrder,
  Value<String?> recurrenceRule,
  Value<String?> recurrenceParentId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<SyncState> syncState,
  Value<DateTime> localChangedAt,
  Value<int> rowid,
});

final class $$TasksTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTable, Task> {
  $$TasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('tasks__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checklist => $composableBuilder(
    column: $table.checklist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get taskDate => $composableBuilder(
    column: $table.taskDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TimeMode, TimeMode, String> get timeMode =>
      $composableBuilder(
        column: $table.timeMode,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TaskStatus, TaskStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurrenceRule => $composableBuilder(
    column: $table.recurrenceRule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurrenceParentId => $composableBuilder(
    column: $table.recurrenceParentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncState, SyncState, String> get syncState =>
      $composableBuilder(
        column: $table.syncState,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get localChangedAt => $composableBuilder(
    column: $table.localChangedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checklist => $composableBuilder(
    column: $table.checklist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get taskDate => $composableBuilder(
    column: $table.taskDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeMode => $composableBuilder(
    column: $table.timeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrenceRule => $composableBuilder(
    column: $table.recurrenceRule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrenceParentId => $composableBuilder(
    column: $table.recurrenceParentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get localChangedAt => $composableBuilder(
    column: $table.localChangedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get checklist =>
      $composableBuilder(column: $table.checklist, builder: (column) => column);

  GeneratedColumn<DateTime> get taskDate =>
      $composableBuilder(column: $table.taskDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TimeMode, String> get timeMode =>
      $composableBuilder(column: $table.timeMode, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TaskStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get recurrenceRule => $composableBuilder(
    column: $table.recurrenceRule,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recurrenceParentId => $composableBuilder(
    column: $table.recurrenceParentId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncState, String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<DateTime> get localChangedAt => $composableBuilder(
    column: $table.localChangedAt,
    builder: (column) => column,
  );

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          Task,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (Task, $$TasksTableReferences),
          Task,
          PrefetchHooks Function({bool categoryId})
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> checklist = const Value.absent(),
                Value<DateTime> taskDate = const Value.absent(),
                Value<TimeMode> timeMode = const Value.absent(),
                Value<String?> startTime = const Value.absent(),
                Value<String?> endTime = const Value.absent(),
                Value<TaskStatus> status = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<double> sortOrder = const Value.absent(),
                Value<String?> recurrenceRule = const Value.absent(),
                Value<String?> recurrenceParentId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<SyncState> syncState = const Value.absent(),
                Value<DateTime> localChangedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                userId: userId,
                categoryId: categoryId,
                title: title,
                notes: notes,
                checklist: checklist,
                taskDate: taskDate,
                timeMode: timeMode,
                startTime: startTime,
                endTime: endTime,
                status: status,
                completedAt: completedAt,
                sortOrder: sortOrder,
                recurrenceRule: recurrenceRule,
                recurrenceParentId: recurrenceParentId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncState: syncState,
                localChangedAt: localChangedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> userId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                required String title,
                Value<String?> notes = const Value.absent(),
                Value<String> checklist = const Value.absent(),
                required DateTime taskDate,
                Value<TimeMode> timeMode = const Value.absent(),
                Value<String?> startTime = const Value.absent(),
                Value<String?> endTime = const Value.absent(),
                Value<TaskStatus> status = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<double> sortOrder = const Value.absent(),
                Value<String?> recurrenceRule = const Value.absent(),
                Value<String?> recurrenceParentId = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<SyncState> syncState = const Value.absent(),
                Value<DateTime> localChangedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                userId: userId,
                categoryId: categoryId,
                title: title,
                notes: notes,
                checklist: checklist,
                taskDate: taskDate,
                timeMode: timeMode,
                startTime: startTime,
                endTime: endTime,
                status: status,
                completedAt: completedAt,
                sortOrder: sortOrder,
                recurrenceRule: recurrenceRule,
                recurrenceParentId: recurrenceParentId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncState: syncState,
                localChangedAt: localChangedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TasksTable, Task>(table),
                  $$TasksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$TasksTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$TasksTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      Task,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (Task, $$TasksTableReferences),
      Task,
      PrefetchHooks Function({bool categoryId})
    >;
typedef $$LocalSettingsTableCreateCompanionBuilder =
    LocalSettingsCompanion Function({
      Value<int> id,
      Value<String?> defaultCategoryId,
      Value<String?> selectedFilterCategoryId,
      Value<String?> lastSignedInUserId,
      Value<bool> useExactAlarms,
      Value<bool> notificationPermissionRequested,
    });
typedef $$LocalSettingsTableUpdateCompanionBuilder =
    LocalSettingsCompanion Function({
      Value<int> id,
      Value<String?> defaultCategoryId,
      Value<String?> selectedFilterCategoryId,
      Value<String?> lastSignedInUserId,
      Value<bool> useExactAlarms,
      Value<bool> notificationPermissionRequested,
    });

final class $$LocalSettingsTableReferences
    extends BaseReferences<_$AppDatabase, $LocalSettingsTable, LocalSetting> {
  $$LocalSettingsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriesTable _defaultCategoryIdTable(_$AppDatabase db) => db
      .categories
      .createAlias('local_settings__default_category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get defaultCategoryId {
    final $_column = $_itemColumn<String>('default_category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_defaultCategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _selectedFilterCategoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
        'local_settings__selected_filter_category_id__categories__id',
      );

  $$CategoriesTableProcessedTableManager? get selectedFilterCategoryId {
    final $_column = $_itemColumn<String>('selected_filter_category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _selectedFilterCategoryIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LocalSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalSettingsTable> {
  $$LocalSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastSignedInUserId => $composableBuilder(
    column: $table.lastSignedInUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get useExactAlarms => $composableBuilder(
    column: $table.useExactAlarms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationPermissionRequested => $composableBuilder(
    column: $table.notificationPermissionRequested,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get defaultCategoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.defaultCategoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get selectedFilterCategoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.selectedFilterCategoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocalSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalSettingsTable> {
  $$LocalSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastSignedInUserId => $composableBuilder(
    column: $table.lastSignedInUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get useExactAlarms => $composableBuilder(
    column: $table.useExactAlarms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationPermissionRequested =>
      $composableBuilder(
        column: $table.notificationPermissionRequested,
        builder: (column) => ColumnOrderings(column),
      );

  $$CategoriesTableOrderingComposer get defaultCategoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.defaultCategoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get selectedFilterCategoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.selectedFilterCategoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocalSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalSettingsTable> {
  $$LocalSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lastSignedInUserId => $composableBuilder(
    column: $table.lastSignedInUserId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get useExactAlarms => $composableBuilder(
    column: $table.useExactAlarms,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notificationPermissionRequested =>
      $composableBuilder(
        column: $table.notificationPermissionRequested,
        builder: (column) => column,
      );

  $$CategoriesTableAnnotationComposer get defaultCategoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.defaultCategoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get selectedFilterCategoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.selectedFilterCategoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocalSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalSettingsTable,
          LocalSetting,
          $$LocalSettingsTableFilterComposer,
          $$LocalSettingsTableOrderingComposer,
          $$LocalSettingsTableAnnotationComposer,
          $$LocalSettingsTableCreateCompanionBuilder,
          $$LocalSettingsTableUpdateCompanionBuilder,
          (LocalSetting, $$LocalSettingsTableReferences),
          LocalSetting,
          PrefetchHooks Function({
            bool defaultCategoryId,
            bool selectedFilterCategoryId,
          })
        > {
  $$LocalSettingsTableTableManager(_$AppDatabase db, $LocalSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> defaultCategoryId = const Value.absent(),
                Value<String?> selectedFilterCategoryId = const Value.absent(),
                Value<String?> lastSignedInUserId = const Value.absent(),
                Value<bool> useExactAlarms = const Value.absent(),
                Value<bool> notificationPermissionRequested =
                    const Value.absent(),
              }) => LocalSettingsCompanion(
                id: id,
                defaultCategoryId: defaultCategoryId,
                selectedFilterCategoryId: selectedFilterCategoryId,
                lastSignedInUserId: lastSignedInUserId,
                useExactAlarms: useExactAlarms,
                notificationPermissionRequested:
                    notificationPermissionRequested,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> defaultCategoryId = const Value.absent(),
                Value<String?> selectedFilterCategoryId = const Value.absent(),
                Value<String?> lastSignedInUserId = const Value.absent(),
                Value<bool> useExactAlarms = const Value.absent(),
                Value<bool> notificationPermissionRequested =
                    const Value.absent(),
              }) => LocalSettingsCompanion.insert(
                id: id,
                defaultCategoryId: defaultCategoryId,
                selectedFilterCategoryId: selectedFilterCategoryId,
                lastSignedInUserId: lastSignedInUserId,
                useExactAlarms: useExactAlarms,
                notificationPermissionRequested:
                    notificationPermissionRequested,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalSettingsTable, LocalSetting>(table),
                  $$LocalSettingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({defaultCategoryId = false, selectedFilterCategoryId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (defaultCategoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.defaultCategoryId,
                            referencedTable: $$LocalSettingsTableReferences
                                ._defaultCategoryIdTable(db),
                            referencedColumn: $$LocalSettingsTableReferences
                                ._defaultCategoryIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (selectedFilterCategoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.selectedFilterCategoryId,
                            referencedTable: $$LocalSettingsTableReferences
                                ._selectedFilterCategoryIdTable(db),
                            referencedColumn: $$LocalSettingsTableReferences
                                ._selectedFilterCategoryIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$LocalSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalSettingsTable,
      LocalSetting,
      $$LocalSettingsTableFilterComposer,
      $$LocalSettingsTableOrderingComposer,
      $$LocalSettingsTableAnnotationComposer,
      $$LocalSettingsTableCreateCompanionBuilder,
      $$LocalSettingsTableUpdateCompanionBuilder,
      (LocalSetting, $$LocalSettingsTableReferences),
      LocalSetting,
      PrefetchHooks Function({
        bool defaultCategoryId,
        bool selectedFilterCategoryId,
      })
    >;
typedef $$UserSettingsTableTableCreateCompanionBuilder =
    UserSettingsTableCompanion Function({
      required String userId,
      Value<bool> morningEnabled,
      Value<String> morningTime,
      Value<bool> eveningEnabled,
      Value<String> eveningTime,
      Value<String> themeMode,
      Value<int> weekStartsOn,
      Value<String?> defaultCategoryId,
      required DateTime updatedAt,
      Value<SyncState> syncState,
      Value<DateTime> localChangedAt,
      Value<int> rowid,
    });
typedef $$UserSettingsTableTableUpdateCompanionBuilder =
    UserSettingsTableCompanion Function({
      Value<String> userId,
      Value<bool> morningEnabled,
      Value<String> morningTime,
      Value<bool> eveningEnabled,
      Value<String> eveningTime,
      Value<String> themeMode,
      Value<int> weekStartsOn,
      Value<String?> defaultCategoryId,
      Value<DateTime> updatedAt,
      Value<SyncState> syncState,
      Value<DateTime> localChangedAt,
      Value<int> rowid,
    });

final class $$UserSettingsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $UserSettingsTableTable,
          UserSettingsRow
        > {
  $$UserSettingsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriesTable _defaultCategoryIdTable(_$AppDatabase db) => db
      .categories
      .createAlias('user_settings_table__default_category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get defaultCategoryId {
    final $_column = $_itemColumn<String>('default_category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_defaultCategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UserSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get morningEnabled => $composableBuilder(
    column: $table.morningEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get morningTime => $composableBuilder(
    column: $table.morningTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get eveningEnabled => $composableBuilder(
    column: $table.eveningEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eveningTime => $composableBuilder(
    column: $table.eveningTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekStartsOn => $composableBuilder(
    column: $table.weekStartsOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncState, SyncState, String> get syncState =>
      $composableBuilder(
        column: $table.syncState,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get localChangedAt => $composableBuilder(
    column: $table.localChangedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get defaultCategoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.defaultCategoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get morningEnabled => $composableBuilder(
    column: $table.morningEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get morningTime => $composableBuilder(
    column: $table.morningTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get eveningEnabled => $composableBuilder(
    column: $table.eveningEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eveningTime => $composableBuilder(
    column: $table.eveningTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekStartsOn => $composableBuilder(
    column: $table.weekStartsOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get localChangedAt => $composableBuilder(
    column: $table.localChangedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get defaultCategoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.defaultCategoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<bool> get morningEnabled => $composableBuilder(
    column: $table.morningEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get morningTime => $composableBuilder(
    column: $table.morningTime,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get eveningEnabled => $composableBuilder(
    column: $table.eveningEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get eveningTime => $composableBuilder(
    column: $table.eveningTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<int> get weekStartsOn => $composableBuilder(
    column: $table.weekStartsOn,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncState, String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<DateTime> get localChangedAt => $composableBuilder(
    column: $table.localChangedAt,
    builder: (column) => column,
  );

  $$CategoriesTableAnnotationComposer get defaultCategoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.defaultCategoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserSettingsTableTable,
          UserSettingsRow,
          $$UserSettingsTableTableFilterComposer,
          $$UserSettingsTableTableOrderingComposer,
          $$UserSettingsTableTableAnnotationComposer,
          $$UserSettingsTableTableCreateCompanionBuilder,
          $$UserSettingsTableTableUpdateCompanionBuilder,
          (UserSettingsRow, $$UserSettingsTableTableReferences),
          UserSettingsRow,
          PrefetchHooks Function({bool defaultCategoryId})
        > {
  $$UserSettingsTableTableTableManager(
    _$AppDatabase db,
    $UserSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<bool> morningEnabled = const Value.absent(),
                Value<String> morningTime = const Value.absent(),
                Value<bool> eveningEnabled = const Value.absent(),
                Value<String> eveningTime = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<int> weekStartsOn = const Value.absent(),
                Value<String?> defaultCategoryId = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<SyncState> syncState = const Value.absent(),
                Value<DateTime> localChangedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserSettingsTableCompanion(
                userId: userId,
                morningEnabled: morningEnabled,
                morningTime: morningTime,
                eveningEnabled: eveningEnabled,
                eveningTime: eveningTime,
                themeMode: themeMode,
                weekStartsOn: weekStartsOn,
                defaultCategoryId: defaultCategoryId,
                updatedAt: updatedAt,
                syncState: syncState,
                localChangedAt: localChangedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                Value<bool> morningEnabled = const Value.absent(),
                Value<String> morningTime = const Value.absent(),
                Value<bool> eveningEnabled = const Value.absent(),
                Value<String> eveningTime = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<int> weekStartsOn = const Value.absent(),
                Value<String?> defaultCategoryId = const Value.absent(),
                required DateTime updatedAt,
                Value<SyncState> syncState = const Value.absent(),
                Value<DateTime> localChangedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserSettingsTableCompanion.insert(
                userId: userId,
                morningEnabled: morningEnabled,
                morningTime: morningTime,
                eveningEnabled: eveningEnabled,
                eveningTime: eveningTime,
                themeMode: themeMode,
                weekStartsOn: weekStartsOn,
                defaultCategoryId: defaultCategoryId,
                updatedAt: updatedAt,
                syncState: syncState,
                localChangedAt: localChangedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserSettingsTableTable, UserSettingsRow>(table),
                  $$UserSettingsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({defaultCategoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (defaultCategoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.defaultCategoryId,
                        referencedTable: $$UserSettingsTableTableReferences
                            ._defaultCategoryIdTable(db),
                        referencedColumn: $$UserSettingsTableTableReferences
                            ._defaultCategoryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UserSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserSettingsTableTable,
      UserSettingsRow,
      $$UserSettingsTableTableFilterComposer,
      $$UserSettingsTableTableOrderingComposer,
      $$UserSettingsTableTableAnnotationComposer,
      $$UserSettingsTableTableCreateCompanionBuilder,
      $$UserSettingsTableTableUpdateCompanionBuilder,
      (UserSettingsRow, $$UserSettingsTableTableReferences),
      UserSettingsRow,
      PrefetchHooks Function({bool defaultCategoryId})
    >;
typedef $$OutboxEntriesTableCreateCompanionBuilder =
    OutboxEntriesCompanion Function({
      Value<int> id,
      required String targetTable,
      required String rowId,
      Value<String> op,
      required DateTime createdAt,
      Value<int> attempts,
      Value<String> status,
      Value<String?> lastError,
    });
typedef $$OutboxEntriesTableUpdateCompanionBuilder =
    OutboxEntriesCompanion Function({
      Value<int> id,
      Value<String> targetTable,
      Value<String> rowId,
      Value<String> op,
      Value<DateTime> createdAt,
      Value<int> attempts,
      Value<String> status,
      Value<String?> lastError,
    });

class $$OutboxEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get op =>
      $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$OutboxEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxEntriesTable,
          OutboxEntry,
          $$OutboxEntriesTableFilterComposer,
          $$OutboxEntriesTableOrderingComposer,
          $$OutboxEntriesTableAnnotationComposer,
          $$OutboxEntriesTableCreateCompanionBuilder,
          $$OutboxEntriesTableUpdateCompanionBuilder,
          (
            OutboxEntry,
            BaseReferences<_$AppDatabase, $OutboxEntriesTable, OutboxEntry>,
          ),
          OutboxEntry,
          PrefetchHooks Function()
        > {
  $$OutboxEntriesTableTableManager(_$AppDatabase db, $OutboxEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> targetTable = const Value.absent(),
                Value<String> rowId = const Value.absent(),
                Value<String> op = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
              }) => OutboxEntriesCompanion(
                id: id,
                targetTable: targetTable,
                rowId: rowId,
                op: op,
                createdAt: createdAt,
                attempts: attempts,
                status: status,
                lastError: lastError,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String targetTable,
                required String rowId,
                Value<String> op = const Value.absent(),
                required DateTime createdAt,
                Value<int> attempts = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
              }) => OutboxEntriesCompanion.insert(
                id: id,
                targetTable: targetTable,
                rowId: rowId,
                op: op,
                createdAt: createdAt,
                attempts: attempts,
                status: status,
                lastError: lastError,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OutboxEntriesTable, OutboxEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $OutboxEntriesTable,
                    OutboxEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxEntriesTable,
      OutboxEntry,
      $$OutboxEntriesTableFilterComposer,
      $$OutboxEntriesTableOrderingComposer,
      $$OutboxEntriesTableAnnotationComposer,
      $$OutboxEntriesTableCreateCompanionBuilder,
      $$OutboxEntriesTableUpdateCompanionBuilder,
      (
        OutboxEntry,
        BaseReferences<_$AppDatabase, $OutboxEntriesTable, OutboxEntry>,
      ),
      OutboxEntry,
      PrefetchHooks Function()
    >;
typedef $$SyncCursorsTableCreateCompanionBuilder =
    SyncCursorsCompanion Function({
      required String targetTable,
      Value<DateTime?> lastPulledAt,
      Value<int> rowid,
    });
typedef $$SyncCursorsTableUpdateCompanionBuilder =
    SyncCursorsCompanion Function({
      Value<String> targetTable,
      Value<DateTime?> lastPulledAt,
      Value<int> rowid,
    });

class $$SyncCursorsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPulledAt => $composableBuilder(
    column: $table.lastPulledAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncCursorsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPulledAt => $composableBuilder(
    column: $table.lastPulledAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncCursorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastPulledAt => $composableBuilder(
    column: $table.lastPulledAt,
    builder: (column) => column,
  );
}

class $$SyncCursorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncCursorsTable,
          SyncCursor,
          $$SyncCursorsTableFilterComposer,
          $$SyncCursorsTableOrderingComposer,
          $$SyncCursorsTableAnnotationComposer,
          $$SyncCursorsTableCreateCompanionBuilder,
          $$SyncCursorsTableUpdateCompanionBuilder,
          (
            SyncCursor,
            BaseReferences<_$AppDatabase, $SyncCursorsTable, SyncCursor>,
          ),
          SyncCursor,
          PrefetchHooks Function()
        > {
  $$SyncCursorsTableTableManager(_$AppDatabase db, $SyncCursorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncCursorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncCursorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncCursorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> targetTable = const Value.absent(),
                Value<DateTime?> lastPulledAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncCursorsCompanion(
                targetTable: targetTable,
                lastPulledAt: lastPulledAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String targetTable,
                Value<DateTime?> lastPulledAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncCursorsCompanion.insert(
                targetTable: targetTable,
                lastPulledAt: lastPulledAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncCursorsTable, SyncCursor>(table),
                  BaseReferences<_$AppDatabase, $SyncCursorsTable, SyncCursor>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncCursorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncCursorsTable,
      SyncCursor,
      $$SyncCursorsTableFilterComposer,
      $$SyncCursorsTableOrderingComposer,
      $$SyncCursorsTableAnnotationComposer,
      $$SyncCursorsTableCreateCompanionBuilder,
      $$SyncCursorsTableUpdateCompanionBuilder,
      (
        SyncCursor,
        BaseReferences<_$AppDatabase, $SyncCursorsTable, SyncCursor>,
      ),
      SyncCursor,
      PrefetchHooks Function()
    >;
typedef $$SyncMetaTableCreateCompanionBuilder = SyncMetaCompanion Function({
  Value<int> id,
  Value<String?> initialSyncDoneUserId,
});
typedef $$SyncMetaTableUpdateCompanionBuilder = SyncMetaCompanion Function({
  Value<int> id,
  Value<String?> initialSyncDoneUserId,
});

class $$SyncMetaTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get initialSyncDoneUserId => $composableBuilder(
    column: $table.initialSyncDoneUserId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get initialSyncDoneUserId => $composableBuilder(
    column: $table.initialSyncDoneUserId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get initialSyncDoneUserId => $composableBuilder(
    column: $table.initialSyncDoneUserId,
    builder: (column) => column,
  );
}

class $$SyncMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncMetaTable,
          SyncMetaRow,
          $$SyncMetaTableFilterComposer,
          $$SyncMetaTableOrderingComposer,
          $$SyncMetaTableAnnotationComposer,
          $$SyncMetaTableCreateCompanionBuilder,
          $$SyncMetaTableUpdateCompanionBuilder,
          (
            SyncMetaRow,
            BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaRow>,
          ),
          SyncMetaRow,
          PrefetchHooks Function()
        > {
  $$SyncMetaTableTableManager(_$AppDatabase db, $SyncMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> initialSyncDoneUserId = const Value.absent(),
              }) => SyncMetaCompanion(
                id: id,
                initialSyncDoneUserId: initialSyncDoneUserId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> initialSyncDoneUserId = const Value.absent(),
              }) => SyncMetaCompanion.insert(
                id: id,
                initialSyncDoneUserId: initialSyncDoneUserId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncMetaTable, SyncMetaRow>(table),
                  BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncMetaTable,
      SyncMetaRow,
      $$SyncMetaTableFilterComposer,
      $$SyncMetaTableOrderingComposer,
      $$SyncMetaTableAnnotationComposer,
      $$SyncMetaTableCreateCompanionBuilder,
      $$SyncMetaTableUpdateCompanionBuilder,
      (SyncMetaRow, BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaRow>),
      SyncMetaRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$LocalSettingsTableTableManager get localSettings =>
      $$LocalSettingsTableTableManager(_db, _db.localSettings);
  $$UserSettingsTableTableTableManager get userSettingsTable =>
      $$UserSettingsTableTableTableManager(_db, _db.userSettingsTable);
  $$OutboxEntriesTableTableManager get outboxEntries =>
      $$OutboxEntriesTableTableManager(_db, _db.outboxEntries);
  $$SyncCursorsTableTableManager get syncCursors =>
      $$SyncCursorsTableTableManager(_db, _db.syncCursors);
  $$SyncMetaTableTableManager get syncMeta =>
      $$SyncMetaTableTableManager(_db, _db.syncMeta);
}
