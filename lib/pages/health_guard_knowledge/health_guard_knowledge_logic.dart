import 'package:get/get.dart';

import '../../db_health_guard/data.dart';
import '../../db_health_guard/health_guard_entity.dart';

class HealthGuardKnowledgeLogic extends GetxController {
  final articles = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadArticles();
  }

  Future<void> loadArticles() async {
    try {
      final db = Get.find<HealthGuardDB>().database;
      final result = await db.query(
        'articles',
        where: 'category = ?',
        whereArgs: ['knowledge'],
        orderBy: 'created_at DESC',
      );

      articles.value = result.map((item) {
        final article = Article.fromMap(item);
        return {
          'id': article.id,
          'title': article.title,
          'content': article.content,
          'category': article.category,
          'source': article.source,
        };
      }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load articles');
    }
  }

  void onCategoryTap(String category, String title) {
    Get.toNamed(
      '/health_guard_chronic_disease',
      arguments: {'category': category, 'title': title},
    );
  }
}
