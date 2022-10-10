import 'package:get/get.dart';

import '../desktop/desktop_scaffold.dart';
import '../views/about_page.dart';
import '../views/current_playlist_page.dart';
import '../views/home_page.dart';
import '../views/media_library_page.dart';
import '../views/music_page.dart';
import '../views/playlist_page.dart';
import '../views/scan_page.dart';
import '../views/search_page.dart';
import '../views/settings_page.dart';

part 'app_routes.dart';

/// Pages used in app.
///
/// Used from Getx.
class MPaxPages {
  /// Pages count, to disable some stile lints.
  final pagesCount = mobileRoutes.length;

  /// List contains routing.
  static final List<GetPage> mobileRoutes = [
    GetPage(
      name: MPaxRoutes.home,
      page: () => const HomePage(),
    ),
    GetPage(
      name: MPaxRoutes.library,
      page: () => const MediaLibraryPage(),
    ),
    GetPage(
      name: MPaxRoutes.playlist,
      page: PlaylistPage.new,
    ),
    GetPage(
      name: MPaxRoutes.playlistContent,
      page: () {
        final playlistTableName = Get.parameters['playlist_table_name'];
        if (playlistTableName == null || playlistTableName.isEmpty) {
          return const MediaLibraryPage();
        }
        return PlaylistContentPage();
      },
    ),
    GetPage(
      name: MPaxRoutes.music,
      page: MusicPage.new,
    ),
    GetPage(
      name: MPaxRoutes.scan,
      page: () => const ScanPage(),
    ),
    GetPage(
      name: MPaxRoutes.settings,
      page: () => const SettingsPage(),
    ),
    GetPage(
      name: MPaxRoutes.about,
      page: () => const AboutPage(),
    ),
    GetPage(
      name: MPaxRoutes.search,
      page: () => SearchPage(
        playlistTableName: Get.parameters['playlist_table_name']!,
      ),
    ),
  ];

  /// Routes use in desktop platforms.
  static final desktopRoutes = [
    GetPage(
      name: '/',
      page: MPaxScaffold.new,
    ),
  ];
}
