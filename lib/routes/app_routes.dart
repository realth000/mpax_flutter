part of 'app_pages.dart';

abstract class MPaxRoutes {
  static const String home = '/home';
  static const String library = '/library';
  static const String playlist = '/playlist';

  // Seems playlist_id argument not used.
  static const String playlistContent = '/playlist/:playlist_table_name';
  static const String music = '/music';
  static const String scan = '/scan';
  static const String settings = '/settings';
  static const String about = '/about';
}
