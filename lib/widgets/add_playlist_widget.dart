import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'util_widgets.dart';

/// Dialog used for adding playlist, show all need to set properties of playlist
/// and ask user to setup.
///
/// Return all properties about the new playlist.
/// If is empty,
class AddPlaylistWidget extends StatelessWidget {
  /// Constructor.
  AddPlaylistWidget({super.key});

  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Form _askForm() => Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextFormField(
              autofocus: true,
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name'.tr,
                hintText: 'Input name'.tr,
              ),
              validator: (v) =>
                  v!.trim().isNotEmpty ? null : 'Name can not be empty'.tr,
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState == null ||
                          !(_formKey.currentState!).validate()) {
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
      );

  @override
  Widget build(BuildContext context) => ModalDialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            runSpacing: 10,
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
      );
}
