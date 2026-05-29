import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DataClassName('CrushCardData')
@TableIndex(name: 'idx_crush_cards_remind_at', columns: {#remindAt})
@TableIndex(name: 'idx_crush_cards_status', columns: {#status})
class CrushCards extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().nullable()();
  RealColumn get price => real()();
  TextColumn get category => text().nullable()();
  TextColumn get imagePath => text().nullable()();
  RealColumn get daysOfWageSnapshot => real()();
  RealColumn get hoursOfWorkSnapshot => real()();
  RealColumn get pctOfMonthlyIncomeSnapshot => real().nullable()();
  TextColumn get reason => text().nullable()();
  TextColumn get mood => text().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get remindAt => dateTime().nullable()();
  IntColumn get remindCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [CrushCards])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'ngay_luong.db'));
    return NativeDatabase.createInBackground(file);
  });
}
