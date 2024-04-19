import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../../../shared/basic_status.dart';
import '../../../shared/models/models.dart';
import '../repository/music_library_repository.dart';

part 'music_library_bloc.mapper.dart';
part 'music_library_event.dart';
part 'music_library_state.dart';

/// Emitter used in bloc.
typedef Emit = Emitter<MusicLibraryState>;

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
  MusicLibraryBloc(this._musicLibraryRepository) : super(MusicLibraryState()) {
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
    Emit emit,
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
    Emit emit,
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
    Emit emit,
  ) async {
    // TODO: Implement me
    throw UnimplementedError();
  }

  /// Remove directory from music library.
  ///
  /// * All music in the directory should be removed from music library.
  /// * Music files should not be deleted.
  FutureOr<void> _onMusicLibraryRemoveDirectoryRequested(
    MusicLibraryRemoveDirectoryRequested event,
    Emit emit,
  ) async {
    // TODO: Implement me
    throw UnimplementedError();
  }
}
