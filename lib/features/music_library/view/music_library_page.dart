import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../i18n/strings.g.dart';
import '../../../instance.dart';
import '../bloc/music_library_bloc.dart';

/// Music library UI page.
final class MusicLibraryPage extends StatefulWidget {
  /// Constructor.
  const MusicLibraryPage({super.key});

  @override
  State<MusicLibraryPage> createState() => _MusicLibraryPageState();
}

final class _MusicLibraryPageState extends State<MusicLibraryPage> {
  @override
  Widget build(BuildContext context) {
    final tr = context.t.libraryPage;
    return BlocProvider(
      create: (_) => MusicLibraryBloc(sl(), sl()),
      child: BlocBuilder<MusicLibraryBloc, MusicLibraryState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(tr.title),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_outlined),
                  onPressed: () async {
                    final pickResult =
                        await FilePicker.platform.getDirectoryPath();
                    if (pickResult == null || !context.mounted) {
                      return;
                    }
                    context
                        .read<MusicLibraryBloc>()
                        .add(MusicLibraryAddDirectoryRequested(pickResult));
                  },
                ),
              ],
            ),
            body: const SizedBox(),
          );
        },
      ),
    );
  }
}
