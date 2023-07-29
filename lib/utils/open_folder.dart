// Gnome    KDE     XFCE   LXDE     LXQT
// nautilus dolphin thunar pacmanfm pcmanfm-qt
//
// Cinnamon Mate UKUI  DDE
// nemo     caja peony dde-file-manager
import 'dart:io';

import 'package:mpax_flutter/utils/platform.dart';
import 'package:open_filex/open_filex.dart';

const _linuxFileManagerList = [
  'nautilus',
  'dolphin',
  'thunar',
  'pacmanfm',
  'pacmanfm-qt',
  'enmo',
  'caja',
  'peony',
  'dde-file-manager'
];

// TODO: Handle open error.
Future<void> openFolder(String path) async {
  if (isLinux) {
    for (final exe in _linuxFileManagerList) {
      final existCheck = await Process.start('which', [exe], runInShell: true);
      final exitCode = await existCheck.exitCode;
      if (exitCode != 0) {
        continue;
      }
      final progress = await Process.start(exe, ['.']);
      final _ = await progress.exitCode;
      break;
    }
  } else if (!isAndroid) {
    final _ = await OpenFilex.open(path);
  }
}
