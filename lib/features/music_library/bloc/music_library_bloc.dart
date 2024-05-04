import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:mpax_flutter/extensions/fpdart.dart';
import 'package:mpax_flutter/features/metadata/repository/metadata_repository.dart';
import 'package:mpax_flutter/features/music_library/repository/music_library_repository.dart';
import 'package:mpax_flutter/instance.dart';
import 'package:mpax_flutter/shared/basic_status.dart';
import 'package:mpax_flutter/shared/models/models.dart';

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
    emit(state.copyWith(status: BasicStatus.loading));
    final timeStart = DateTime.now();
    logger.i('start loading all music model data from storage');
    final data = await _musicLibraryRepository.loadAllDirectoryFromStorage();
    if (data.isLeft()) {
      emit(state.copyWith(status: BasicStatus.failure));
      logger.e('failed to load all directory from '
          'storage: ${data.unwrapErr()}');
      return;
    }

    final musicModelList = data.unwrap();

    final timeEnd = DateTime.now();
    logger.i('finish loading all music model data from storage '
        'in ${timeEnd.difference(timeStart)}, count=${musicModelList.length}');
    emit(
      state.copyWith(
        status: BasicStatus.success,
        musicList: musicModelList,
      ),
    );
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
    final timeStart = DateTime.now();
    emit(state.copyWith(status: BasicStatus.loading));
    final dirPath = event.directoryPath;
    final data = await _metadataRepository.readMetadataFromDir(dirPath);
    if (data.isLeft()) {
      logger.e('failed to scan metadata in dir $dirPath: ${data.unwrapErr()}');
      emit(state.copyWith(status: BasicStatus.failure));
      return;
    }

    final musicData =
        await _musicLibraryRepository.saveMetadataToStorage(data.unwrap());
    if (musicData.isLeft()) {
      logger.e('failed to save metadata to storage: ${musicData.unwrapErr()}');
      emit(state.copyWith(status: BasicStatus.failure));
      return;
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
          ...musicData.unwrap(),
        ],
      ),
    );
    final timeEnd = DateTime.now();
    logger.i('finished add directory to library '
        'in ${timeEnd.difference(timeStart)}, count=${musicData.length}');
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
