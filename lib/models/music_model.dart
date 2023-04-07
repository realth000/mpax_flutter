import 'dart:io';

import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:on_audio_query/on_audio_query.dart' as aq;
import 'package:path/path.dart' as path;

import '../mobile/services/media_query_service.dart';
import '../services/database_service.dart';
import '../services/metadata_service.dart';
import 'album_model.dart';
import 'artist_model.dart';
import 'artwork_model.dart';
import 'artwork_with_type_model.dart';
import 'metadata_model.dart';

part 'music_model.g.dart';

/// Model class for audio content.
///
/// Maintains audio info.
@Collection()
class Music {
  /// Default empty constructor.
  Music();

  /// Construct by file path.
  ///
  /// Only make [fileName] and [fileSize].
  /// Need to call [refreshMetadata] after call this.
  Music.fromPath(this.filePath) {
    fileName = path.basename(filePath);
    fileSize = File(filePath).lengthSync();
  }

  /// Construct by file system entity.
  ///
  /// Including [fileSize].
  /// Need to call [refreshMetadata] after call this.
  Music.fromEntry(FileSystemEntity file) {
    if (file.statSync().type != FileSystemEntityType.file) {
      return;
    }
    final f = File(file.path);
    filePath = f.path;
    fileName = path.basename(f.path);
    fileSize = f.lengthSync();
  }

  /// Construct from [aq.AudioModel].
  ///
  /// Only use on Android, data comes from Android MediaStore.
  /// Do NOT call [refreshMetadata] because this is a quick build.
  /// Should only load detail metadata when load to player, as always does.
  Music.fromQueryModel(aq.AudioModel audioModel) {
    // Should not be empty, maybe need a check before call this constructor.
    final f = File(audioModel.uri!);
    filePath = f.path;
    fileName = path.basename(f.path);
    fileSize = f.lengthSync();
    title = audioModel.title;

    final metadataService = Get.find<MetadataService>();
    final mediaQueryService = Get.find<MediaQueryService>();
    final storage = Get.find<DatabaseService>().storage;

    // TODO: Do this with async.
    if (audioModel.albumId != null) {
      final album = mediaQueryService.findAlbumById(audioModel.id);
      if (album != null) {
        metadataService
            .fetchAlbum(
          album.album,
          album.artist?.split(',').toList() ?? <String>[],
        )
            .then((album) {
          this.album.value = album;
        });
      }
    }
    if (audioModel.artistId != null) {
      // Why need bang after artistId?
      final artist = mediaQueryService.findArtistById(audioModel.artistId!);
      if (artist != null) {
        metadataService.fetchArtist(artist.artist).then((artist) {
          artists.add(artist);
          storage.writeTxn(() async => artists.save());
        });
      }
    }
    // TODO: Load artwork here.
    // if (audioModel.)
  }

  /// Read metadata from file.
  ///
  /// This should always called after init a [Music] to fill metadata.
  /// This function not placed in constructor because it is "async".
  Future<bool> refreshMetadata({
    String? filePath,
    bool loadImage = false,
    bool scaleImage = true,
    bool fast = true,
    Metadata? metadata,
  }) async {
    /// Get file info.
    if (filePath != null) {
      this.filePath = filePath;
      fileName = path.basename(filePath);
      fileSize = File(this.filePath).lengthSync();
    }
    final metadataService = Get.find<MetadataService>();
    final storage = Get.find<DatabaseService>().storage;

    /// Apply [metadata], if it's null, use [MetadataService.readMetadata].
    final m = metadata ??
        await metadataService.readMetadata(
          this.filePath,
          loadImage: loadImage,
          scaleImage: scaleImage,
          fast: fast,
        );
    if (m == null) {
      return false;
    }
    title = m.title ?? fileName;
    if (m.artist != null) {
      final artist = await metadataService.fetchArtist(m.artist!);
      await artist.addMusic(this);
      artists.add(artist);
    }
    lyrics = m.lyrics;
    if (m.artworkMap != null) {
      m.artworkMap!.forEach((type, artwork) async {
        // Check whether [type] already exists.
        for (var i = 0; i < artworkList.length; i++) {
          if (artworkList.elementAt(i).type == type) {
            final tmpArtwork = await metadataService.fetchArtwork(
              artwork.format,
              artwork.data,
            );
            artworkList.elementAt(i).artwork.value = tmpArtwork;
            return;
          }
        }
        // Now [type] not exists in [artworkList], add a new one.
        final tmpArtwork =
            await metadataService.fetchArtworkWithType(type, artwork);
        artworkList.add(tmpArtwork);
      });
    }
    // Get.find<DatabaseService>().musicSchema.writeTxn((isar) async {
    // });
    if (m.title != null) {
      album.value = await metadataService.fetchAlbum(
        m.title!,
        artists.map((e) => e.name).toList(),
      );
    }
    // All objects come from fetchXXX is already saved in storage.
    // So only need to save "link".
    await storage.writeTxn(() async {
      // await storage.musics.put(this);
      await artists.save();
      await artworkList.save();
      await album.save();
    });
    trackNumber = m.track;
    genre = m.genre;
    comment = m.comment;
    bitRate = m.bitrate;
    sampleRate = m.sampleRate;
    channels = m.channels;
    length = m.length;
    return true;
  }

  /// Id in database.
  Id id = Isar.autoIncrement;

  //////////////  File Properties //////////////

  /// File path of this audio.
  @Index(unique: true)
  String filePath = '';

  /// File name of this audio.
  String fileName = '';

  /// File size of this audio.
  int fileSize = -1;

  //////////////  Music metadata Properties //////////////

  /// Title name of this audio.
  String? title;

  /// Artist or singer of this audio.
  final artists = IsarLinks<Artist>();

  /// Audio lyrics.
  String? lyrics;

  /// All artworks.
  ///
  /// Isar does not support [Map].
  /// Save [ArtworkWithType] because it records [Artwork] position info.
  /// But each [ArtworkType] should be less than 2, so always check same type
  /// exists or not before add/update values.
  final artworkList = IsarLinks<ArtworkWithType>();

  //////////////  Album Properties //////////////

  /// Album of this audio.
  ///
  /// Have back link from [Album.albumMusic]
  final album = IsarLink<Album>();

  /// Track number in album of this audio.
  int? trackNumber = -1;

  /// Genre of the album.
  String? genre;

  /// Comment of this audio.
  String? comment;

  //////////////  Audio Properties //////////////

  /// Bit rate, for *.mp3, usually 128kbps/240kbps/320kbps.
  int? bitRate;

  /// Sample rate of this audio, usually 44100kHz/48000kHz.
  int? sampleRate;

  /// Channel numbers count, usually 2.
  int? channels;

  /// Audio duration in seconds..
  int? length;
}
