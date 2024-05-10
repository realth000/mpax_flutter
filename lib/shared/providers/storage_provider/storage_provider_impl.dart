import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:mpax_flutter/instance.dart';
import 'package:mpax_flutter/shared/models/models.dart';
import 'package:mpax_flutter/shared/models/shared_models.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/dao/album.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/dao/artist.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/dao/music.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/dao/settings.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/database.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/shared_model.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/storage_provider.dart';

// Cache image thumbnail.
//import 'package:image/image.dart' as image;

/// Implementation of [StorageProvider].
final class StorageProviderImpl implements StorageProvider {
  /// Constructor.
  StorageProviderImpl(this._db, this.imageCacheDir);

  final AppDatabase _db;

  /// Path to save image cache.
  final String imageCacheDir;

  @override
  Future<void> dispose() async {
    logger.i('dispose SettingsProviderImpl');
    await _db.close();
  }

  /// Here are some heavy logic when adding a new music in database because
  /// we maintain relationships between metadata parts manually and directly
  /// save them in tables.
  ///
  /// The following relations should in consider:
  ///
  /// * `Music` and `Album`: Many to many.
  /// * `Music` and `Artist`: Many to many. We allow multiple artists exists in
  ///    a `Music` instance.
  /// * `Album` and `Artist`: Many to many. We allow multiple artists exists in
  ///    an `Album` instance.
  /// * `Music` and `Image`: One to many. We allow multiple images exists in a
  ///    `Music` instance. Though we didn't tell theirs artwork type (front
  ///    cover, back cover, disc cover ...).
  ///
  /// Many bi-directional relations between `Music`, `Album` and `Artist`.
  ///
  /// And note that we intend to force update the metadata though the music
  /// already exists in database, this make sure music metadata keep sync with
  /// file.
  ///
  /// Follow these steps:
  ///
  /// 1. Clear all existing image database record and file cache in
  ///   [metadataModel].
  /// 2. Save new read images in `Image` table and cache in file.
  /// 3. Save most music metadata in `Music` table exclude `album`, `artist`
  ///    and `albumArtist` as we do not have them now.
  /// 4. Save most album metadata in `Album` table exclude `albumArtist` as we
  ///    do not have it now.
  /// 5. Save all artist metadata in `Artist` table.
  /// 6. Fulfill album metadata: `albumArtist`.
  /// 7. Fulfill music metadata: `album`, `artist` and `albumArtist`.
  @override
  Future<MusicModel> addMusic(MetadataModel metadataModel) async {
    return _db.transaction(() async {
      logger.i('add music: ${metadataModel.filePath}');
      // final oldMusic =
      //     await MusicDao(_db).selectMusicByFilePath(metadataModel.filePath);
      // Though music already recorded, still update it because the file info
      // may changed.
      // if (oldMusic != null) {
      //   // Here we delete all existing images.
      //   for (final imagePair
      //       in oldMusic.albumCover?.values ?? const <ImageDbInfo>{}) {
      //     await ImageDao(_db).deleteImageById(imagePair.intValue);
      //     final imageFile = File('$imageCacheDir/${imagePair.stringValue}');
      //     if (imageFile.existsSync()) {
      //       await imageFile.delete();
      //     }
      //   }
      // }

      // Save images.
      // final imageDbInfoList = ImageDbInfoSet({});
      // for (final imageData in metadataModel.images ?? const <Uint8List>[]) {
      //   final fileName = uuid.v4();
      //   final fullPath = '$imageCacheDir/$fileName';

      //   // Cache full cover.
      //   // final f = await File(fullPath).create(recursive: true);
      //   // await f.writeAsBytes(imageData, flush: true);

      //   // Cache thumbnail.
      //   await (image.Command()
      //         ..decodeImage(imageData)
      //         ..copyResize(width: 60, height: 60)
      //         ..writeToFile(fullPath))
      //       .execute();
      //   final imageEntity = await ImageDao(_db)
      //       .upsertImageEx(ImageCompanion(filePath: Value(fileName)));
      // imageDbInfoList.add(ImageDbInfo(imageEntity.id, imageEntity.filePath));
      // }

      // Artists are identified by their names. No id required.
      final artistDbInfo =
          ArtistDbInfoSet(metadataModel.artist.sorted().toSet());
      final albumArtistDbInfo =
          ArtistDbInfoSet(metadataModel.albumArtist.sorted().toSet());

      var musicCompanion = MusicCompanion(
        filePath: Value(metadataModel.filePath),
        fileName: Value(metadataModel.fileName),
        sourceDir: Value(metadataModel.sourceDir),
        title: Value(metadataModel.title),
        artist: Value(artistDbInfo),
        // album: Value(metadataModel.album),
        track: Value(metadataModel.track),
        year: Value(metadataModel.year),
        genre: Value(metadataModel.genre),
        comment: Value(metadataModel.comment),
        sampleRate: Value(metadataModel.sampleRate),
        bitrate: Value(metadataModel.bitrate),
        channels: Value(metadataModel.channels),
        duration: Value(metadataModel.duration?.inMilliseconds),
        albumArtist: Value(albumArtistDbInfo),
        albumTotalTracks: Value(metadataModel.albumTotalTracks),
      );

      // Save music.
      // Update artist/album/albumArtist later.
      var musicEntity =
          await MusicDao(_db).selectMusicByFilePath(metadataModel.filePath);
      var musicId = musicEntity?.id;
      if (musicId == null) {
        // Not exists.
        musicEntity = await MusicDao(_db).insertMusicEx(musicCompanion);
        musicId = musicEntity.id;
        musicCompanion = musicCompanion.copyWith(id: Value(musicId));
      } else {
        // Update record.
        musicCompanion = musicCompanion.copyWith(id: Value(musicId));
        await MusicDao(_db).replaceMusicById(musicCompanion);
      }
      final musicDbInfo = MusicDbInfo(
        musicId,
        metadataModel.title ?? metadataModel.fileName,
      );

      // Save album.
      AlbumEntity? albumEntity;
      if (metadataModel.album != null) {
        albumEntity = await AlbumDao(_db).selectAlbumByTitleAndArtist(
          title: metadataModel.album!,
          // Remember, which locating an album, use it's artist's name.
          // In music metadata, album's related artist SHOULD use `AlbumArtist`
          // property, not `Artist` property.
          artistListString:
              StringSet(metadataModel.albumArtist.sorted().toSet()),
        );
        if (albumEntity == null) {
          // Add new album.
          albumEntity = await AlbumDao(_db).insertAlbumEx(
            AlbumCompanion(
              title: Value(metadataModel.album!),
              musicList: Value(MusicDbInfoSet({musicDbInfo})),
              artist: Value(albumArtistDbInfo),
            ),
          );
        } else {
          // Album already exists, update info.
          albumEntity.musicList.add(musicDbInfo);
          await AlbumDao(_db).updateAlbumIgnoreAbsent(albumEntity);
        }
      }
      final albumDbInfo = albumEntity != null
          ? AlbumDbInfo(albumEntity.id, albumEntity.title)
          : null;

      // Save artist.
      final artistEntityList = <ArtistEntity>[];
      for (final artist in metadataModel.artist) {
        var artistEntity = await ArtistDao(_db).selectArtistByName(artist);
        if (artistEntity == null) {
          // Add new artist.
          artistEntity = await ArtistDao(_db).insertArtistEx(
            ArtistCompanion(
              name: Value(artist),
              musicList: Value(MusicDbInfoSet({musicDbInfo})),
              albumList: albumDbInfo != null
                  ? Value(AlbumDbInfoSet({albumDbInfo}))
                  : const Value.absent(),
            ),
          );
        } else {
          // Update existing artist.
          artistEntity.musicList.add(musicDbInfo);
          if (albumDbInfo != null) {
            artistEntity.albumList.add(albumDbInfo);
          }
          await ArtistDao(_db).updateArtistIgnoreAbsent(artistEntity);
        }
        artistEntityList.add(artistEntity);
      }

      musicEntity = musicEntity!.copyWith(album: Value(albumDbInfo));
      await MusicDao(_db).updateMusicIgnoreAbsent(musicEntity);
      return MusicModel.fromEntity(musicEntity);
    });
  }

  @override
  Future<List<MusicModel>> loadMusicFromStorage(String dirPath) async {
    final musicEntities = await MusicDao(_db).selectMusicBySourceDir(dirPath);
    return musicEntities.map(MusicModel.fromEntity).toList();
  }

  @override
  Future<List<MusicModel>> loadAllMusicFromStorage() async {
    final musicEntities = await MusicDao(_db).selectAll();
    return musicEntities.map(MusicModel.fromEntity).toList();
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
