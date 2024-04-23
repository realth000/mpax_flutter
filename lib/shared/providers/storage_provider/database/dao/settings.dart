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

  /// Upsert.
  Future<int> upsertSettings(SettingsEntity settingsEntity) async {
    return into(settings).insertOnConflictUpdate(settingsEntity);
  }
}
