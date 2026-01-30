import 'package:get/get.dart';

import '../../db_health_guard/data.dart';
import '../../db_health_guard/health_guard_entity.dart';

class HealthGuardChronicDiseaseLogic extends GetxController {
  final articles = <Map<String, dynamic>>[].obs;
  final category = 'chronic_disease'.obs;
  final categoryTitle = 'Chronic Disease Zone'.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      category.value = args['category'] ?? 'chronic_disease';
      categoryTitle.value = args['title'] ?? 'Chronic Disease Zone';
    }
    loadArticles();
  }

  Future<void> loadArticles() async {
    try {
      final db = Get.find<HealthGuardDB>().database;
      final result = await db.query(
        'articles',
        where: 'category = ?',
        whereArgs: [category.value],
        orderBy: 'created_at DESC',
      );

      articles.value = result.map((item) {
        final article = Article.fromMap(item);
        return {
          'id': article.id,
          'title': article.title,
          'content': article.content,
          'source': article.source,
        };
      }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load articles');
    }
  }
}
