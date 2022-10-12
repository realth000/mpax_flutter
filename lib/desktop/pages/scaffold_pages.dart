import 'package:flutter/material.dart';

import '../../views/about_page.dart';
import '../../views/music_page.dart';
import '../../views/scan_page.dart';
import '../../views/settings_page.dart';
import 'media_library_page.dart';
import 'playlist_page/playlist_page_view.dart';

/// Pages used in desktop main page (scaffold).
class ScaffoldPages {
  /// Page count should equal to items count of navigation bar.
  final pageCount = pages.length;

  /// Pages.
  static final pages = <Widget>[
    DesktopMediaLibraryPage(),
    DesktopPlaylistPage(),
    MusicPage(),
    ScanPage().body,
    SettingsPage().body,
    AboutPage().body,
  ];
}
