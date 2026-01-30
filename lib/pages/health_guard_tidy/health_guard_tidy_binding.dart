import 'package:get/get.dart';

import 'health_guard_tidy_logic.dart';

class HealthGuardTidyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      HealthGuardTidyLogic(),
      permanent: true,
    );
  }
}
