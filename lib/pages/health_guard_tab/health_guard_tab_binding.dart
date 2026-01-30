import 'package:get/get.dart';
import 'package:health_guard/pages/health_guard_home/health_guard_home_logic.dart';
import 'package:health_guard/pages/health_guard_knowledge/health_guard_knowledge_logic.dart';
import 'package:health_guard/pages/health_guard_profile/health_guard_profile_logic.dart';
import 'package:health_guard/pages/health_guard_recipe/health_guard_recipe_logic.dart';

import 'health_guard_tab_logic.dart';

class HealthGuardTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HealthGuardTabLogic());
    Get.lazyPut(() => HealthGuardHomeLogic());
    Get.lazyPut(() => HealthGuardKnowledgeLogic());
    Get.lazyPut(() => HealthGuardRecipeLogic());
    Get.lazyPut(() => HealthGuardProfileLogic());
  }
}
