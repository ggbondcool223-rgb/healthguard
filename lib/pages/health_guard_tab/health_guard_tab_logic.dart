import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_guard/pages/health_guard_home/health_guard_home_logic.dart';
import 'package:health_guard/pages/health_guard_profile/health_guard_profile_logic.dart';

import '../health_guard_home/health_guard_home_view.dart';
import '../health_guard_knowledge/health_guard_knowledge_view.dart';
import '../health_guard_recipe/health_guard_recipe_view.dart';
import '../health_guard_profile/health_guard_profile_view.dart';

class HealthGuardTabLogic extends GetxController {
  final currentIndex = 0.obs;
  late PageController pageController;

  final List<Map<String, dynamic>> tabItems = [
    {'icon': Icons.home, 'label': 'Home'},
    {'icon': Icons.menu_book, 'label': 'Knowledge'},
    {'icon': Icons.restaurant, 'label': 'Recipe'},
    {'icon': Icons.person, 'label': 'Profile'},
  ];

  final List<Widget> pages = const [
    HealthGuardHomePage(),
    HealthGuardKnowledgePage(),
    HealthGuardRecipePage(),
    HealthGuardProfilePage(),
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentIndex.value);
  }

  void onTabTap(int index) {
    currentIndex.value = index;
    pageController.jumpToPage(index);
    if (index == 0) {
      HealthGuardHomeLogic homeLogic = Get.find<HealthGuardHomeLogic>();
      homeLogic.loadData();
    } else if (index == 3) {
      HealthGuardProfileLogic profileLogic = Get.find<HealthGuardProfileLogic>();
      profileLogic.loadStats();
    }
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
