import 'package:get/get.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

import '../../services/player_service.dart';

/// Manage shortcuts on desktop platforms.
class ShortcutService extends GetxService {
  final _playerService = Get.find<PlayerService>();

  /// Init function, run before app start.
  Future<ShortcutService> init() async {
    // Register global shortcut: play or pause.
    final playerPlayOrPause = HotKey(
      KeyCode.keyB,
      modifiers: [KeyModifier.control, KeyModifier.alt],
      scope: HotKeyScope.system,
    );
    await hotKeyManager.register(
      playerPlayOrPause,
      keyDownHandler: (_) async {
        await _playerService.playOrPause();
      },
    );

    // Register global shortcut: play previous.
    final playerPlayPrevious = HotKey(
      KeyCode.arrowLeft,
      modifiers: [KeyModifier.control, KeyModifier.alt],
      scope: HotKeyScope.system,
    );
    await hotKeyManager.register(
      playerPlayPrevious,
      keyDownHandler: (_) async {
        await _playerService.seekToAnother(false);
      },
    );

    // Register global shortcut: play next.
    final playerPlayNext = HotKey(
      KeyCode.arrowRight,
      modifiers: [KeyModifier.control, KeyModifier.alt],
      scope: HotKeyScope.system,
    );
    await hotKeyManager.register(
      playerPlayNext,
      keyDownHandler: (_) async {
        await _playerService.seekToAnother(true);
      },
    );
    return this;
  }
}
