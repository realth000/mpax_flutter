import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/routes/app_pages.dart';
import 'package:mpax_flutter/services/player_service.dart';

class MPaxDrawer extends StatelessWidget {
  const MPaxDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          SizedBox(
            width: 100.0,
            height: 100.0,
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
            onTap: () => Get.offAndToNamed(MPaxRoutes.library),
          ),
          ListTile(
            leading: const Icon(Icons.queue_music),
            title: Text('Playlist'.tr),
            selected: Get.currentRoute == MPaxRoutes.playlist,
            onTap: () => Get.offAndToNamed(MPaxRoutes.playlist),
          ),
          ListTile(
            leading: const Icon(Icons.playlist_play),
            title: Text('Current Playlist'.tr),
            selected: Get.currentRoute == MPaxRoutes.playlistContent,
            onTap: () {
              final currentPlaylistTableName =
                  Get.find<PlayerService>().currentPlaylist.tableName;
              if (currentPlaylistTableName.isEmpty) {
                Get.snackbar(
                    'No audio playing'.tr, 'Choose one to play ^_^'.tr);
                return;
              }
              Get.offAndToNamed(MPaxRoutes.playlistContent.replaceFirst(
                  ':playlist_table_name', currentPlaylistTableName));
            },
          ),
          ListTile(
            leading: const Icon(Icons.audiotrack),
            title: Text('Music'.tr),
            selected: false,
            onTap: () => Get.offAndToNamed(MPaxRoutes.music),
            style: ListTileStyle.drawer,
          ),
          ListTile(
            leading: const Icon(Icons.find_in_page),
            title: Text('Scan'.tr),
            selected: Get.currentRoute == MPaxRoutes.scan,
            onTap: () => Get.offAndToNamed(MPaxRoutes.scan),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text('Settings'.tr),
            selected: Get.currentRoute == MPaxRoutes.settings,
            onTap: () => Get.offAndToNamed(MPaxRoutes.settings),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text('About'.tr),
            selected: Get.currentRoute == MPaxRoutes.about,
            onTap: () => Get.offAndToNamed(MPaxRoutes.about),
          ),
        ],
      ),
    );
  }
}
