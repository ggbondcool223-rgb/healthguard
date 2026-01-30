import 'package:get/get.dart';

import 'health_guard_heart_rate_detect_logic.dart';

class HealthGuardHeartRateDetectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HealthGuardHeartRateDetectLogic());
  }
}
