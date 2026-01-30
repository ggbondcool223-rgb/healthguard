import 'package:get/get.dart';

import 'health_guard_chronic_disease_logic.dart';

class HealthGuardChronicDiseaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HealthGuardChronicDiseaseLogic());
  }
}
