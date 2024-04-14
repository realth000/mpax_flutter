part of 'schema.dart';

@RealmModel()
class _Music {
  @PrimaryKey()
  late ObjectId id;

  ////////// File raw info //////////
  late String filePath;
  late String filename;

  ////////// Metadata //////////
  late String? title;

  /// All objects in [_Artist].
  late Set<_Artist> artists;

  /// Object in [_Album].
  late _Album? album;
}

class MusicKeys {
  static const _filePath = 'filePath';
  static const _title = 'title';

  static String queryFromModel(MusicModel model) =>
      "${MusicKeys._filePath} == '${model.filePath}'";

  static String queryFromPath(String filePath) =>
      "${MusicKeys._filePath} == '$filePath'";

  static MusicModel toModel(Music music) => MusicModel(
        filePath: music.filePath,
        filename: music.filename,
        title: music.title,
      );

  static Music fromModel(MusicModel musicModel) => Music(
        ObjectId(),
        musicModel.filePath,
        musicModel.filename,
        title: musicModel.title,
      );
}
