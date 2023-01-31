import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../mobile/components/mobile_underfoot.dart';
import '../services/search_service.dart';
import '../utils/media_loader.dart';
import '../widgets/media_list_item.dart';
import '../widgets/util_widgets.dart';

/// Search page, search audio content in playlist.
class SearchPage extends GetView<SearchService> {
  /// Constructor.
  SearchPage({required this.playlistTableName, super.key});

  /// Playlist to search, a playlist or media library.
  final String playlistTableName;

  final _includeController = TextEditingController();
  final _excludeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Widget _buildSearchContentCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TitleText(
                title: 'Search content'.tr,
                level: 0,
              ),
              const SizedBox(
                width: 10,
                height: 10,
              ),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      autofocus: true,
                      controller: _includeController,
                      decoration: InputDecoration(
                        labelText: 'Include'.tr,
                      ),
                      validator: (v) => v!.trim().isNotEmpty
                          ? null
                          : 'Include can not be empty'.tr,
                    ),
                    const SizedBox(
                      width: 10,
                      height: 10,
                    ),
                    TextFormField(
                      autofocus: true,
                      controller: _excludeController,
                      decoration: InputDecoration(
                        labelText: 'Exclude'.tr,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState == null ||
                                  !(_formKey.currentState!).validate()) {
                                return;
                              }
                              await controller.search(
                                playlistTableName,
                                _includeController.text,
                                _excludeController.text,
                              );
                              controller.showResultPage.value = true;
                            },
                            child: Text('Search'.tr),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildSearchPatternCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TitleText(
                title: 'Search pattern'.tr,
                level: 0,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 180),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 60,
                  ),
                  children: [
                    Obx(
                      () => CheckboxListTile(
                        value: controller.title.value,
                        onChanged: (v) {
                          if (v == null) {
                            return;
                          }
                          controller.title.value = v;
                        },
                        title: Text('Title'.tr),
                      ),
                    ),
                    Obx(
                      () => CheckboxListTile(
                        value: controller.artist.value,
                        onChanged: (v) {
                          if (v == null) {
                            return;
                          }
                          controller.artist.value = v;
                        },
                        title: Text('Artist'.tr),
                      ),
                    ),
                    Obx(
                      () => CheckboxListTile(
                        value: controller.albumTitle.value,
                        onChanged: (v) {
                          if (v == null) {
                            return;
                          }
                          controller.albumTitle.value = v;
                        },
                        title: Text('Album name'.tr),
                      ),
                    ),
                    Obx(
                      () => CheckboxListTile(
                        value: controller.albumArtist.value,
                        onChanged: (v) {
                          if (v == null) {
                            return;
                          }
                          controller.albumArtist.value = v;
                        },
                        title: Text('Album artist'.tr),
                      ),
                    ),
                    Obx(
                      () => CheckboxListTile(
                        value: controller.contentPath.value,
                        onChanged: (v) {
                          if (v == null) {
                            return;
                          }
                          controller.contentPath.value = v;
                        },
                        title: Text('File path'.tr),
                      ),
                    ),
                    Obx(
                      () => CheckboxListTile(
                        value: controller.contentName.value,
                        onChanged: (v) {
                          if (v == null) {
                            return;
                          }
                          controller.contentName.value = v;
                        },
                        title: Text('File name'.tr),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

//   Widget _buildSearchResultPage(BuildContext context) => Obx(
//         () => ListView.builder(
//           itemCount: controller.resultList.length,
//           itemBuilder: (context, index) => MediaItemTile(
//             controller.resultList[index],
//             controller.playlist.value,
//           ),
//         ),
//       );

  Widget _buildSearchResultPage(BuildContext context) => Obx(
        () => ListView.builder(
          itemCount: controller.resultList.length,
          itemBuilder: (context, index) => FutureBuilder(
            future: reloadContent(controller.resultList[index]),
            builder: (context, snapshot) {
              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data == null) {
                return MediaItemTile(
                    controller.resultList[index], controller.playlist.value);
              }
              return MediaItemTile(snapshot.data!, controller.playlist.value);
            },
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Search'.tr),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                controller.showResultPage.value =
                    !controller.showResultPage.value;
              },
              icon: const Icon(
                Icons.swap_horiz,
              ),
            ),
          ],
        ),
        body: Scrollbar(
          child: Obx(
            () => controller.showResultPage.value
                ? _buildSearchResultPage(context)
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildSearchContentCard(),
                          _buildSearchPatternCard(),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
        bottomNavigationBar:
            GetPlatform.isMobile ? const MobileUnderfoot() : null,
      );
}
