import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:mpax_flutter/instance.dart';
import 'package:mpax_flutter/shared/models/models.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/dao/album.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/dao/artist.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/dao/music.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/dao/relationship.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/dao/settings.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/database.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/storage_provider.dart';

/// Implementation of [StorageProvider].
final class StorageProviderImpl implements StorageProvider {
  /// Constructor.
  StorageProviderImpl(this._db);

  final AppDatabase _db;

  @override
  Future<void> dispose() async {
    logger.i('dispose SettingsProviderImpl');
    await _db.close();
  }

  @override
  Future<void> addMusic(MusicModel musicModel) async {
    // Save music.
    final musicId = await MusicDao(_db).upsertMusic(
      MusicCompanion(
        filePath: Value(musicModel.filePath),
        fileName: Value(musicModel.filename),
        title: Value(musicModel.title),
        duration: Value(musicModel.duration.inMilliseconds),
        albumArtist: Value(musicModel.albumArtist),
      ),
    );

    // Sync album.
    int? albumId;
    if (musicModel.album != null) {
      final albumModel =
          await AlbumDao(_db).selectAlbumByTitle(musicModel.album!);
      if (albumModel.isEmpty) {
        // Add new album
        albumId = await AlbumDao(_db).upsertAlbum(
          AlbumCompanion(
            title: Value(musicModel.album!),
            artist: musicModel.albumArtist != null
                ? Value(musicModel.albumArtist!)
                : const Value.absent(),
          ),
        );
      } else {
        // Album already exists.
        albumId = albumModel.first.id;
      }
      // Sync music-album
      await RelationshipDao(_db)
          .upsertMusicAlbum(musicId: musicId, albumId: albumId);
    }

    // Sync artist.
    for (final artist in musicModel.artist) {
      final int artistId;
      final artistModel = await ArtistDao(_db).selectArtistByName(artist);
      if (artistModel == null) {
        // Add new artist.
        artistId = await ArtistDao(_db).upsertArtist(
          ArtistCompanion(
            name: Value(artist),
          ),
        );
      } else {
        // Artist already exists.
        artistId = artistModel.id;
      }
      // Sync music-artist.
      await RelationshipDao(_db).upsertMusicArtist(
        musicId: musicId,
        artistId: artistId,
      );

      // Sync artist-album.
      if (albumId != null) {
        await RelationshipDao(_db)
            .upsertArtistAlbum(artistId: artistId, albumId: albumId);
      }
    }
  }

  @override
  Future<void> deleteMusic(MusicModel musicModel) {
    // TODO: implement deleteMusic
    throw UnimplementedError();
  }

  @override
  Future<MusicModel?> findMusicByPath(String filePath) {
    // TODO: implement findMusicByPath
    throw UnimplementedError();
  }

  @override
  Future<List<SettingsEntity>> getAllSettings() async {
    return SettingsDao(_db).selectAll();
  }

  @override
  Future<void> setSettings(SettingsModel settingsModel) async {
    final list = [
      SettingsCompanion.insert(
        name: SettingsKeys.themeMode,
        intValue: Value(settingsModel.themeMode),
      ),
      SettingsCompanion.insert(
        name: SettingsKeys.accentColor,
        intValue: Value(settingsModel.accentColor),
      ),
      SettingsCompanion.insert(
        name: SettingsKeys.locale,
        stringValue: Value(settingsModel.locale),
      ),
    ];
    await SettingsDao(_db).upsertManySettings(list);
  }

  @override
  Future<int?> getThemeMode() async {
    final entity = await SettingsDao(_db).selectSettingsByName(
      SettingsKeys.themeMode,
    );
    return entity?.intValue;
  }

  @override
  Future<void> setThemeMode(int themeMode) async {
    await SettingsDao(_db).upsertSettings(
      SettingsCompanion(
        name: const Value(SettingsKeys.themeMode),
        intValue: Value(themeMode),
      ),
    );
  }

  @override
  Future<int?> getAccentColor() async {
    final entity = await SettingsDao(_db).selectSettingsByName(
      SettingsKeys.accentColor,
    );
    return entity?.intValue;
  }

  @override
  Future<void> setAccentColor(Color color) async {
    await SettingsDao(_db).upsertSettings(
      SettingsCompanion(
        name: const Value(SettingsKeys.accentColor),
        intValue: Value(color.value),
      ),
    );
  }

  @override
  Future<void> clearAccentColor() async {
    await SettingsDao(_db).upsertSettings(
      const SettingsCompanion(
        name: Value(SettingsKeys.accentColor),
        intValue: Value(null),
      ),
    );
  }

  @override
  Future<String?> getLocale() async {
    final entity = await SettingsDao(_db).selectSettingsByName(
      SettingsKeys.locale,
    );
    return entity?.stringValue;
  }

  @override
  Future<void> setLocale(String locale) async {
    await SettingsDao(_db).upsertSettings(
      SettingsCompanion(
        name: const Value(SettingsKeys.locale),
        stringValue: Value(locale),
      ),
    );
  }

  @override
  Future<int?> getLoglevel() async {
    final entity = await SettingsDao(_db).selectSettingsByName(
      SettingsKeys.loglevel,
    );
    return entity?.intValue;
  }

  @override
  Future<void> setLoglevel(int loglevel) async {
    await SettingsDao(_db).upsertSettings(
      SettingsCompanion(
        name: const Value(SettingsKeys.loglevel),
        intValue: Value(loglevel),
      ),
    );
  }
}
