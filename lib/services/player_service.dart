import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Map<String, Type> configMap = <String, Type>{
  "CurrentMedia": String,
};

class PlayerService extends GetxService {
  PlayerService() {
    init();
  }

  late final SharedPreferences _config;

  static final Map _configMap = Map.from(configMap);

  Future<PlayerService> init() async {
    _config = await SharedPreferences.getInstance();
    _configMap['CurrentMedia'] = _config.getString('CurrentMedia');
    return this;
  }
}
