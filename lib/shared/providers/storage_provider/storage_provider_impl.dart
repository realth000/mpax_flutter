import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:mpax_flutter/instance.dart';
import 'package:mpax_flutter/shared/models/models.dart';
import 'package:mpax_flutter/shared/models/shared_models.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/dao/album.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/dao/artist.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/dao/music.dart';
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
  Future<void> addMusic(MetadataModel metadataModel) async {
    var musicCompanion = MusicCompanion(
      filePath: Value(metadataModel.filePath),
      fileName: Value(metadataModel.fileName),
      sourceDir: Value(metadataModel.sourceDir),
      title: Value(metadataModel.title),
      // artist: Value(metadataModel.artist),
      // album: Value(metadataModel.album),
      track: Value(metadataModel.track),
      year: Value(metadataModel.year),
      genre: Value(metadataModel.genre),
      comment: Value(metadataModel.comment),
      sampleRate: Value(metadataModel.sampleRate),
      bitrate: Value(metadataModel.bitrate),
      channels: Value(metadataModel.channels),
      duration: Value(metadataModel.duration?.inMilliseconds),
      // albumArtist: Value(metadataModel.albumArtist),
      albumTotalTracks: Value(metadataModel.albumTotalTracks),
      // albumCover: Value(metadataModel.images),
    );

    // Save music.
    // Update artist/album/albumArtist/albumCover later.
    final musicId = await MusicDao(_db).upsertMusic(musicCompanion);
    final musicDbInfo = MusicDbInfo(
      musicId,
      metadataModel.title ?? metadataModel.fileName,
    );
    // musicCompanion =
    //     musicCompanion.copyWith(artist: Value(ArtistDbInfoSet({})));

    // Sync album.
    AlbumEntity? albumEntity;
    var isNewAlbum = true;
    if (metadataModel.album != null) {
      albumEntity = await AlbumDao(_db).selectAlbumByTitleAndArtist(
        title: metadataModel.album!,
        artist: metadataModel.albumArtist,
      );
      if (albumEntity == null) {
        // Add new album.
        // Update artist later.
        albumEntity = await AlbumDao(_db).upsertAlbum(
          AlbumCompanion(
            title: Value(metadataModel.album!),
            musicList: Value(MusicDbInfoSet({musicDbInfo})),
          ),
        );
      } else {
        // Album already exists, all info updated,
        // no need to update artist info later.
        isNewAlbum = false;
      }
    }

    // Sync artist.
    final artistEntityList = <ArtistEntity>[];
    for (final artist in metadataModel.artist) {
      var artistEntity = await ArtistDao(_db).selectArtistByName(artist);
      if (artistEntity == null) {
        // Add new artist.
        artistEntity = await ArtistDao(_db).upsertArtist(
          ArtistCompanion(
            name: Value(artist),
            musicList: Value(MusicDbInfoSet({musicDbInfo})),
          ),
        );
      } else {
        // Update existing artist.
        artistEntity.musicList.add(musicDbInfo);
        await ArtistDao(_db).upsertArtist(
          ArtistCompanion(
            id: Value(artistEntity.id),
            musicList: Value(artistEntity.musicList),
          ),
        );
      }
      artistEntityList.add(artistEntity);
    }
    final artistDbInfoSet =
        artistEntityList.map((x) => ArtistDbInfo(x.id, x.name)).toSet();

    // Now fulfill music and album record.
    if (isNewAlbum) {
      await AlbumDao(_db).upsertAlbum(
        AlbumCompanion(
          id: Value(albumEntity!.id),
          artist: Value(ArtistDbInfoSet(artistDbInfoSet)),
        ),
      );
    }
  }

  @override
  Future<List<MusicModel>> loadMusicFromDir(String dirPath) async {
    // final music =
    //     (await MusicDao(_db).selectMusicBySourceDir(dirPath)).map((x) async {
    //   final artists = await RelationshipDao(_db).selectArtistByMusic(x.id);
    //   return MusicModel(
    //     filePath: x.filePath,
    //     fileName: x.fileName,
    //     sourceDir: x.sourceDir,
    //     title: x.title,
    //   );
    // });
    return [];
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
