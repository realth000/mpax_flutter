part of 'app_pages.dart';

/// Routes name in app.
abstract class MPaxRoutes {
  /// Disable some style lints.
  static const routesCount = 8;

  /// Home page route name.
  static const String home = '/home';

  /// Library page route name.
  static const String library = '/library';

  /// Playlist page route name.
  static const String playlist = '/playlist';

  /// Playlist content page route name, if argument {playlist_table_name} not
  /// provided, go to [library] page.
  static const String playlistContent = '/playlist/:playlist_table_name';

  /// Music page route name.
  static const String music = '/music';

  /// Scan audio page route name.
  static const String scan = '/scan';

  /// Settings page route name.
  static const String settings = '/settings';

  /// About page route name.
  static const String about = '/about';

  /// Search page.
  static const String search = '/search/:playlist_table_name';
}

/// Routes use on desktop platforms.
class MPaxDesktopRoutes {
  /// Main scaffold route.
  static const String root = '/';
}
