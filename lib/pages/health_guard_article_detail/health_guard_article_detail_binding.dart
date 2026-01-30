import 'package:get/get.dart';

import 'health_guard_article_detail_logic.dart';

class HealthGuardArticleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HealthGuardArticleDetailLogic());
  }
}
