import 'package:get/get.dart';

class HealthGuardRecipeDetailLogic extends GetxController {
  final recipeName = ''.obs;
  final benefits = ''.obs;
  final ingredients = ''.obs;
  final instructions = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final recipe = Get.arguments as Map<String, dynamic>?;
    if (recipe != null) {
      recipeName.value = recipe['name'] as String;
      benefits.value = recipe['benefits'] as String;
      ingredients.value = recipe['ingredients'] as String;
      instructions.value = recipe['instructions'] as String;
    }
  }
}
