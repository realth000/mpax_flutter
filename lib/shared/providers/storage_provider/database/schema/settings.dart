part of 'schema.dart';

/// Settings table to save settings.
@DataClassName('SettingsEntity')
class Settings extends Table {
  /// Settings name.
  TextColumn get name => text()();

  /// Int value
  IntColumn get intValue => integer().nullable()();

  /// String value.
  TextColumn get stringValue => text().nullable()();

  /// Bool value.
  BoolColumn get boolValue => boolean().nullable()();

  @override
  Set<Column> get primaryKey => {name};
}
