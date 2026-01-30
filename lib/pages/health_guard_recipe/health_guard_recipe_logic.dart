import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../db_health_guard/data.dart';
import '../../db_health_guard/health_guard_entity.dart';

class HealthGuardRecipeLogic extends GetxController {
  final recipes = <Map<String, dynamic>>[].obs;
  final selectedCategory = 'home_cooking'.obs;
  final monthlyRecipes = <Map<String, dynamic>>[].obs;
  final currentMonthName = ''.obs;
  final currentYear = ''.obs;
  final currentMonthIndex = 0.obs;
  
  final List<Map<String, dynamic>> monthsData = [];

  final categoryMap = {
    'Home Cooking': 'home_cooking',
    'Porridge': 'porridge',
    'Soup': 'soup',
    'Tea': 'tea',
    'Tonic': 'tonic',
  };

  final monthRecipeMap = {
    1: ['Ginger and Red Date Tea', 'Braised Pork Belly with Preserved Vegetables', 'Ginseng and Deer Antler Tonic Soup', 'Century Egg and Lean Pork Congee'],
    2: ['Lemon Ginger Honey Tea', 'Kung Pao Chicken with Cashews', 'Herbal Chicken Soup', 'Chicken and Vegetable Congee'],
    3: ['Chrysanthemum and Goji Berry Tea', 'Tofu and Vegetable Stir-Fry', 'Watercress and Pork Lung Soup', 'Sweet Potato and Millet Porridge'],
    4: ['Oolong Tea with Osmanthus', 'Steamed Fish with Ginger and Scallion', 'Tomato and Egg Drop Soup', 'Seafood and Vegetable Congee'],
    5: ['Hawthorn Berry and Rose Tea', 'Stir-Fried Vegetables with Mushrooms', 'Lotus Root and Peanut Soup', 'Red Bean and Barley Porridge'],
    6: ['Herbal Cooling Tea', 'Salt-Baked Shrimp with Garlic', 'Winter Melon and Pork Rib Soup', 'Red Bean and Barley Porridge'],
    7: ['Chrysanthemum and Goji Berry Tea', 'Tofu and Vegetable Stir-Fry', 'Winter Melon and Pork Rib Soup', 'Sweet Potato and Millet Porridge'],
    8: ['Herbal Cooling Tea', 'Steamed Fish with Ginger and Scallion', 'Lotus Root and Peanut Soup', 'Seafood and Vegetable Congee'],
    9: ['Oolong Tea with Osmanthus', 'Kung Pao Chicken with Cashews', 'Watercress and Pork Lung Soup', 'Pumpkin and Oat Porridge'],
    10: ['Hawthorn Berry and Rose Tea', 'Salt-Baked Shrimp with Garlic', 'Fish Maw and Chicken Soup', 'Century Egg and Lean Pork Congee'],
    11: ['Ginger and Red Date Tea', 'Braised Pork Belly with Preserved Vegetables', 'Herbal Chicken Soup', 'Chicken and Vegetable Congee'],
    12: ['Lemon Ginger Honey Tea', 'Kung Pao Chicken with Cashews', 'Cordyceps and Black Chicken Soup', 'Century Egg and Lean Pork Congee'],
  };

  @override
  void onInit() {
    super.onInit();
    loadAllMonths();
    loadRecipes();
  }

  void loadAllMonths() {
    try {
      final now = DateTime.now();
      final currentMonth = now.month;
      final year = now.year;
      
      monthsData.clear();
      
      for (int i = 1; i <= 12; i++) {
        monthsData.add(_createMonthData(year, i));
      }
      
      currentMonthIndex.value = currentMonth - 1;
      _updateCurrentMonth(currentMonthIndex.value);
    } catch (e) {
      print('Error loading months: $e');
      currentMonthName.value = 'January';
      currentYear.value = DateTime.now().year.toString();
      loadMonthlyRecipes();
    }
  }

  Map<String, dynamic> _createMonthData(int year, int month) {
    final monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    return {
      'name': monthNames[month - 1],
      'year': year.toString(),
      'month': month,
    };
  }

  void onMonthChanged(int monthIndex, int year) {
    currentMonthIndex.value = monthIndex;
    
    final data = monthsData[monthIndex];
    currentMonthName.value = data['name'] ?? '';
    currentYear.value = year.toString();
    
    loadMonthlyRecipes();
  }

  void _updateCurrentMonth(int index) {
    final data = monthsData[index];
    currentMonthName.value = data['name'] ?? '';
    currentYear.value = data['year'] ?? '';
    loadMonthlyRecipes();
  }

  Future<void> loadMonthlyRecipes() async {
    try {
      final monthIndex = currentMonthIndex.value;
      if (monthIndex < 0 || monthIndex >= monthsData.length) return;
      
      final month = monthsData[monthIndex]['month'] as int;
      final recipeNames = monthRecipeMap[month] ?? [];
      if (recipeNames.isEmpty) return;

      final db = Get.find<HealthGuardDB>().database;
      final List<Map<String, dynamic>> allRecipes = [];

      for (var name in recipeNames) {
        final result = await db.query(
          'recipes',
          where: 'name = ?',
          whereArgs: [name],
          limit: 1,
        );
        if (result.isNotEmpty) {
          final recipe = Recipe.fromMap(result.first);
          allRecipes.add({
            'id': recipe.id,
            'name': recipe.name,
            'ingredients': recipe.ingredients,
            'instructions': recipe.instructions,
            'benefits': recipe.benefits,
            'category': recipe.category,
          });
        }
      }

      monthlyRecipes.value = allRecipes;
    } catch (e) {
      print('Error loading monthly recipes: $e');
    }
  }

  void onCategoryChanged(String categoryLabel) {
    selectedCategory.value = categoryMap[categoryLabel] ?? 'home_cooking';
    loadRecipes();
  }

  Future<void> loadRecipes() async {
    try {
      final db = Get.find<HealthGuardDB>().database;
      final result = await db.query(
        'recipes',
        where: 'category = ?',
        whereArgs: [selectedCategory.value],
        orderBy: 'created_at DESC',
      );

      recipes.value = result.map((item) {
        final recipe = Recipe.fromMap(item);
        return {
          'id': recipe.id,
          'name': recipe.name,
          'ingredients': recipe.ingredients,
          'instructions': recipe.instructions,
          'benefits': recipe.benefits,
          'category': recipe.category,
        };
      }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load recipes');
    }
  }
}
