import 'package:hotkey_manager/hotkey_manager.dart';

/// Key code and key name string convert map.
const _keyCodeMap = <String, KeyCode>{
  'A': KeyCode.keyA,
  'B': KeyCode.keyB,
  'C': KeyCode.keyC,
  'D': KeyCode.keyD,
  'E': KeyCode.keyE,
  'F': KeyCode.keyF,
  'G': KeyCode.keyG,
  'H': KeyCode.keyH,
  'I': KeyCode.keyI,
  'J': KeyCode.keyJ,
  'K': KeyCode.keyK,
  'L': KeyCode.keyL,
  'M': KeyCode.keyM,
  'N': KeyCode.keyN,
  'O': KeyCode.keyO,
  'P': KeyCode.keyP,
  'Q': KeyCode.keyQ,
  'R': KeyCode.keyR,
  'S': KeyCode.keyS,
  'T': KeyCode.keyT,
  'U': KeyCode.keyU,
  'V': KeyCode.keyV,
  'W': KeyCode.keyW,
  'X': KeyCode.keyX,
  'Y': KeyCode.keyY,
  'Z': KeyCode.keyZ,
  '1': KeyCode.digit1,
  '2': KeyCode.digit2,
  '3': KeyCode.digit3,
  '4': KeyCode.digit4,
  '5': KeyCode.digit5,
  '6': KeyCode.digit6,
  '7': KeyCode.digit7,
  '8': KeyCode.digit8,
  '9': KeyCode.digit9,
  '0': KeyCode.digit0,
  '-': KeyCode.minus,
  '=': KeyCode.equal,
  '(': KeyCode.bracketLeft,
  ')': KeyCode.bracketRight,
  r'\': KeyCode.backslash,
  ';': KeyCode.semicolon,
  "'": KeyCode.quote,
  '`': KeyCode.backquote,
  ',': KeyCode.comma,
  '.': KeyCode.period,
  '/': KeyCode.slash,
  'F1': KeyCode.f1,
  'F2': KeyCode.f2,
  'F3': KeyCode.f3,
  'F4': KeyCode.f4,
  'F5': KeyCode.f5,
  'F6': KeyCode.f6,
  'F7': KeyCode.f7,
  'F8': KeyCode.f8,
  'F9': KeyCode.f9,
  'F10': KeyCode.f10,
  'F11': KeyCode.f11,
  'F12': KeyCode.f12,
  '←': KeyCode.arrowLeft,
  '→': KeyCode.arrowRight,
  '↑': KeyCode.arrowUp,
  '↓': KeyCode.arrowDown,
};

const _keyModifierMap = <String, KeyModifier>{
  'CapsLock': KeyModifier.capsLock,
  'Shift': KeyModifier.shift,
  'Ctrl': KeyModifier.control,
  'Alt': KeyModifier.alt,
  'Meta': KeyModifier.meta,
  'Fn': KeyModifier.fn,
};

bool _isKeyModifierCode(String keyCode) {
  switch (keyCode) {
    case 'CapsLock':
      return true;
    case 'Shift':
      return true;
    case 'Ctrl':
      return true;
    case 'Alt':
      return true;
    case 'Meta':
      return true;
    case 'Fn':
      return true;
    default:
      return false;
  }
}

/// Convert key string to [HotKey]
HotKey? convertKeyFromString(String shortCutString) {
  final keyStringList = shortCutString.split('+');
  if (keyStringList.isEmpty) {
    return null;
  }
  // Use f24 to indicate invalid key.
  // TODO: Use better way.
  final hotKey = HotKey(
    KeyCode.f24,
    modifiers: <KeyModifier>[],
  );
  while (keyStringList.isNotEmpty) {
    if (_isKeyModifierCode(keyStringList[0])) {
      hotKey.modifiers!.add(_keyModifierMap[keyStringList[0]]!);
    } else if (_keyCodeMap.containsKey(keyStringList[0]) &&
        keyStringList.length == 1) {
      hotKey.keyCode = _keyCodeMap[keyStringList[0]]!;
    } else {
      return null;
    }
    keyStringList.removeAt(0);
  }
  if (hotKey.keyCode == KeyCode.f24) {
    return null;
  }
  return hotKey;
}
