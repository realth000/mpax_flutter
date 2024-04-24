import 'package:drift/drift.dart';

import '../database.dart';
import '../schema/schema.dart';

part 'settings.g.dart';

/// DAO of [Settings] table.
@DriftAccessor(tables: [Settings])
final class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  /// Constructor.
  SettingsDao(super.db);

  /// Select
  Future<SettingsEntity?> selectSettingsByName(String name) async {
    return (select(settings)..where((x) => x.name.equals(name)))
        .getSingleOrNull();
  }

  /// Select all
  Future<List<SettingsEntity>> selectAll() async {
    return select(settings).get();
  }

  /// Upsert.
  Future<int> upsertSettings(SettingsCompanion settingsEntity) async {
    return into(settings).insertOnConflictUpdate(settingsEntity);
  }

  /// Insert a list of settings.
  Future<void> upsertManySettings(List<SettingsCompanion> settingsList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(settings, settingsList);
    });
  }
}
