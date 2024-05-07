import 'dart:io';
import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:image/image.dart' as image;
import 'package:mpax_flutter/instance.dart';
import 'package:mpax_flutter/shared/models/models.dart';
import 'package:mpax_flutter/shared/models/shared_models.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/dao/album.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/dao/artist.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/dao/image.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/dao/music.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/dao/settings.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/database.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/storage_provider.dart';

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
      final oldMusic =
          await MusicDao(_db).selectMusicByFilePath(metadataModel.filePath);
      // Though music already recorded, still update it because the file info
      // may changed.
      if (oldMusic != null) {
        // Here we delete all existing images.
        for (final imagePair
            in oldMusic.albumCover?.values ?? const <ImageDbInfo>{}) {
          await ImageDao(_db).deleteImageById(imagePair.intValue);
          final imageFile = File('$imageCacheDir/${imagePair.stringValue}');
          if (imageFile.existsSync()) {
            await imageFile.delete();
          }
        }
      }

      // Save images.
      final imageDbInfoList = ImageDbInfoSet({});
      for (final imageData in metadataModel.images ?? const <Uint8List>[]) {
        final fileName = uuid.v4();
        final fullPath = '$imageCacheDir/$fileName';
        final f = await File(fullPath).create(recursive: true);
        await f.writeAsBytes(imageData, flush: true);

        final _ = image.Command();

        // final data2 = await File(fullPath).readAsBytes();
        // final decodeType = image.findDecoderForData(imageData);
        // print('>>> ${metadataModel.filePath} ,decodeType=$decodeType');

        // await (image.Command()
        //       ..decodeImage(imageData)
        //       ..copyResize(width: 60, height: 60)
        //       ..writeToFile(fullPath))
        //     .execute();
        final imageEntity = await ImageDao(_db)
            .upsertImageEx(ImageCompanion(filePath: Value(fileName)));
        imageDbInfoList.add(ImageDbInfo(imageEntity.id, imageEntity.filePath));
      }

      final musicCompanion = MusicCompanion(
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
        albumCover: Value(imageDbInfoList),
      );

      // Save music.
      // Update artist/album/albumArtist later.
      final musicId = await MusicDao(_db).upsertMusic(musicCompanion);
      final musicDbInfo = MusicDbInfo(
        musicId,
        metadataModel.title ?? metadataModel.fileName,
      );

      // Save album.
      AlbumEntity? albumEntity;
      // Flag indicating whether we inserted a new album record or not.
      //
      // * If we do, the album's artist info need update later.
      // * If we do not, means album info already exists, artist info will not
      //   change since we distinguish albums by album artists.
      var isNewAlbum = true;
      if (metadataModel.album != null) {
        albumEntity = await AlbumDao(_db).selectAlbumByTitleAndArtist(
          title: metadataModel.album!,
          artist: metadataModel.albumArtist,
        );
        if (albumEntity == null) {
          // Add new album.
          // Update artist later.
          albumEntity = await AlbumDao(_db).upsertAlbumEx(
            AlbumCompanion(
              title: Value(metadataModel.album!),
              musicList: Value(MusicDbInfoSet({musicDbInfo})),
            ),
          );
        } else {
          // Album already exists, all info updated,
          // no need to update artist info later.
          isNewAlbum = false;
          albumEntity.musicList.add(musicDbInfo);
          await AlbumDao(_db).upsertAlbumEx(
            albumEntity.toCompanion(false).copyWith(
                  musicList: Value(albumEntity.musicList),
                ),
          );
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
          artistEntity = await ArtistDao(_db).upsertArtistEx(
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
          await ArtistDao(_db).upsertArtistEx(
            artistEntity.toCompanion(false).copyWith(
                  musicList: Value(artistEntity.musicList),
                  albumList: albumDbInfo != null
                      ? Value(artistEntity.albumList)
                      : const Value.absent(),
                ),
          );
        }
        artistEntityList.add(artistEntity);
      }
      final artistDbInfoSet = ArtistDbInfoSet(
        artistEntityList.map((x) => ArtistDbInfo(x.id, x.name)).toSet(),
      );

      // Now fulfill music and album record.
      if (isNewAlbum && albumEntity != null) {
        await AlbumDao(_db).upsertAlbumEx(
          albumEntity.toCompanion(false).copyWith(
                artist: Value(artistDbInfoSet),
              ),
        );
      }
      final ret = await MusicDao(_db).upsertMusicEx(
        musicCompanion.copyWith(
          artist: Value(artistDbInfoSet),
          album: Value(albumDbInfo),
          albumArtist: Value(albumEntity?.artist),
        ),
      );

      return MusicModel.fromEntity(ret);
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
