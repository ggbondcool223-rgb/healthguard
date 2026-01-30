import 'package:get/get.dart';

import 'health_guard_home_logic.dart';

class HealthGuardHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HealthGuardHomeLogic());
  }
}
