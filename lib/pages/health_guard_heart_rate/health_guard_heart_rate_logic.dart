import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../db_health_guard/data.dart';
import '../../db_health_guard/health_guard_entity.dart';

class HealthGuardHeartRateLogic extends GetxController {
  final selectedIndex = 20.obs;
  final healthStatus = 'Normal Heart Rate'.obs;
  final healthAdvice = 'Your heart rate is normal. Maintaining a normal heart rate is crucial for health. Adjust lifestyle, develop good eating habits, quit bad habits, increase physical exercise, and maintain emotional stability to help keep heart rate healthy.'.obs;
  
  late FixedExtentScrollController scrollController;
  final List<int> values = List.generate(161, (index) => index + 40);

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
    
    if (value < 60) {
      healthStatus.value = 'Low Heart Rate';
      healthAdvice.value = 'Your heart rate is low. Please consult a doctor if you feel uncomfortable.';
    } else if (value >= 60 && value <= 100) {
      healthStatus.value = 'Normal Heart Rate';
      healthAdvice.value = 'Your heart rate is normal. Keep healthy lifestyle habits.';
    } else {
      healthStatus.value = 'High Heart Rate';
      healthAdvice.value = 'Your heart rate is elevated. Pay attention to rest and reduce stress.';
    }
  }

  Future<void> onSaveTap() async {
    try {
      final value = values[selectedIndex.value];
      final status = healthStatus.value;
      
      final heartRate = HeartRate(
        value: value,
        status: status,
        createdAt: DateTime.now().toIso8601String(),
      );

      final db = Get.find<HealthGuardDB>().database;
      await db.insert('heart_rate', heartRate.toMap());
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to save data');
    }
  }

  void onHistoryTap() {
    Get.toNamed('/health_guard_history', arguments: {'type': 'heart_rate'});
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
