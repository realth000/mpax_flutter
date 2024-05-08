import 'package:fpdart/fpdart.dart';
import 'package:mpax_flutter/features/music_library/repository/music_library_repository.dart';
import 'package:mpax_flutter/shared/models/models.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/storage_provider.dart';

/// Implementation of [MusicLibraryRepository].
final class MusicLibraryRepositoryImpl implements MusicLibraryRepository {
  /// Constructor.
  MusicLibraryRepositoryImpl(this._storageProvider);

  /// Provider to update storage when events triggered.
  final StorageProvider _storageProvider;

  @override
  Future<Either<String, List<MusicModel>>> loadDirectoryFromStorage(
    String directory,
  ) async {
    // TODO: Implement me
    throw UnimplementedError();
  }

  @override
  Future<Either<String, List<MusicModel>>> loadAllDirectoryFromStorage() async {
    return Right(await _storageProvider.loadAllMusicFromStorage());
  }

  @override
  Future<Either<String, MusicModel>> saveMetadataToStorage(
    MetadataModel metadataModel,
  ) async {
    return Right(await _storageProvider.addMusic(metadataModel));
  }

  @override
  Future<Option<String>> removeDirectoryFromStorage(
    String directory,
  ) {
    // TODO: Implement me
    throw UnimplementedError();
  }
}
