import 'package:get/get.dart';

import 'health_guard_profile_logic.dart';

class HealthGuardProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HealthGuardProfileLogic());
  }
}
