import 'dart:io';

import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mpax_flutter/mobile/services/media_query_service.dart';
import 'package:mpax_flutter/models/metadata_model.dart';
import 'package:mpax_flutter/models/music_model.dart';
import 'package:mpax_flutter/models/playlist_model.dart';
import 'package:mpax_flutter/services/database_service.dart';
import 'package:mpax_flutter/services/metadata_service.dart';
import 'package:mpax_flutter/services/settings_service.dart';
import 'package:mpax_flutter/utils/util.dart';
import 'package:on_audio_query/on_audio_query.dart' as aq;
import 'package:path/path.dart' as path;
import 'package:watcher/watcher.dart';

/// Media library service, globally.
///
/// Maintains all media, and interact with database.
class MediaLibraryService extends GetxService {
  final _databaseService = Get.find<DatabaseService>();
  final _metadataService = Get.find<MetadataService>();

  /// A special playlist contains all audio content as the library.
  final List<Playlist> allPlaylist = <Playlist>[].obs;

  final allMusic = Playlist().obs;

  // Save all [AudioModel] from Android media store.
  final _allAudioModel = <aq.SongModel>[];

  /// Return the library.
  // Rx<Playlist> get allMusic => _allMusic;

  /// On use media store on Android, avoid to use tag readers for large mount of
  /// audios.
  /// If set to true, only use tag readers for extra information (e.g. bit rate)
  /// for single audio file and not use sqlite (we do not need such database).
  /// If set to true, scanning audios should only add audio files to android
  /// media store.
  /// Use as an experimental option.
  final androidOnlyUseMediaStore = true;

  /// List of [DirectoryWatcher] to watch music folders.
  ///
  /// When files in folder updates, filter music file changes and update to
  /// media library.
  final _watcherList = <DirectoryWatcher>[];

  /// Storage instance.
  final _storage = Get.find<DatabaseService>().storage;

  /// Library playlist, update when monitor folders and files changes.
  late final Playlist _libraryPlaylist;

  /// Add audio content to library.
  ///
  /// If duplicate in content path, do nothing and return false.
  Future<bool> addContent(Music music) async {
    for (final contentId in allMusic.value.musicList) {
      if (contentId == music.id) {
        return false;
      }
    }
    // TODO: Fetch music and add to music library here.
    // _allContent.value.musicList.add(playContent);
    await allMusic.value.addMusic(music);
    return true;
  }

  /// Add a list of audio content.
  ///
  /// Return counts of content added.
  Future<int> addContentList(List<Music> playContentList) async {
    /// Count.
    var added = 0;
    for (final content in playContentList) {
      if (await addContent(content)) {
        added++;
      }
    }
    return added;
  }

  /// Add a playlist in library.
  Future<void> addPlaylist(Playlist playlistModel) async {
    return;
    allPlaylist.add(playlistModel);
    await _savePlaylist(playlistModel);
  }

  /// Remove a playlist, from library and from database.
  Future<void> removePlaylist(Playlist playlistModel) async {
    return;
  }

  /// Clear the library.
  void resetLibrary() {
    // _allContent.value.contentList.clear();
    // _resetPlaylistModel(_allContent.value);
  }

  /// Regenerate the table name and clear all audio contents.
  void _resetPlaylistModel(Playlist model) {
    // model
    //   ..clearMusicList()
    //   ..tableName = _regenerateTableName();
  }

  /// Init function, run before app start.
  Future<MediaLibraryService> init() async {
    /// Load audio from database.
    if (GetPlatform.isMobile) {
      if (androidOnlyUseMediaStore) {
        final queryService = Get.find<MediaQueryService>();
        final storage = Get.find<DatabaseService>();
        await storage.writeTxn(
          () async => storage.storage.playlists.put(allMusic.value),
        );
        final headerList = queryService.audioList.getRange(0, 30);
        await allMusic.value.addMusicList(
          headerList.map((model) {
            final music = Music.fromQueryModel(model);
            storage.saveMusic(music);
            return music;
          }).toList(),
        );
        allMusic.refresh();
        return this;
      }
    }
    final allMusicFromDatabase = await _databaseService.storage.playlists
        .where()
        .nameEqualTo(libraryPlaylistName)
        .findFirst();
    if (allMusicFromDatabase != null) {
      allMusic.value = allMusicFromDatabase;
    }

    /// Start watching all music folders.
    final musicFolderList =
        Get.find<SettingsService>().getStringList('ScanTargetList') ??
            <String>[];
    for (final path in musicFolderList) {
      _watcherList.add(_watchMusicFolder(path));
    }

    final p = await _storage.playlists
        .where()
        .nameEqualTo(libraryPlaylistName)
        .findFirst();
    if (p == null) {
      _libraryPlaylist = Playlist()..name = libraryPlaylistName;
    } else {
      _libraryPlaylist = p;
    }
    return this;
  }

  /// Save playlist to database.
  ///
  /// Library should also be saved because the [playlistModel] may be a new
  /// list and updated library may not haven't saved yet.
  Future<void> savePlaylist(Playlist playlistModel) async {
    await saveMediaLibrary();
    await _savePlaylist(playlistModel);
  }

  /// Save playlist to database.
  ///
  /// Save name, table name and audio content list.
  Future<void> _savePlaylist(Playlist playlistModel) async {}

  /// Save the library to database.
  ///
  /// Call this if any playlist changes.
  Future<void> saveMediaLibrary() async {
    // _allContent.value
    //   ..name = allMediaTableName
    //   ..tableName = allMediaTableName;
    // await _savePlaylist(_allContent.value);
  }

  /// Save library and all other playlists to database.
  Future<void> saveAllPlaylist() async {
    // await saveMediaLibrary();
    // for (final playlist in allPlaylist) {
    //   await _savePlaylist(playlist);
    // }
  }

  /// Return the playlist with the given [tableName].
  @Deprecated('Use [findPlaylistById]')
  Playlist findPlaylistByTableName(String tableName) {
    // if (_allContent.value.tableName == tableName) {
    //   return _allContent.value;
    // }
    // for (final model in allPlaylist) {
    //   if (model.tableName == tableName) {
    //     return model;
    //   }
    // }
    return Playlist();
  }

  /// Find the [Playlist] with given [id].
  Future<Playlist?> findPlaylistById(int id) async =>
      _databaseService.storage.playlists.where().idEqualTo(id).findFirst();

  /// Find audio content from library (in memory) with specified file path.
  Music? findPlayContent(String contentPath) => null;

  // _allContent.value.find(contentPath);

  /// Find audio content from database (on disk) with specified file path.
  ///
  /// Not used yet.
  Future<Music?> findPlayContentFromDatabase(
    String contentPath,
    String playlistTableName,
  ) async {
    return null;
  }

  /// Add [folderPath] to monitor.
  ///
  /// After added, scan once to sync media data.
  /// TODO: Maybe should do a second diff scan because the first scan may took
  /// a long time and any update are invisible in first scan.
  Future<void> addMusicFolder(
    String folderPath, {
    bool parallel = false,
  }) async {
    late final List<Metadata> allData;
    if (!parallel) {
      final watch = Stopwatch()..start();
      allData = <Metadata>[];
      //
      final d = await Directory(folderPath).listAll();
      for (final f in d) {
        if (f.statSync().type != FileSystemEntityType.file) {
          continue;
        }
        if (path.extension(f.path) != '.mp3') {
          continue;
        }
        final data = await _metadataService.readMetadata(f.path);
        if (data == null) {
          continue;
        }
        allData.add(data);
      }
    } else {
      final watch = Stopwatch()..start();
      final d = await Directory(folderPath).listAll();
      allData = await _metadataService.readMetadataParallel(
        d
            .where(
              (entity) =>
                  entity.statSync().type == FileSystemEntityType.file &&
                  path.extension(entity.path) == '.mp3',
            )
            .map((entity) => entity.path)
            .toList(),
      );
    }

    // Save to music library playlist.
    final musicList = <Music>[];
    for (final d in allData) {
      final music =
          await Get.find<MetadataService>().fetchMusic(d.filePath, metadata: d);
      // Add to playlist.
      musicList.add(music);
    }
    // Save to database.
    await _addMusicFromMonitorFolder(musicList);
    _watcherList.add(_watchMusicFolder(folderPath));
  }

  /// Remove [folderPath] from monitoring folders.
  /// Also remove all music stored in [folderPath] from music library playlist.
  Future<void> removeMusicFolder(String folderPath) async {
    await allMusic.value.removeMusicByMusicFolder(folderPath);
    allMusic.refresh();
    _watcherList.removeWhere((watcher) {
      if (watcher.path != folderPath) {
        return false;
      }
      return true;
    });
  }

  Future<void> _addMusicFromMonitorFolder(List<Music> musicList) async {
    await allMusic.value.addMusicList(musicList);
    allMusic.refresh();
    await _storage
        .writeTxn(() async => _storage.playlists.put(_libraryPlaylist));
  }

  Future<void> _removeMusicFromMonitorFolder(Music music) async {
    await allMusic.value.removeMusic(music);
  }

  /// Make a watcher watching [path].
  DirectoryWatcher _watchMusicFolder(String path) => DirectoryWatcher(path)
    ..events.listen((event) async {
      if (_watcherList.where((e) => e.path == path).toList().isEmpty) {
        return;
      }

      if (event.type == ChangeType.ADD) {
        final data = await _metadataService.fetchMusic(event.path);
        await _addMusicFromMonitorFolder([data]);
        return;
      } else if (event.type == ChangeType.REMOVE) {
        await _removeMusicFromMonitorFolder(
          await _metadataService.fetchMusic(event.path),
        );
      }
    });
}
