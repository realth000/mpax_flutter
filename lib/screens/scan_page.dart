import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpax_flutter/provider/settings_provider.dart';
import 'package:mpax_flutter/widgets/section_card.dart';

enum _FolderMenuActions {
  openFolder,
  copyPath,
  delete,
}

class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({super.key});

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage> {
  @override
  Widget build(BuildContext context) {
    final list = ref.watch(settingsProvider).scanDirectoryList;

    final scanTargets = <Widget>[];
    for (final dir in list) {
      scanTargets.add(Section(
        dir,
        leading: const Icon(Icons.folder),
        trailing: PopupMenuButton(
          itemBuilder: (context) => <PopupMenuItem<_FolderMenuActions>>[
            const PopupMenuItem(
              value: _FolderMenuActions.openFolder,
              child: Row(
                children: [
                  Icon(Icons.folder_open),
                  Text('Open folder'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: _FolderMenuActions.copyPath,
              child: Row(
                children: [
                  Icon(Icons.copy),
                  Text('Copy path'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: _FolderMenuActions.delete,
              child: Row(
                children: [
                  Icon(Icons.delete),
                  Text('Delete'),
                ],
              ),
            ),
          ],
          onSelected: (value) async {
            switch (value) {
              case _FolderMenuActions.openFolder:
                // TODO: Open folder here.
                return;
              case _FolderMenuActions.copyPath:
                await Clipboard.setData(
                  ClipboardData(
                    text: dir,
                  ),
                );
                return;
              case _FolderMenuActions.delete:
                await ref
                    .read(settingsProvider.notifier)
                    .removeScanDirectory(dir);
                return;
            }
          },
        ),
      ));
    }

    return Column(
      children: [
        SectionCard(
          'System Media Store',
          [
            Section(
              'Use system media store',
              subtitle: 'Use system media store (global and fast)',
              trailing: Checkbox(
                value: true,
                onChanged: (value) {},
              ),
            ),
            Section(
              'Update when restart',
              subtitle: 'Fetch data from media store every startup',
              trailing: Checkbox(
                value: true,
                onChanged: (value) {},
              ),
            )
          ],
        ),
        SectionCard(
          'Directories',
          scanTargets.isEmpty
              ? [
                  Center(
                    child: Text(
                      'Empty',
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.outline),
                    ),
                  )
                ]
              : scanTargets,
          trailing: IconButton(
            onPressed: () async {
              final directory = await FilePicker.platform.getDirectoryPath();
              if (directory == null ||
                  ref
                      .read(settingsProvider)
                      .scanDirectoryList
                      .contains(directory)) {
                return;
              }
              await ref
                  .read(settingsProvider.notifier)
                  .addScanDirectory(directory);
            },
            icon: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
