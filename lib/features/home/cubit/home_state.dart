part of 'home_cubit.dart';

/// All tabs in root page of the app.
enum HomeTab {
  /// Show music library.
  musicLibrary,

  /// Show album series.
  album,

  /// Show artists.
  artist,

  /// Show user created playlists.
  playlist,

  /// Settings page of the app.
  settings,
}

/// State of the homepage of the app.
@MappableClass()
final class HomeState with HomeStateMappable {
  /// Constructor.
  const HomeState({this.tab = HomeTab.musicLibrary});

  /// Current tab.
  final HomeTab tab;
}

/// Bar item in app navigator.
final class NavigationBarItem {
  /// Constructor.
  const NavigationBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.targetPath,
    required this.tab,
  });

  /// Item icon.
  ///
  /// Use outline style icons.
  final Icon icon;

  /// Item icon when selected.
  ///
  /// Use normal style icons.
  final Icon selectedIcon;

  /// Name of the item.
  final String label;

  /// Screen path of the item.
  final String targetPath;

  /// Tab index.
  final HomeTab tab;
}

/// All navigation bar items.
List<NavigationBarItem> buildBarItems(BuildContext context) => [
      NavigationBarItem(
        icon: const Icon(Icons.my_library_music_outlined),
        selectedIcon: const Icon(Icons.my_library_music),
        label: context.t.navigation.musicLibrary,
        targetPath: ScreenPaths.library,
        tab: HomeTab.musicLibrary,
      ),
      NavigationBarItem(
        icon: const Icon(Icons.album_outlined),
        selectedIcon: const Icon(Icons.album),
        label: context.t.navigation.album,
        targetPath: ScreenPaths.album,
        tab: HomeTab.album,
      ),
      NavigationBarItem(
        icon: const Icon(Symbols.artist),
        selectedIcon: const Icon(Symbols.artist, fill: 1),
        label: context.t.navigation.artist,
        targetPath: ScreenPaths.artist,
        tab: HomeTab.artist,
      ),
      NavigationBarItem(
        icon: const Icon(Icons.queue_music_outlined),
        selectedIcon: const Icon(Icons.queue_music),
        label: context.t.navigation.playlist,
        targetPath: ScreenPaths.playlist,
        tab: HomeTab.playlist,
      ),
      NavigationBarItem(
        icon: const Icon(Icons.settings_outlined),
        selectedIcon: const Icon(Icons.settings),
        label: context.t.navigation.settings,
        targetPath: ScreenPaths.settings,
        tab: HomeTab.settings,
      ),
    ];
