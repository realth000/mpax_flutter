import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

/// Get the database storage file.
Future<File> get databaseFile async {
  final dbPath = '${(await getApplicationSupportDirectory()).path}/db/main.db';
  return File(dbPath);
}

/// Connect to database.
LazyDatabase connect() {
  return LazyDatabase(
    () async {
      if (Platform.isAndroid) {
        await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
        sqlite3.tempDirectory = (await getTemporaryDirectory()).path;
      }

      return NativeDatabase.createBackgroundConnection(await databaseFile);
    },
  );
}

/// Validate database schema?
///
/// Not used yet.
Future<void> validateDatabaseSchema(GeneratedDatabase database) async {
  if (kDebugMode) {
    await VerifySelf(database).validateDatabaseSchema();
  }
}
