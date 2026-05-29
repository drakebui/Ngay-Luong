// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CrushCardsTable extends CrushCards
    with TableInfo<$CrushCardsTable, CrushCardData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CrushCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _daysOfWageSnapshotMeta =
      const VerificationMeta('daysOfWageSnapshot');
  @override
  late final GeneratedColumn<double> daysOfWageSnapshot =
      GeneratedColumn<double>('days_of_wage_snapshot', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _hoursOfWorkSnapshotMeta =
      const VerificationMeta('hoursOfWorkSnapshot');
  @override
  late final GeneratedColumn<double> hoursOfWorkSnapshot =
      GeneratedColumn<double>('hours_of_work_snapshot', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _pctOfMonthlyIncomeSnapshotMeta =
      const VerificationMeta('pctOfMonthlyIncomeSnapshot');
  @override
  late final GeneratedColumn<double> pctOfMonthlyIncomeSnapshot =
      GeneratedColumn<double>(
          'pct_of_monthly_income_snapshot', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<String> mood = GeneratedColumn<String>(
      'mood', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _remindAtMeta =
      const VerificationMeta('remindAt');
  @override
  late final GeneratedColumn<DateTime> remindAt = GeneratedColumn<DateTime>(
      'remind_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _remindCountMeta =
      const VerificationMeta('remindCount');
  @override
  late final GeneratedColumn<int> remindCount = GeneratedColumn<int>(
      'remind_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        price,
        category,
        imagePath,
        daysOfWageSnapshot,
        hoursOfWorkSnapshot,
        pctOfMonthlyIncomeSnapshot,
        reason,
        mood,
        note,
        status,
        createdAt,
        updatedAt,
        remindAt,
        remindCount
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'crush_cards';
  @override
  VerificationContext validateIntegrity(Insertable<CrushCardData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    if (data.containsKey('days_of_wage_snapshot')) {
      context.handle(
          _daysOfWageSnapshotMeta,
          daysOfWageSnapshot.isAcceptableOrUnknown(
              data['days_of_wage_snapshot']!, _daysOfWageSnapshotMeta));
    } else if (isInserting) {
      context.missing(_daysOfWageSnapshotMeta);
    }
    if (data.containsKey('hours_of_work_snapshot')) {
      context.handle(
          _hoursOfWorkSnapshotMeta,
          hoursOfWorkSnapshot.isAcceptableOrUnknown(
              data['hours_of_work_snapshot']!, _hoursOfWorkSnapshotMeta));
    } else if (isInserting) {
      context.missing(_hoursOfWorkSnapshotMeta);
    }
    if (data.containsKey('pct_of_monthly_income_snapshot')) {
      context.handle(
          _pctOfMonthlyIncomeSnapshotMeta,
          pctOfMonthlyIncomeSnapshot.isAcceptableOrUnknown(
              data['pct_of_monthly_income_snapshot']!,
              _pctOfMonthlyIncomeSnapshotMeta));
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    }
    if (data.containsKey('mood')) {
      context.handle(
          _moodMeta, mood.isAcceptableOrUnknown(data['mood']!, _moodMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('remind_at')) {
      context.handle(_remindAtMeta,
          remindAt.isAcceptableOrUnknown(data['remind_at']!, _remindAtMeta));
    }
    if (data.containsKey('remind_count')) {
      context.handle(
          _remindCountMeta,
          remindCount.isAcceptableOrUnknown(
              data['remind_count']!, _remindCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CrushCardData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CrushCardData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path']),
      daysOfWageSnapshot: attachedDatabase.typeMapping.read(DriftSqlType.double,
          data['${effectivePrefix}days_of_wage_snapshot'])!,
      hoursOfWorkSnapshot: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}hours_of_work_snapshot'])!,
      pctOfMonthlyIncomeSnapshot: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}pct_of_monthly_income_snapshot']),
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason']),
      mood: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mood']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      remindAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}remind_at']),
      remindCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}remind_count'])!,
    );
  }

  @override
  $CrushCardsTable createAlias(String alias) {
    return $CrushCardsTable(attachedDatabase, alias);
  }
}

class CrushCardData extends DataClass implements Insertable<CrushCardData> {
  final String id;
  final String? name;
  final double price;
  final String? category;
  final String? imagePath;
  final double daysOfWageSnapshot;
  final double hoursOfWorkSnapshot;
  final double? pctOfMonthlyIncomeSnapshot;
  final String? reason;
  final String? mood;
  final String? note;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? remindAt;
  final int remindCount;
  const CrushCardData(
      {required this.id,
      this.name,
      required this.price,
      this.category,
      this.imagePath,
      required this.daysOfWageSnapshot,
      required this.hoursOfWorkSnapshot,
      this.pctOfMonthlyIncomeSnapshot,
      this.reason,
      this.mood,
      this.note,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      this.remindAt,
      required this.remindCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['days_of_wage_snapshot'] = Variable<double>(daysOfWageSnapshot);
    map['hours_of_work_snapshot'] = Variable<double>(hoursOfWorkSnapshot);
    if (!nullToAbsent || pctOfMonthlyIncomeSnapshot != null) {
      map['pct_of_monthly_income_snapshot'] =
          Variable<double>(pctOfMonthlyIncomeSnapshot);
    }
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    if (!nullToAbsent || mood != null) {
      map['mood'] = Variable<String>(mood);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || remindAt != null) {
      map['remind_at'] = Variable<DateTime>(remindAt);
    }
    map['remind_count'] = Variable<int>(remindCount);
    return map;
  }

  CrushCardsCompanion toCompanion(bool nullToAbsent) {
    return CrushCardsCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      price: Value(price),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      daysOfWageSnapshot: Value(daysOfWageSnapshot),
      hoursOfWorkSnapshot: Value(hoursOfWorkSnapshot),
      pctOfMonthlyIncomeSnapshot:
          pctOfMonthlyIncomeSnapshot == null && nullToAbsent
              ? const Value.absent()
              : Value(pctOfMonthlyIncomeSnapshot),
      reason:
          reason == null && nullToAbsent ? const Value.absent() : Value(reason),
      mood: mood == null && nullToAbsent ? const Value.absent() : Value(mood),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      remindAt: remindAt == null && nullToAbsent
          ? const Value.absent()
          : Value(remindAt),
      remindCount: Value(remindCount),
    );
  }

  factory CrushCardData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CrushCardData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      price: serializer.fromJson<double>(json['price']),
      category: serializer.fromJson<String?>(json['category']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      daysOfWageSnapshot:
          serializer.fromJson<double>(json['daysOfWageSnapshot']),
      hoursOfWorkSnapshot:
          serializer.fromJson<double>(json['hoursOfWorkSnapshot']),
      pctOfMonthlyIncomeSnapshot:
          serializer.fromJson<double?>(json['pctOfMonthlyIncomeSnapshot']),
      reason: serializer.fromJson<String?>(json['reason']),
      mood: serializer.fromJson<String?>(json['mood']),
      note: serializer.fromJson<String?>(json['note']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      remindAt: serializer.fromJson<DateTime?>(json['remindAt']),
      remindCount: serializer.fromJson<int>(json['remindCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'price': serializer.toJson<double>(price),
      'category': serializer.toJson<String?>(category),
      'imagePath': serializer.toJson<String?>(imagePath),
      'daysOfWageSnapshot': serializer.toJson<double>(daysOfWageSnapshot),
      'hoursOfWorkSnapshot': serializer.toJson<double>(hoursOfWorkSnapshot),
      'pctOfMonthlyIncomeSnapshot':
          serializer.toJson<double?>(pctOfMonthlyIncomeSnapshot),
      'reason': serializer.toJson<String?>(reason),
      'mood': serializer.toJson<String?>(mood),
      'note': serializer.toJson<String?>(note),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'remindAt': serializer.toJson<DateTime?>(remindAt),
      'remindCount': serializer.toJson<int>(remindCount),
    };
  }

  CrushCardData copyWith(
          {String? id,
          Value<String?> name = const Value.absent(),
          double? price,
          Value<String?> category = const Value.absent(),
          Value<String?> imagePath = const Value.absent(),
          double? daysOfWageSnapshot,
          double? hoursOfWorkSnapshot,
          Value<double?> pctOfMonthlyIncomeSnapshot = const Value.absent(),
          Value<String?> reason = const Value.absent(),
          Value<String?> mood = const Value.absent(),
          Value<String?> note = const Value.absent(),
          String? status,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> remindAt = const Value.absent(),
          int? remindCount}) =>
      CrushCardData(
        id: id ?? this.id,
        name: name.present ? name.value : this.name,
        price: price ?? this.price,
        category: category.present ? category.value : this.category,
        imagePath: imagePath.present ? imagePath.value : this.imagePath,
        daysOfWageSnapshot: daysOfWageSnapshot ?? this.daysOfWageSnapshot,
        hoursOfWorkSnapshot: hoursOfWorkSnapshot ?? this.hoursOfWorkSnapshot,
        pctOfMonthlyIncomeSnapshot: pctOfMonthlyIncomeSnapshot.present
            ? pctOfMonthlyIncomeSnapshot.value
            : this.pctOfMonthlyIncomeSnapshot,
        reason: reason.present ? reason.value : this.reason,
        mood: mood.present ? mood.value : this.mood,
        note: note.present ? note.value : this.note,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        remindAt: remindAt.present ? remindAt.value : this.remindAt,
        remindCount: remindCount ?? this.remindCount,
      );
  CrushCardData copyWithCompanion(CrushCardsCompanion data) {
    return CrushCardData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      price: data.price.present ? data.price.value : this.price,
      category: data.category.present ? data.category.value : this.category,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      daysOfWageSnapshot: data.daysOfWageSnapshot.present
          ? data.daysOfWageSnapshot.value
          : this.daysOfWageSnapshot,
      hoursOfWorkSnapshot: data.hoursOfWorkSnapshot.present
          ? data.hoursOfWorkSnapshot.value
          : this.hoursOfWorkSnapshot,
      pctOfMonthlyIncomeSnapshot: data.pctOfMonthlyIncomeSnapshot.present
          ? data.pctOfMonthlyIncomeSnapshot.value
          : this.pctOfMonthlyIncomeSnapshot,
      reason: data.reason.present ? data.reason.value : this.reason,
      mood: data.mood.present ? data.mood.value : this.mood,
      note: data.note.present ? data.note.value : this.note,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      remindAt: data.remindAt.present ? data.remindAt.value : this.remindAt,
      remindCount:
          data.remindCount.present ? data.remindCount.value : this.remindCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CrushCardData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('category: $category, ')
          ..write('imagePath: $imagePath, ')
          ..write('daysOfWageSnapshot: $daysOfWageSnapshot, ')
          ..write('hoursOfWorkSnapshot: $hoursOfWorkSnapshot, ')
          ..write('pctOfMonthlyIncomeSnapshot: $pctOfMonthlyIncomeSnapshot, ')
          ..write('reason: $reason, ')
          ..write('mood: $mood, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('remindAt: $remindAt, ')
          ..write('remindCount: $remindCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      price,
      category,
      imagePath,
      daysOfWageSnapshot,
      hoursOfWorkSnapshot,
      pctOfMonthlyIncomeSnapshot,
      reason,
      mood,
      note,
      status,
      createdAt,
      updatedAt,
      remindAt,
      remindCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CrushCardData &&
          other.id == this.id &&
          other.name == this.name &&
          other.price == this.price &&
          other.category == this.category &&
          other.imagePath == this.imagePath &&
          other.daysOfWageSnapshot == this.daysOfWageSnapshot &&
          other.hoursOfWorkSnapshot == this.hoursOfWorkSnapshot &&
          other.pctOfMonthlyIncomeSnapshot == this.pctOfMonthlyIncomeSnapshot &&
          other.reason == this.reason &&
          other.mood == this.mood &&
          other.note == this.note &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.remindAt == this.remindAt &&
          other.remindCount == this.remindCount);
}

class CrushCardsCompanion extends UpdateCompanion<CrushCardData> {
  final Value<String> id;
  final Value<String?> name;
  final Value<double> price;
  final Value<String?> category;
  final Value<String?> imagePath;
  final Value<double> daysOfWageSnapshot;
  final Value<double> hoursOfWorkSnapshot;
  final Value<double?> pctOfMonthlyIncomeSnapshot;
  final Value<String?> reason;
  final Value<String?> mood;
  final Value<String?> note;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> remindAt;
  final Value<int> remindCount;
  final Value<int> rowid;
  const CrushCardsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.category = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.daysOfWageSnapshot = const Value.absent(),
    this.hoursOfWorkSnapshot = const Value.absent(),
    this.pctOfMonthlyIncomeSnapshot = const Value.absent(),
    this.reason = const Value.absent(),
    this.mood = const Value.absent(),
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.remindAt = const Value.absent(),
    this.remindCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CrushCardsCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    required double price,
    this.category = const Value.absent(),
    this.imagePath = const Value.absent(),
    required double daysOfWageSnapshot,
    required double hoursOfWorkSnapshot,
    this.pctOfMonthlyIncomeSnapshot = const Value.absent(),
    this.reason = const Value.absent(),
    this.mood = const Value.absent(),
    this.note = const Value.absent(),
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.remindAt = const Value.absent(),
    this.remindCount = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        price = Value(price),
        daysOfWageSnapshot = Value(daysOfWageSnapshot),
        hoursOfWorkSnapshot = Value(hoursOfWorkSnapshot),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<CrushCardData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? price,
    Expression<String>? category,
    Expression<String>? imagePath,
    Expression<double>? daysOfWageSnapshot,
    Expression<double>? hoursOfWorkSnapshot,
    Expression<double>? pctOfMonthlyIncomeSnapshot,
    Expression<String>? reason,
    Expression<String>? mood,
    Expression<String>? note,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? remindAt,
    Expression<int>? remindCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (category != null) 'category': category,
      if (imagePath != null) 'image_path': imagePath,
      if (daysOfWageSnapshot != null)
        'days_of_wage_snapshot': daysOfWageSnapshot,
      if (hoursOfWorkSnapshot != null)
        'hours_of_work_snapshot': hoursOfWorkSnapshot,
      if (pctOfMonthlyIncomeSnapshot != null)
        'pct_of_monthly_income_snapshot': pctOfMonthlyIncomeSnapshot,
      if (reason != null) 'reason': reason,
      if (mood != null) 'mood': mood,
      if (note != null) 'note': note,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (remindAt != null) 'remind_at': remindAt,
      if (remindCount != null) 'remind_count': remindCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CrushCardsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? name,
      Value<double>? price,
      Value<String?>? category,
      Value<String?>? imagePath,
      Value<double>? daysOfWageSnapshot,
      Value<double>? hoursOfWorkSnapshot,
      Value<double?>? pctOfMonthlyIncomeSnapshot,
      Value<String?>? reason,
      Value<String?>? mood,
      Value<String?>? note,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? remindAt,
      Value<int>? remindCount,
      Value<int>? rowid}) {
    return CrushCardsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      daysOfWageSnapshot: daysOfWageSnapshot ?? this.daysOfWageSnapshot,
      hoursOfWorkSnapshot: hoursOfWorkSnapshot ?? this.hoursOfWorkSnapshot,
      pctOfMonthlyIncomeSnapshot:
          pctOfMonthlyIncomeSnapshot ?? this.pctOfMonthlyIncomeSnapshot,
      reason: reason ?? this.reason,
      mood: mood ?? this.mood,
      note: note ?? this.note,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      remindAt: remindAt ?? this.remindAt,
      remindCount: remindCount ?? this.remindCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (daysOfWageSnapshot.present) {
      map['days_of_wage_snapshot'] = Variable<double>(daysOfWageSnapshot.value);
    }
    if (hoursOfWorkSnapshot.present) {
      map['hours_of_work_snapshot'] =
          Variable<double>(hoursOfWorkSnapshot.value);
    }
    if (pctOfMonthlyIncomeSnapshot.present) {
      map['pct_of_monthly_income_snapshot'] =
          Variable<double>(pctOfMonthlyIncomeSnapshot.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (mood.present) {
      map['mood'] = Variable<String>(mood.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (remindAt.present) {
      map['remind_at'] = Variable<DateTime>(remindAt.value);
    }
    if (remindCount.present) {
      map['remind_count'] = Variable<int>(remindCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CrushCardsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('category: $category, ')
          ..write('imagePath: $imagePath, ')
          ..write('daysOfWageSnapshot: $daysOfWageSnapshot, ')
          ..write('hoursOfWorkSnapshot: $hoursOfWorkSnapshot, ')
          ..write('pctOfMonthlyIncomeSnapshot: $pctOfMonthlyIncomeSnapshot, ')
          ..write('reason: $reason, ')
          ..write('mood: $mood, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('remindAt: $remindAt, ')
          ..write('remindCount: $remindCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CrushCardsTable crushCards = $CrushCardsTable(this);
  late final Index idxCrushCardsRemindAt = Index('idx_crush_cards_remind_at',
      'CREATE INDEX idx_crush_cards_remind_at ON crush_cards (remind_at)');
  late final Index idxCrushCardsStatus = Index('idx_crush_cards_status',
      'CREATE INDEX idx_crush_cards_status ON crush_cards (status)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [crushCards, idxCrushCardsRemindAt, idxCrushCardsStatus];
}

typedef $$CrushCardsTableCreateCompanionBuilder = CrushCardsCompanion Function({
  required String id,
  Value<String?> name,
  required double price,
  Value<String?> category,
  Value<String?> imagePath,
  required double daysOfWageSnapshot,
  required double hoursOfWorkSnapshot,
  Value<double?> pctOfMonthlyIncomeSnapshot,
  Value<String?> reason,
  Value<String?> mood,
  Value<String?> note,
  required String status,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> remindAt,
  Value<int> remindCount,
  Value<int> rowid,
});
typedef $$CrushCardsTableUpdateCompanionBuilder = CrushCardsCompanion Function({
  Value<String> id,
  Value<String?> name,
  Value<double> price,
  Value<String?> category,
  Value<String?> imagePath,
  Value<double> daysOfWageSnapshot,
  Value<double> hoursOfWorkSnapshot,
  Value<double?> pctOfMonthlyIncomeSnapshot,
  Value<String?> reason,
  Value<String?> mood,
  Value<String?> note,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> remindAt,
  Value<int> remindCount,
  Value<int> rowid,
});

class $$CrushCardsTableFilterComposer
    extends Composer<_$AppDatabase, $CrushCardsTable> {
  $$CrushCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get daysOfWageSnapshot => $composableBuilder(
      column: $table.daysOfWageSnapshot,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get hoursOfWorkSnapshot => $composableBuilder(
      column: $table.hoursOfWorkSnapshot,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pctOfMonthlyIncomeSnapshot => $composableBuilder(
      column: $table.pctOfMonthlyIncomeSnapshot,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mood => $composableBuilder(
      column: $table.mood, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get remindAt => $composableBuilder(
      column: $table.remindAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get remindCount => $composableBuilder(
      column: $table.remindCount, builder: (column) => ColumnFilters(column));
}

class $$CrushCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CrushCardsTable> {
  $$CrushCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get daysOfWageSnapshot => $composableBuilder(
      column: $table.daysOfWageSnapshot,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get hoursOfWorkSnapshot => $composableBuilder(
      column: $table.hoursOfWorkSnapshot,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pctOfMonthlyIncomeSnapshot => $composableBuilder(
      column: $table.pctOfMonthlyIncomeSnapshot,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mood => $composableBuilder(
      column: $table.mood, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get remindAt => $composableBuilder(
      column: $table.remindAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get remindCount => $composableBuilder(
      column: $table.remindCount, builder: (column) => ColumnOrderings(column));
}

class $$CrushCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CrushCardsTable> {
  $$CrushCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<double> get daysOfWageSnapshot => $composableBuilder(
      column: $table.daysOfWageSnapshot, builder: (column) => column);

  GeneratedColumn<double> get hoursOfWorkSnapshot => $composableBuilder(
      column: $table.hoursOfWorkSnapshot, builder: (column) => column);

  GeneratedColumn<double> get pctOfMonthlyIncomeSnapshot => $composableBuilder(
      column: $table.pctOfMonthlyIncomeSnapshot, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get remindAt =>
      $composableBuilder(column: $table.remindAt, builder: (column) => column);

  GeneratedColumn<int> get remindCount => $composableBuilder(
      column: $table.remindCount, builder: (column) => column);
}

class $$CrushCardsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CrushCardsTable,
    CrushCardData,
    $$CrushCardsTableFilterComposer,
    $$CrushCardsTableOrderingComposer,
    $$CrushCardsTableAnnotationComposer,
    $$CrushCardsTableCreateCompanionBuilder,
    $$CrushCardsTableUpdateCompanionBuilder,
    (
      CrushCardData,
      BaseReferences<_$AppDatabase, $CrushCardsTable, CrushCardData>
    ),
    CrushCardData,
    PrefetchHooks Function()> {
  $$CrushCardsTableTableManager(_$AppDatabase db, $CrushCardsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CrushCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CrushCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CrushCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<double> daysOfWageSnapshot = const Value.absent(),
            Value<double> hoursOfWorkSnapshot = const Value.absent(),
            Value<double?> pctOfMonthlyIncomeSnapshot = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            Value<String?> mood = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> remindAt = const Value.absent(),
            Value<int> remindCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CrushCardsCompanion(
            id: id,
            name: name,
            price: price,
            category: category,
            imagePath: imagePath,
            daysOfWageSnapshot: daysOfWageSnapshot,
            hoursOfWorkSnapshot: hoursOfWorkSnapshot,
            pctOfMonthlyIncomeSnapshot: pctOfMonthlyIncomeSnapshot,
            reason: reason,
            mood: mood,
            note: note,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            remindAt: remindAt,
            remindCount: remindCount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> name = const Value.absent(),
            required double price,
            Value<String?> category = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            required double daysOfWageSnapshot,
            required double hoursOfWorkSnapshot,
            Value<double?> pctOfMonthlyIncomeSnapshot = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            Value<String?> mood = const Value.absent(),
            Value<String?> note = const Value.absent(),
            required String status,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> remindAt = const Value.absent(),
            Value<int> remindCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CrushCardsCompanion.insert(
            id: id,
            name: name,
            price: price,
            category: category,
            imagePath: imagePath,
            daysOfWageSnapshot: daysOfWageSnapshot,
            hoursOfWorkSnapshot: hoursOfWorkSnapshot,
            pctOfMonthlyIncomeSnapshot: pctOfMonthlyIncomeSnapshot,
            reason: reason,
            mood: mood,
            note: note,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            remindAt: remindAt,
            remindCount: remindCount,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CrushCardsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CrushCardsTable,
    CrushCardData,
    $$CrushCardsTableFilterComposer,
    $$CrushCardsTableOrderingComposer,
    $$CrushCardsTableAnnotationComposer,
    $$CrushCardsTableCreateCompanionBuilder,
    $$CrushCardsTableUpdateCompanionBuilder,
    (
      CrushCardData,
      BaseReferences<_$AppDatabase, $CrushCardsTable, CrushCardData>
    ),
    CrushCardData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CrushCardsTableTableManager get crushCards =>
      $$CrushCardsTableTableManager(_db, _db.crushCards);
}
