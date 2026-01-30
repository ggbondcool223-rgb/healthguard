import 'package:get/get.dart';

import 'health_guard_history_logic.dart';

class HealthGuardHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HealthGuardHistoryLogic());
  }
}
