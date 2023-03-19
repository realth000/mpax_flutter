import 'package:get/get.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

import '../../services/player_service.dart';
import '../../services/settings_service.dart';
import '../../utils/keymap_conversion.dart';

class _KeymapConfigPair {
  _KeymapConfigPair({
    // keyString is string format hotkey.
    required this.keyString,
    required this.keyCode,
    required this.handler,
    this.keyModifier,
  });

  String keyString;
  KeyCode keyCode;
  List<KeyModifier>? keyModifier;
  final HotKeyHandler handler;

  // Save the registered hot key.
  HotKey? registeredHotkey;
}

/// Manage shortcuts on desktop platforms.
class ShortcutService extends GetxService {
  final _playerService = Get.find<PlayerService>();
  final _configService = Get.find<SettingsService>();

  /// Key is the config name in [configMap].
  /// Value use to generate [HotKey].
  late final _keymapList = <String, _KeymapConfigPair>{
    'KeymapPlayPause': _KeymapConfigPair(
      keyCode: KeyCode.keyB,
      keyString: 'Ctrl+Alt+B',
      keyModifier: [KeyModifier.control, KeyModifier.alt],
      handler: (_) async {
        await _playerService.playOrPause();
      },
    ),
    'KeymapPlayPrevious': _KeymapConfigPair(
      keyCode: KeyCode.arrowLeft,
      keyString: 'Ctrl+Alt+←',
      keyModifier: [KeyModifier.control, KeyModifier.alt],
      handler: (_) async {
        await _playerService.seekToAnother(false);
      },
    ),
    'KeymapPlayNext': _KeymapConfigPair(
      keyCode: KeyCode.arrowRight,
      keyString: 'Ctrl+Alt+→',
      keyModifier: [KeyModifier.control, KeyModifier.alt],
      handler: (_) async {
        await _playerService.seekToAnother(true);
      },
    ),
  };

  /// Init function, run before app start.
  ///
  /// Init default key if needed.
  Future<ShortcutService> init() async {
    _keymapList.forEach((keyConfig, key) async {
      final keyStringInConfig = _configService.getString(keyConfig);
      if (keyStringInConfig == null) {
        // No such key config in config.
        // Use default and save to config.
        await _configService.saveString(keyConfig, key.keyString);
        key.registeredHotkey = HotKey(
          key.keyCode,
          modifiers: key.keyModifier,
          scope: HotKeyScope.system,
        );
        await hotKeyManager.register(
          key.registeredHotkey!,
          keyDownHandler: key.handler,
        );
      } else {
        final hotKeyFromConfig = convertKeyFromString(keyStringInConfig);
        if (hotKeyFromConfig == null) {
          // Have config saved, but is invalid.
          // Use default.
          await _configService.saveString(keyConfig, key.keyString);
          key.registeredHotkey = HotKey(
            key.keyCode,
            modifiers: key.keyModifier,
            scope: HotKeyScope.system,
          );
          await hotKeyManager.register(
            key.registeredHotkey!,
            keyDownHandler: key.handler,
          );
        } else {
          // Valid config saved, use it.
          hotKeyFromConfig.scope = HotKeyScope.system;
          key.registeredHotkey = hotKeyFromConfig;
          await hotKeyManager.register(
            hotKeyFromConfig,
            keyDownHandler: key.handler,
          );
        }
      }
    });
    return this;
  }

  /// Get current using hotkey value's name by its name.
  ///
  /// e.g. 'KeymapPlayPause' => 'Ctrl+Alt+B'
  /// The name must in [_keymapList].
  String getHotKeyStringByName(String hotKeyName) {
    if (!_keymapList.containsKey(hotKeyName)) {
      return '';
    }
    final s = _configService.getString(hotKeyName);
    return s ?? '';
  }

  /// Set the hot key with config name [hotKeyName] to [hotKeyValue].
  Future<bool> setHotKeyFromString(
    String hotKeyName,
    String hotKeyValue,
  ) async {
    if (!_keymapList.containsKey(hotKeyName)) {
      return false;
    }
    final newHotKey = convertKeyFromString(hotKeyValue);
    if (newHotKey == null) {
      return false;
    }
    // Unregister old hotkey
    await hotKeyManager.unregister(_keymapList[hotKeyName]!.registeredHotkey!);
    newHotKey.scope = HotKeyScope.system;
    _keymapList[hotKeyName]!.registeredHotkey = newHotKey;
    await hotKeyManager.register(
      newHotKey,
      keyDownHandler: _keymapList[hotKeyName]!.handler,
    );
    // Save to config.
    await _configService.saveString(hotKeyName, hotKeyValue);
    return true;
  }
}
