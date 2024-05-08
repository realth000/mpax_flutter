part of 'music_library_bloc.dart';

/// Music library bloc status.
typedef MusicLibraryStatus = BasicStatus;

/// Related state value used in music library bloc.
@MappableClass()
final class MusicLibraryState with MusicLibraryStateMappable {
  /// Constructor.
  MusicLibraryState({
    this.status = MusicLibraryStatus.initial,
    this.musicList = const [],
    this.musicDirectoryList = const [],
    this.currentLoadingFile,
  });

  /// Status.
  final MusicLibraryStatus status;

  /// All loaded [MusicModel].
  final List<MusicModel> musicList;

  /// All watching directory path.
  final List<String> musicDirectoryList;

  /// Record current loading music file path.
  final String? currentLoadingFile;
}
