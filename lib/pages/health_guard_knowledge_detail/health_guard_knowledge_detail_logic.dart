import 'package:get/get.dart';

class HealthGuardKnowledgeDetailLogic extends GetxController {
  final articleTitle = ''.obs;
  final articleContent = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      articleTitle.value = args['title'] ?? '';
      articleContent.value = args['content'] ?? '';
    }
  }
}
