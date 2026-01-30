import 'package:get/get.dart';

import 'health_guard_recipe_logic.dart';

class HealthGuardRecipeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HealthGuardRecipeLogic());
  }
}
