import 'package:flutter/material.dart';

import 'package:mpax_flutter/i18n/strings.g.dart';

/// Dialog to let user choose app locale.
///
/// # Return
///
/// * `(null, true)` if is follow system.
/// * `(languageTag, false) if is specified language.
class SelectLanguageDialog extends StatelessWidget {
  /// Constructor.
  const SelectLanguageDialog(this.currentLocale, {super.key});

  /// Current using locale.
  final String currentLocale;

  @override
  Widget build(BuildContext context) {
    final tr = context.t.settingsPage.appearance.languages;
    return AlertDialog(
      scrollable: true,
      title: Text(tr.selectLanguage),
      content: SingleChildScrollView(
        child: Column(
          children: [
            RadioListTile(
              title: Text(tr.followSystem),
              onChanged: (value) async {
                if (value != null) {
                  Navigator.of(context).pop((null, true));
                }
              },
              value: '',
              groupValue: currentLocale,
            ),
            ...AppLocale.values.map(
              (e) => RadioListTile(
                title: Text(e.translations.locale),
                value: e.languageTag,
                groupValue: currentLocale,
                onChanged: (value) async {
                  Navigator.of(context).pop((e, false));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
