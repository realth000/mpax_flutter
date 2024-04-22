part of 'schema.dart';

/// Settings table to save settings.
class SettingsItem extends Table {
  /// Id.
  IntColumn get id => integer().autoIncrement()();

  /// Value type.
  IntColumn get valueType => intEnum<SettingsValueType>()();

  /// Settings name.
  TextColumn get name => text().unique()();

  /// Int value
  IntColumn get intValue => integer().nullable()();

  /// String value.
  TextColumn get stringValue => text().nullable()();

  /// Bool value.
  BoolColumn get boolValue => boolean().nullable()();
}

/// Supported settings item value types.
enum SettingsValueType {
  /// Type is [String].
  string,

  /// Type is [int].
  int,

  /// Type is [bool].
  bool,
}
