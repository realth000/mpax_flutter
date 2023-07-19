import 'package:get/get.dart';
import 'package:mpax_flutter/desktop/desktop_scaffold.dart';
import 'package:mpax_flutter/views/about_page.dart';
import 'package:mpax_flutter/views/current_playlist_page.dart';
import 'package:mpax_flutter/views/home_page.dart';
import 'package:mpax_flutter/views/media_library_page.dart';
import 'package:mpax_flutter/views/music_page.dart';
import 'package:mpax_flutter/views/playlist_page.dart';
import 'package:mpax_flutter/views/search_page.dart';
import 'package:mpax_flutter/views/settings_page.dart';

part 'app_routes.dart';

/// Pages used in app.
///
/// Used from Getx.
class MPaxPages {
  /// Pages count, to disable some stile lints.
  final pagesCount = mobileRoutes.length;

  /// List contains routing.
  static final List<GetPage> mobileRoutes = [
    GetPage<dynamic>(
      name: MPaxRoutes.home,
      page: () => const HomePage(),
    ),
    GetPage<dynamic>(
      name: MPaxRoutes.library,
      page: () => const MediaLibraryPage(),
    ),
    GetPage<dynamic>(
      name: MPaxRoutes.playlist,
      page: PlaylistPage.new,
    ),
    GetPage<dynamic>(
      name: MPaxRoutes.playlistContent,
      page: () {
        final playlistTableName = Get.parameters['playlist_table_name'];
        if (playlistTableName == null || playlistTableName.isEmpty) {
          return const MediaLibraryPage();
        }
        return PlaylistContentPage();
      },
    ),
    GetPage<dynamic>(
      name: MPaxRoutes.music,
      page: MusicPage.new,
    ),
    GetPage<dynamic>(
      name: MPaxRoutes.settings,
      page: () => const SettingsPage(),
    ),
    GetPage<dynamic>(
      name: MPaxRoutes.about,
      page: () => const AboutPage(),
    ),
    GetPage<dynamic>(
      name: MPaxRoutes.search,
      page: () => SearchPage(
        playlistTableName: Get.parameters['playlist_table_name']!,
      ),
    ),
  ];

  /// Routes use in desktop platforms.
  static final desktopRoutes = [
    GetPage<dynamic>(
      name: '/',
      page: MPaxScaffold.new,
    ),
  ];
}
