import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpax_flutter/constants/layout.dart';
import 'package:mpax_flutter/features/music_library/bloc/music_library_bloc.dart';
import 'package:mpax_flutter/i18n/strings.g.dart';
import 'package:mpax_flutter/shared/basic_status.dart';

/// Music library UI page.
final class MusicLibraryPage extends StatefulWidget {
  /// Constructor.
  const MusicLibraryPage({super.key});

  @override
  State<MusicLibraryPage> createState() => _MusicLibraryPageState();
}

final class _MusicLibraryPageState extends State<MusicLibraryPage> {
  Widget _buildBody(BuildContext context, MusicLibraryState state) {
    final items = state.musicList;

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          leading: const Icon(Icons.music_note),
          title: Text(item.title ?? item.fileName),
          subtitle: Text('${item.artist?.toString() ?? "<unknown>"} - '
              '${item.album ?? "<unknown>"}'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.t.libraryPage;
    return BlocBuilder<MusicLibraryBloc, MusicLibraryState>(
      builder: (context, state) {
        final body = switch (state.status) {
          BasicStatus.initial || BasicStatus.loading => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  centerCircularProgressIndicator,
                  Text(state.currentLoadingFile ?? ''),
                ],
              ),
            ),
          BasicStatus.success ||
          BasicStatus.failure =>
            _buildBody(context, state),
        };
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
          body: body,
        );
      },
    );
  }
}
