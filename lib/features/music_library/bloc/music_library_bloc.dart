import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mpax_flutter/features/metadata/repository/metadata_repository.dart';
import 'package:mpax_flutter/features/music_library/repository/music_library_repository.dart';
import 'package:mpax_flutter/instance.dart';
import 'package:mpax_flutter/shared/basic_status.dart';
import 'package:mpax_flutter/shared/models/models.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/storage_provider.dart';

part 'music_library_bloc.mapper.dart';
part 'music_library_event.dart';
part 'music_library_state.dart';

/// Emitter used in bloc.
typedef _Emit = Emitter<MusicLibraryState>;

/// Bloc of the music library feature.
///
/// Manage music library data.
///
/// # Scope
///
/// * Globally reachable.
/// * Should use as Singleton.
/// * Live during entire app lifetime.
final class MusicLibraryBloc
    extends Bloc<MusicLibraryEvent, MusicLibraryState> {
  /// Constructor.
  MusicLibraryBloc(
    this._musicLibraryRepository,
    this._metadataRepository,
    this._storageProvider,
  ) : super(MusicLibraryState()) {
    on<MusicLibraryReloadRequested>(
      _onMusicLibraryReloadRequested,
    );

    on<MusicLibraryReloadDirectoryRequested>(
      _onMusicLibraryReloadDirectoryRequested,
    );

    on<MusicLibraryAddDirectoryRequested>(
      _onMusicLibraryAddDirectoryRequested,
    );

    on<MusicLibraryRemoveDirectoryRequested>(
      _onMusicLibraryRemoveDirectoryRequested,
    );
  }

  /// Repository to manage the music library.
  final MusicLibraryRepository _musicLibraryRepository;

  /// Repository to access metadata in files.
  final MetadataRepository _metadataRepository;

  // TODO: Use repository?
  /// Provider to update storage when events triggered.
  final StorageProvider _storageProvider;

  /// Reload music library.
  ///
  /// # Params
  ///
  /// ## [MusicLibraryReloadRequested.scanDirectory]
  ///
  /// * Load from disk when  is true.
  /// * Load from indexed data when is false.
  FutureOr<void> _onMusicLibraryReloadRequested(
    MusicLibraryReloadRequested event,
    _Emit emit,
  ) async {
    // TODO: Implement me
    throw UnimplementedError();
  }

  /// Reload data in specified directory.
  ///
  /// # Params
  ///
  /// ## [MusicLibraryReloadDirectoryRequested.scanDirectory]
  ///
  /// * Load from disk when is true.
  /// * Load from indexed data when is false.
  FutureOr<void> _onMusicLibraryReloadDirectoryRequested(
    MusicLibraryReloadDirectoryRequested event,
    _Emit emit,
  ) async {
    // TODO: Implement me
    throw UnimplementedError();
  }

  /// Add directory to music library.
  ///
  /// * All music in the directory should be added to music library.
  /// * Trigger a scan in the directory, not loading from storage data.
  FutureOr<void> _onMusicLibraryAddDirectoryRequested(
    MusicLibraryAddDirectoryRequested event,
    _Emit emit,
  ) async {
    emit(state.copyWith(status: BasicStatus.loading));
    final dirPath = event.directoryPath;
    final data = await _metadataRepository.readMetadataFromDir(dirPath);
    switch (data) {
      case Left(value: final err):
        logger.e('failed to scan metadata in dir $dirPath: $err');
        emit(state.copyWith(status: BasicStatus.failure));
      case Right(value: final data):
        final musicData = <MusicModel>[];
        for (final d in data) {
          musicData.add(await _storageProvider.addMusic(d));
        }
        emit(
          state.copyWith(
            status: BasicStatus.success,
            musicDirectoryList: [
              ...state.musicDirectoryList,
              dirPath,
            ],
            musicList: [
              ...state.musicList,
              ...musicData,
            ],
          ),
        );
    }
  }

  /// Remove directory from music library.
  ///
  /// * All music in the directory should be removed from music library.
  /// * Music files should not be deleted.
  FutureOr<void> _onMusicLibraryRemoveDirectoryRequested(
    MusicLibraryRemoveDirectoryRequested event,
    _Emit emit,
  ) async {
    // TODO: Implement me
    throw UnimplementedError();
  }
}
