import 'package:get/get.dart';

/// Service for desktop main page (scaffold).
class ScaffoldService extends GetxService {
  /// Current open index.
  final currentIndex = 0.obs;

  /// Init function, run before app start.
  Future<ScaffoldService> init() async => this;
}
