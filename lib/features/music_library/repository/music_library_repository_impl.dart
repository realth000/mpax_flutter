import 'package:fpdart/fpdart.dart';
import 'package:mpax_flutter/features/music_library/repository/music_library_reposiroty.dart';
import 'package:mpax_flutter/shared/models/models.dart';

/// Implementation of [MusicLibraryRepository].
final class MusicLibraryRepositoryImpl implements MusicLibraryRepository {
  @override
  Future<Either<String, List<MusicModel>>> loadDirectoryData(
      String directory) async {
    // TODO: Implement me
    throw UnimplementedError();
  }

  @override
  Future<Either<String, List<MusicModel>>> scanDirectory(
      String directory) async {
    // TODO: Implement me
    throw UnimplementedError();
  }

  @override
  Future<Option<String>> removeDirectory(String directory) {
    // TODO: Implement me
    throw UnimplementedError();
  }

  @override
  Future<Option<String>> saveDirectory(
      String directory, List<MusicModel> data) {
    // TODO: Implement me
    throw UnimplementedError();
  }
}
