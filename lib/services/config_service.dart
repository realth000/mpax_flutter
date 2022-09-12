import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Map<String, Type> configMap = <String, Type>{
  "ScanTargetList": List<String>,
};

class ConfigService extends GetxService {
  ConfigService() {
    init();
  }

  late final SharedPreferences _config;

  static final Map _configMap = Map.from(configMap);

  // const Map _saveMethodMap = Map.from({int: _configMap.setInt()});
  Future<ConfigService> init() async {
    _config = await SharedPreferences.getInstance();
    _configMap['ScanTargetList'] = _config.getStringList('ScanTargetList');
    return this;
  }

  int? getInt(String key) {
    return _config.getInt(key);
  }

  Future<bool> saveInt(String key, int value) async {
    if (!_configMap.containsKey(key)) {
      return false;
    }
    _configMap[key] = value;
    await _config.setInt(key, value);
    return true;
  }

  bool? getBool(String key) {
    return _config.getBool(key);
  }

  Future<bool> saveBool(String key, bool value) async {
    if (!_configMap.containsKey(key)) {
      return false;
    }
    _configMap[key] = value;
    await _config.setBool(key, value);
    return true;
  }

  double? getDouble(String key) {
    return _config.getDouble(key);
  }

  Future<bool> saveDouble(String key, double value) async {
    if (!_configMap.containsKey(key)) {
      return false;
    }
    _configMap[key] = value;
    await _config.setDouble(key, value);
    return true;
  }

  String? getString(String key) {
    return _config.getString(key);
  }

  Future<bool> saveString(String key, String value) async {
    if (!_configMap.containsKey(key)) {
      return false;
    }
    _configMap[key] = value;
    await _config.setString(key, value);
    return true;
  }

  List<String>? getStringList(String key) {
    return _config.getStringList(key);
  }

  Future<bool> saveStringList(String key, List<String> value) async {
    if (!_configMap.containsKey(key)) {
      return false;
    }
    _configMap[key] = value;
    await _config.setStringList(key, value);
    return true;
  }
}
