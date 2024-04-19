part of 'music_library_bloc.dart';

/// Base class of all events used in music library.
@MappableClass()
sealed class MusicLibraryEvent with MusicLibraryEventMappable {
  const MusicLibraryEvent();
}

/// Requested to load all data in music library.
@MappableClass()
final class MusicLibraryReloadRequested extends MusicLibraryEvent
    with MusicLibraryReloadRequestedMappable {
  /// Constructor.
  const MusicLibraryReloadRequested({this.scanDirectory = false});

  /// Flag indicating reload from database or disk.
  ///
  /// Reload from disk when set to `true`.
  final bool scanDirectory;
}

/// Requested to reload all music in a specified directory.
@MappableClass()
final class MusicLibraryReloadDirectoryRequested extends MusicLibraryEvent
    with MusicLibraryReloadDirectoryRequestedMappable {
  /// Constructor.
  const MusicLibraryReloadDirectoryRequested(
    this.directoryPath, {
    this.scanDirectory = false,
  });

  /// Directory path to reload.
  final String directoryPath;

  /// Flag indicating reload from database or disk.
  ///
  /// Reload from disk when set to `true`.
  final bool scanDirectory;
}

/// Requested to add a directory to music library.
@MappableClass()
final class MusicLibraryAddDirectoryRequested extends MusicLibraryEvent
    with MusicLibraryAddDirectoryRequestedMappable {
  /// Constructor.
  const MusicLibraryAddDirectoryRequested(this.directoryPath);

  /// Directory path to add to music library.
  final String directoryPath;
}

/// Requested to remove a directory from music library.
@MappableClass()
final class MusicLibraryRemoveDirectoryRequested extends MusicLibraryEvent
    with MusicLibraryRemoveDirectoryRequestedMappable {
  /// Constructor.
  const MusicLibraryRemoveDirectoryRequested(this.directoryPath);

  /// Directory path to remove from music library.
  final String directoryPath;
}
