import 'package:get/get.dart';

import 'health_guard_blood_sugar_logic.dart';

class HealthGuardBloodSugarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HealthGuardBloodSugarLogic());
  }
}
