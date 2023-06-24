import 'package:flutter/material.dart';
import 'package:mpax_flutter/desktop/pages/media_library_page.dart';
import 'package:mpax_flutter/desktop/pages/music_page/music_page_view.dart';
import 'package:mpax_flutter/desktop/pages/playlist_page/playlist_page_view.dart';
import 'package:mpax_flutter/views/about_page.dart';
import 'package:mpax_flutter/views/settings_page.dart';

/// Pages used in desktop main page (scaffold).
class ScaffoldPages {
  /// Page count should equal to items count of navigation bar.
  final pageCount = pages.length;

  /// Pages.
  static final pages = <Widget>[
    const DesktopMediaLibraryPage(),
    DesktopPlaylistPage(),
    const DesktopMusicPage(),
    const SettingsPage().body,
    const AboutPage().body,
  ];
}
