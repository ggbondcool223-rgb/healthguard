import 'package:get/get.dart';

import 'health_guard_knowledge_logic.dart';

class HealthGuardKnowledgeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HealthGuardKnowledgeLogic());
  }
}
