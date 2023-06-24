import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// All config name and types map.
const Map<String, Type> configMap = <String, Type>{
  'ScanTargetList': List<String>,
  'CurrentMedia': String,
  'CurrentPlaylistId': int,
  'PlayMode': String,
  'UseDarkMode': bool,
  'FollowSystemDarkMode': bool,
  'Locale': String,
  'FollowSystemLocale': bool,
  'ScanSkipRecordedFile': bool,
  'ScanLoadImage': bool,
  'PlayerVolume': double,
  'AppBottomUnderfootHeight': double,
  'UseSystemNativeTitleBar': bool,
};

/// Settings service for app, globally.
class SettingsService extends GetxService {
  late final SharedPreferences _config;

  static final _configMap = Map<String, dynamic>.from(configMap);

  /// Store app bottom height value (double) to let other widgets to use.
  late final appBottomHeight =
      (getDouble('AppBottomUnderfootHeight') ?? 20).obs;

  /// Store app title bar style state.
  late final desktopUseNativeTittleBar =
      (getBool('UseSystemNativeTitleBar') ?? false).obs;

  /// Get the config map contains config name and config type.
  Map get configs => _configMap;

  /// Init function, run before app start.
  Future<SettingsService> init() async {
    _config = await SharedPreferences.getInstance();
    _configMap['ScanTargetList'] = _config.getStringList('ScanTargetList');
    return this;
  }

  /// Get int type value of specified key.
  int? getInt(String key) => _config.getInt(key);

  /// Sae int type value of specified key.
  Future<bool> saveInt(String key, int value) async {
    if (!_configMap.containsKey(key)) {
      return false;
    }
    _configMap[key] = value;
    await _config.setInt(key, value);
    return true;
  }

  /// Get bool type value of specified key.
  bool? getBool(String key) => _config.getBool(key);

  /// Save bool type value of specified value.
  Future<bool> saveBool(String key, bool value) async {
    if (!_configMap.containsKey(key)) {
      return false;
    }
    _configMap[key] = value;
    await _config.setBool(key, value);
    return true;
  }

  /// Get double type value of specified key.
  double? getDouble(String key) => _config.getDouble(key);

  /// Save double type value of specified key.
  Future<bool> saveDouble(String key, double value) async {
    if (!_configMap.containsKey(key)) {
      return false;
    }
    _configMap[key] = value;
    await _config.setDouble(key, value);
    return true;
  }

  /// Get string type value of specified key.
  String? getString(String key) => _config.getString(key);

  /// Save string type value of specified key.
  Future<bool> saveString(String key, String value) async {
    if (!_configMap.containsKey(key)) {
      return false;
    }
    _configMap[key] = value;
    await _config.setString(key, value);
    return true;
  }

  /// Get string list type value of specified key.
  List<String>? getStringList(String key) => _config.getStringList(key);

  /// Save string list type value of specified key.
  Future<bool> saveStringList(String key, List<String> value) async {
    if (!_configMap.containsKey(key)) {
      return false;
    }
    _configMap[key] = value;
    await _config.setStringList(key, value);
    return true;
  }
}
