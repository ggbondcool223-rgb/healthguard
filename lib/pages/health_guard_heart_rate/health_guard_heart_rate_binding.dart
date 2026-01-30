import 'package:get/get.dart';

import 'health_guard_heart_rate_logic.dart';

class HealthGuardHeartRateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HealthGuardHeartRateLogic());
  }
}
