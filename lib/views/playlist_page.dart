import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/models/playlist.model.dart';
import 'package:mpax_flutter/services/playlist_service.dart';
import 'package:mpax_flutter/widgets/app_app_bar.dart';
import 'package:mpax_flutter/widgets/app_drawer.dart';
import 'package:mpax_flutter/widgets/app_player_widget.dart';

class _AddPlaylistWidget extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Form _askForm() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextFormField(
              autofocus: true,
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name'.tr,
                hintText: 'Input name'.tr,
                prefixIcon: const Icon(
                  Icons.featured_play_list,
                ),
              ),
              validator: (v) {
                return v!.trim().isNotEmpty ? null : 'Name can not be empty'.tr;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (!(_formKey.currentState as FormState).validate()) {
                        return;
                      }
                      Get.back(result: _nameController.text);
                    },
                    child: Text('OK'.tr),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: Get.width / 3 * 2,
        height: Get.height / 3 * 2,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: <Widget>[
              Text(
                'Add Playlist'.tr,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              _askForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaylistMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: Get.width / 3 * 2,
          maxHeight: Get.height / 3 * 2,
        ),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.playlist_add),
                  title: Text('Add audio'.tr),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.drive_file_rename_outline),
                  title: Text('Rename'.tr),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.playlist_remove),
                  title: Text('Delete'.tr),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlaylistPage extends GetView<PlaylistService> {
  const PlaylistPage({super.key});

  Future<void> _openPlaylistMenu() async {
    final result = await Get.dialog(_PlaylistMenu());
  }

  Future<void> _addPlaylist() async {
    final name = await Get.dialog(_AddPlaylistWidget());
    if (name == null) {
      return;
    }
    await controller.addPlaylist(PlaylistInfo(name, false));
  }

  Widget _getPlaylistCover(PlaylistModel model) {
    // TODO: Get first media audio cover here.
    if (model.contentList.isEmpty) {
      return const Icon(Icons.featured_play_list);
    } else {
      return const Icon(Icons.featured_play_list);
    }
  }

  ListTile _buildPlaylistItem(PlaylistModel model) {
    return ListTile(
      leading: _getPlaylistCover(model),
      title: Text(model.name),
      trailing: IconButton(
        onPressed: () async => await _openPlaylistMenu(),
        icon: const Icon(Icons.menu),
      ),
    );
  }

  List<ListTile> _buildPlaylistList() {
    List<ListTile> list = <ListTile>[];
    List<PlaylistModel> allPlaylist = controller.allPlaylist;
    for (final playlist in allPlaylist) {
      list.add(_buildPlaylistItem(playlist));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MPaxAppBar(
        title: 'Playlist'.tr,
        actions: <Widget>[
          ElevatedButton(
            onPressed: () async => await _addPlaylist(),
            child: const Icon(Icons.add),
          ),
        ],
      ),
      bottomNavigationBar: const MPaxPlayerWidget(),
      drawer: const MPaxDrawer(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: _buildPlaylistList(),
            ),
          ),
        ),
      ),
    );
  }
}
