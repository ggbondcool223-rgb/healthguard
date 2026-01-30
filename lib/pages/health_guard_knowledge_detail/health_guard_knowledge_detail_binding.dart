import 'package:get/get.dart';

import 'health_guard_knowledge_detail_logic.dart';

class HealthGuardKnowledgeDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HealthGuardKnowledgeDetailLogic());
  }
}
