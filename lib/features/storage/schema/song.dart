part of 'schema.dart';

@RealmModel()
class _Song {
  @PrimaryKey()
  late ObjectId id;

  ////////// File raw info //////////
  late String filePath;
  late String filename;

  ////////// Metadata //////////
  late String? title;

  /// All objects in [_Artist].
  late List<_Artist> artists;

  /// Object in [_Album].
  late _Album? album;
}

class SongKeys {
  static const _filePath = 'filePath';
  static const _title = 'title';

  static String queryFromModel(SongModel model) =>
      "${SongKeys._filePath} == '${model.filePath}'";

  static String queryFromPath(String filePath) =>
      "${SongKeys._filePath} == '$filePath'";

  static SongModel toModel(Song song) => SongModel(
        filePath: song.filePath,
        filename: song.filename,
        title: song.title,
      );

  static Song fromModel(SongModel songModel) => Song(
        ObjectId(),
        songModel.filePath,
        songModel.filename,
        title: songModel.title,
      );
}
