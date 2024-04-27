import 'package:flutter/material.dart';

import '../../../i18n/strings.g.dart';
import '../../logging/enums/loglevel.dart';

/// Show dialog.
class SelectLoglevelDialog extends StatelessWidget {
  /// Constructor.
  const SelectLoglevelDialog(this.currentLevel, {super.key});

  /// Current level.
  final Loglevel currentLevel;

  @override
  Widget build(BuildContext context) {
    final tr = context.t.settingsPage.debug;
    return AlertDialog(
      clipBehavior: Clip.antiAlias,
      title: Text(tr.title),
      content: SingleChildScrollView(
        child: Column(
          children: Loglevel.values
              .map(
                (e) => RadioListTile(
                  title: Text(e.tr(context)),
                  onChanged: (value) async {
                    if (value != null) {
                      Navigator.of(context).pop(e);
                    }
                  },
                  value: e,
                  groupValue: currentLevel,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
