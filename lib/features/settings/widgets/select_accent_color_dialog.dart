import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../i18n/strings.g.dart';
import '../../theme/cubit/theme_cubit.dart';
import '../bloc/settings_bloc.dart';

const _colorBoxSize = 50.0;

/// Dialog to let user select accent color.
final class SelectAccentColorDialog extends StatelessWidget {
  /// Constructor.
  const SelectAccentColorDialog({
    required this.currentColorValue,
    required this.blocContext,
    super.key,
  });

  /// Current accent color value.
  final int currentColorValue;

  /// Context passed from outside which has bloc.
  final BuildContext blocContext;

  @override
  Widget build(BuildContext context) {
    final tr = context.t.settingsPage.appearance.colorScheme;
    const items = Colors.primaries;
    return AlertDialog(
      title: Text(tr.title),
      scrollable: true,
      content: SizedBox(
        width: min(MediaQuery.of(context).size.width * 0.5, 350),
        height: min(MediaQuery.of(context).size.height * 0.5, 350),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: _colorBoxSize,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            mainAxisExtent: _colorBoxSize,
          ),
          itemBuilder: (context, index) => GestureDetector(
            onTap: () async => context.pop(items[index].value),
            child: Badge(
              isLabelVisible: items[index].value == currentColorValue,
              label: const Icon(Icons.check, size: 10),
              offset: Offset.zero,
              child: SizedBox(
                width: _colorBoxSize,
                height: _colorBoxSize,
                child: CircleAvatar(backgroundColor: items[index]),
              ),
            ),
          ),
          itemCount: items.length,
        ),
      ),
      actions: [
        TextButton(
          child: Text(context.t.general.reset),
          onPressed: () async {
            blocContext.read<ThemeCubit>().clearAccentColor();
            blocContext
                .read<SettingsBloc>()
                .add(const SettingsClearAccentColorRequested());
            context.pop();
          },
        ),
      ],
    );
  }
}
