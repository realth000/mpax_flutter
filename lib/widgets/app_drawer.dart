import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';
import '../services/player_service.dart';

/// App drawer.
class MPaxDrawer extends StatelessWidget {
  /// Constructor.
  const MPaxDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 100,
              height: 100,
              child: DrawerHeader(
                child: Image.asset(
                  'assets/images/mpax_flutter_192.png',
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.library_music),
              title: Text('Library'.tr),
              selected: Get.currentRoute == MPaxRoutes.library,
              onTap: () async => Get.offAndToNamed(MPaxRoutes.library),
            ),
            ListTile(
              leading: const Icon(Icons.queue_music),
              title: Text('Playlist'.tr),
              selected: Get.currentRoute == MPaxRoutes.playlist,
              onTap: () async => Get.offAndToNamed(MPaxRoutes.playlist),
            ),
            ListTile(
              leading: const Icon(Icons.playlist_play),
              title: Text('Current Playlist'.tr),
              selected: Get.currentRoute == MPaxRoutes.playlistContent,
              onTap: () async {
                final currentPlaylistTableName =
                    Get.find<PlayerService>().currentPlaylist.tableName;
                if (currentPlaylistTableName.isEmpty) {
                  Get.snackbar(
                    'No audio playing'.tr,
                    'Choose one to play ^_^'.tr,
                  );
                  return;
                }
                await Get.offAndToNamed(
                  MPaxRoutes.playlistContent.replaceFirst(
                    ':playlist_table_name',
                    currentPlaylistTableName,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.audiotrack),
              title: Text('Music'.tr),
              onTap: () async => Get.offAndToNamed(MPaxRoutes.music),
              style: ListTileStyle.drawer,
            ),
            ListTile(
              leading: const Icon(Icons.find_in_page),
              title: Text('Scan'.tr),
              selected: Get.currentRoute == MPaxRoutes.scan,
              onTap: () async => Get.offAndToNamed(MPaxRoutes.scan),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text('Settings'.tr),
              selected: Get.currentRoute == MPaxRoutes.settings,
              onTap: () async => Get.offAndToNamed(MPaxRoutes.settings),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: Text('About'.tr),
              selected: Get.currentRoute == MPaxRoutes.about,
              onTap: () async => Get.offAndToNamed(MPaxRoutes.about),
            ),
          ],
        ),
      );
}
