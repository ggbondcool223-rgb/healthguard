import 'package:get/get.dart';

import 'health_guard_personal_info_logic.dart';

class HealthGuardPersonalInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HealthGuardPersonalInfoLogic());
  }
}
