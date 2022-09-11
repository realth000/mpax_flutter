import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/routes/app_pages.dart';

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
            onTap: () => Get.toNamed(MPaxRoutes.library),
          ),
          ListTile(
            leading: const Icon(Icons.music_note),
            title: Text('Music'.tr),
            onTap: () => Get.toNamed(MPaxRoutes.library),
          ),
          ListTile(
            leading: const Icon(Icons.featured_play_list),
            title: Text('Playlist'.tr),
            onTap: () => Get.toNamed(MPaxRoutes.playlist),
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: Text('Scan'.tr),
            onTap: () => Get.toNamed(MPaxRoutes.scan),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text('Settings'.tr),
            onTap: () => Get.toNamed(MPaxRoutes.settings),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text('About'.tr),
            onTap: () => Get.toNamed(MPaxRoutes.about),
          ),
        ],
      ),
    );
  }
}
