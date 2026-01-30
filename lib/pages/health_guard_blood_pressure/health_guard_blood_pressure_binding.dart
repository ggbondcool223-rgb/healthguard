import 'package:get/get.dart';

import 'health_guard_blood_pressure_logic.dart';

class HealthGuardBloodPressureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HealthGuardBloodPressureLogic());
  }
}
