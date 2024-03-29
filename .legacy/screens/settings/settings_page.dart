import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpax_flutter/router.dart';
import 'package:mpax_flutter/widgets/redirect_card.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RedirectCard(
              Icon(Icons.app_registration),
              'Appearance',
              ScreenPaths.appearance,
              extraObject: <String, String>{'appBarTitle': 'Appearance'},
            ),
            RedirectCard(
              Icon(Icons.search),
              'Scan Music',
              ScreenPaths.scan,
              extraObject: <String, String>{'appBarTitle': 'Scan Music'},
            ),
            RedirectCard(
              Icon(Icons.info),
              'About',
              ScreenPaths.about,
              extraObject: <String, String>{'appBarTitle': 'About'},
            ),
          ],
        ),
      ),
    );
  }
}
