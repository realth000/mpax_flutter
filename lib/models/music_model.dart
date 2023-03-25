import 'dart:io';

import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as path;

import '../services/database_service.dart';
import '../services/metadata_service.dart';
import 'album_model.dart';
import 'artist_model.dart';
import 'artwork_model.dart';
import 'artwork_with_type_model.dart';

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

  /// Read metadata from file.
  ///
  /// This should always called after init a [Music] to fill metadata.
  /// This function not placed in constructor because it is "async".
  Future<bool> refreshMetadata({
    String? filePath,
    bool loadImage = false,
    bool scaleImage = true,
    bool fast = true,
  }) async {
    /// Get file info.
    if (filePath != null) {
      this.filePath = filePath;
      fileName = path.basename(filePath);
      fileSize = File(this.filePath).lengthSync();
    }
    final metadataService = Get.find<MetadataService>();
    final storage = Get.find<DatabaseService>().storage;
    final metadata = await metadataService.readMetadata(this.filePath);
    if (metadata == null) {
      return false;
    }
    title = metadata.title ?? fileName;
    if (metadata.artist != null) {
      final artist = await metadataService.fetchArtist(metadata.artist!);
      await artist.addMusic(this);
      artists.add(artist);
    }
    lyrics = metadata.lyrics;
    if (metadata.artworkMap != null) {
      metadata.artworkMap!.forEach((type, artwork) async {
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
        final tmpArtwork = ArtworkWithType(type)
          ..artwork.value =
              await metadataService.fetchArtwork(artwork.format, artwork.data);
        await storage.writeTxn(() async => tmpArtwork.save());
        artworkList.add(tmpArtwork);
      });
    }
    // Get.find<DatabaseService>().musicSchema.writeTxn((isar) async {
    // });
    if (metadata.title != null) {
      album.value = await metadataService.fetchAlbum(
        metadata.title!,
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
    trackNumber = metadata.track;
    genre = metadata.genre;
    comment = metadata.comment;
    bitRate = metadata.bitrate;
    sampleRate = metadata.sampleRate;
    channels = metadata.channels;
    length = metadata.length;
    return true;
  }

  /// Id in database.
  Id id = Isar.autoIncrement;

  //////////////  File Properties //////////////

  /// File path of this audio.
  @Index(unique: true)
  late final String filePath;

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
