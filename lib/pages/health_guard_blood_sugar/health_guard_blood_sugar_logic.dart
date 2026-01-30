import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../db_health_guard/data.dart';
import '../../db_health_guard/health_guard_entity.dart';

class HealthGuardBloodSugarLogic extends GetxController {
  final selectedIndex = 20.obs;
  final healthStatus = 'Healthy'.obs;
  final healthAdvice = 'Your blood sugar is normal. Avoid high-sugar, high-fat foods, choose low-sugar, high-fiber foods such as vegetables, fruits, whole wheat bread, etc. Quit smoking, limit alcohol, maintain adequate sleep and reduce stress to help maintain normal blood sugar levels.'.obs;
  
  late FixedExtentScrollController scrollController;
  final List<double> values = List.generate(140, (index) => (index + 30) / 10);

  @override
  void onInit() {
    super.onInit();
    scrollController = FixedExtentScrollController(initialItem: selectedIndex.value);
    updateHealthStatus();
  }

  void onValueChanged(int index) {
    selectedIndex.value = index;
    updateHealthStatus();
  }

  void updateHealthStatus() {
    final value = values[selectedIndex.value];
    
    if (value < 3.9) {
      healthStatus.value = 'Low Blood Sugar';
      healthAdvice.value = 'Your blood sugar is low. Please supplement sugar promptly and consult a doctor.';
    } else if (value >= 3.9 && value <= 6.1) {
      healthStatus.value = 'Healthy';
      healthAdvice.value = 'Your blood sugar is normal. Maintain a balanced diet and healthy lifestyle.';
    } else if (value > 6.1 && value < 7.0) {
      healthStatus.value = 'Slightly High';
      healthAdvice.value = 'Your blood sugar is slightly elevated. Pay attention to diet control and increase exercise.';
    } else {
      healthStatus.value = 'High Risk';
      healthAdvice.value = 'Your blood sugar level may indicate diabetes. Please consult a doctor promptly.';
    }
  }

  Future<void> onSaveTap() async {
    try {
      final value = values[selectedIndex.value];
      final status = healthStatus.value;
      
      final bloodSugar = BloodSugar(
        value: value,
        type: 'fasting',
        status: status,
        createdAt: DateTime.now().toIso8601String(),
      );

      final db = Get.find<HealthGuardDB>().database;
      await db.insert('blood_sugar', bloodSugar.toMap());
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to save data');
    }
  }

  void onHistoryTap() {
    Get.toNamed('/health_guard_history', arguments: {'type': 'blood_sugar'});
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
