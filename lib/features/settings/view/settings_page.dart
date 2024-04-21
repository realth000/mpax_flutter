import 'package:flutter/material.dart';

import '../../../i18n/strings.g.dart';

/// Page to show app settings.
final class SettingsPage extends StatefulWidget {
  /// Constructor.
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

/// State of [SettingsPage].
final class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final tr = context.t.settingsPage;
    return Center(child: Text(tr.title));
  }
}
