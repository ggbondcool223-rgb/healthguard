import 'package:get/get.dart';

import 'health_guard_health_report_logic.dart';

class HealthGuardHealthReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HealthGuardHealthReportLogic());
  }
}
