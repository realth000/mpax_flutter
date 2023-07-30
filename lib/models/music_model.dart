import 'dart:async';
import 'dart:io';

import 'package:isar/isar.dart';
import 'package:mpax_flutter/models/metadata_model.dart';
import 'package:on_audio_query/on_audio_query.dart' as aq;
import 'package:path/path.dart' as path;

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

  /// Construct from [aq.SongModel].
  ///
  /// Only use on Android, data comes from Android MediaStore.
  /// Do NOT call [refreshMetadata] because this is a quick build.
  /// Should only load detail metadata when load to player, as always does.
  Music.fromQueryModel(aq.SongModel audioModel) {
    //   // Should not be empty, maybe need a check before call this constructor.
    //   final f = File(audioModel.data);
    //   filePath = f.path;
    //   fileName = path.basename(f.path);
    //   fileSize = f.lengthSync();
    //   title = audioModel.title;
    //
    //   final metadataService = Get.find<MetadataService>();
    //   final mediaQueryService = Get.find<MediaQueryService>();
    //   final storage = Get.find<DatabaseService>().storage;
    //
    //   // TODO: Do this with async.
    //   if (audioModel.albumId != null) {
    //     final album = mediaQueryService.findAlbumById(audioModel.id);
    //     if (album != null) {
    //       metadataService.fetchAlbum(
    //         album.album,
    //         // album.artist?.map ?? <Id>[],
    //         // FIXME: Query by artist name.
    //         <Id>[],
    //       ).then((album) {
    //         this.album = album.id;
    //       });
    //     }
    //   }
    //   if (audioModel.artistId != null) {
    //     // Why need bang after artistId?
    //     final artist = mediaQueryService.findArtistById(audioModel.artistId!);
    //     if (artist != null) {
    //       metadataService.fetchArtist(artist.artist).then<void>((v) async {
    //         artistList.add(v.id);
    //       });
    //     }
    //   }
    //   // TODO: Load artwork here.
    //   // if (audioModel.)
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
    // final metadataService = Get.find<MetadataService>();
    // final storage = Get.find<DatabaseService>().storage;

    // /// Apply [metadata], if it's null, use [MetadataService.readMetadata].
    // final m = metadata ??
    //     await metadataService.readMetadata(
    //       this.filePath,
    //       loadImage: loadImage,
    //       scaleImage: scaleImage,
    //       fast: fast,
    //     );
    // if (m == null) {
    //   return false;
    // }
    // title = m.title ?? fileName;
    // if (m.artist != null) {
    //   final artist = await metadataService.fetchArtist(m.artist!);
    //   await artist.addMusic(this);
    //   artistList
    //     ..clear()
    //     ..add(artist.id);
    // }
    // lyrics = m.lyrics;
    // if (m.artworkMap != null) {
    //   m.artworkMap!.forEach((type, artwork) async {
    //     artworkList.clear();
    //     final tmpArtwork =
    //         await metadataService.fetchArtworkWithType(type, artwork);
    //     artworkList.add(tmpArtwork.id);
    //   });
    // }
    // // Get.find<DatabaseService>().musicSchema.writeTxn((isar) async {
    // // });
    // if (m.title != null) {
    //   album = (await metadataService.fetchAlbum(
    //     m.title!,
    //     artistList,
    //   ))
    //       .id;
    // }
    // // All objects come from fetchXXX is already saved in storage.
    // // So only need to save "link".
    // trackNumber = m.track;
    // genre = m.genre;
    // comment = m.comment;
    // bitRate = m.bitrate;
    // sampleRate = m.sampleRate;
    // channels = m.channels;
    // length = m.length;
    return true;
  }

  Music makeGrowable() {
    return this..artistList = artistList.toList();
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
  List<Id> artistList = <Id>[];

  /// Audio lyrics.
  String? lyrics;

  /// Front cover artwork id.
  int? artworkFrontCover;

  /// Back cover artwork id.
  int? artworkBackCover;

  /// Artist cover artwork id.
  int? artworkArtist;

  /// Disc cover artwork id.
  ///
  /// Most used.
  int? artworkDisc;

  /// Icon cover artwork id.
  int? artworkIcon;

  /// Artwork id at unknown position.
  ///
  /// Use as a default fallback image.
  int? artworkUnknown;

  //////////////  Album Properties //////////////

  /// [Album] [Id] of this audio.
  int? album;

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
