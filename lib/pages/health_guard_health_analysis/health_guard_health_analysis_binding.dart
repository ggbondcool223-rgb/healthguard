import 'package:get/get.dart';

import 'health_guard_health_analysis_logic.dart';

class HealthGuardHealthAnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HealthGuardHealthAnalysisLogic());
  }
}
