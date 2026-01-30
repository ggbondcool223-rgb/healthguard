import 'package:get/get.dart';

import 'health_guard_recipe_detail_logic.dart';

class HealthGuardRecipeDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HealthGuardRecipeDetailLogic());
  }
}
