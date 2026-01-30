import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../db_health_guard/data.dart';
import '../../db_health_guard/health_guard_entity.dart';

class HealthGuardBloodPressureLogic extends GetxController {
  final selectedSystolic = 15.obs;
  final selectedDiastolic = 10.obs;
  final healthStatus = 'Healthy'.obs;
  final healthAdvice = 'Your blood pressure is normal. Maintaining normal blood pressure helps prevent cardiovascular diseases and other health problems related to hypertension.'.obs;
  
  late FixedExtentScrollController systolicController;
  late FixedExtentScrollController diastolicController;
  
  final List<int> systolicValues = List.generate(111, (index) => index + 90);
  final List<int> diastolicValues = List.generate(71, (index) => index + 60);

  @override
  void onInit() {
    super.onInit();
    systolicController = FixedExtentScrollController(initialItem: selectedSystolic.value);
    diastolicController = FixedExtentScrollController(initialItem: selectedDiastolic.value);
    updateHealthStatus();
  }

  void onSystolicChanged(int index) {
    selectedSystolic.value = index;
    updateHealthStatus();
  }

  void onDiastolicChanged(int index) {
    selectedDiastolic.value = index;
    updateHealthStatus();
  }

  void updateHealthStatus() {
    final systolic = systolicValues[selectedSystolic.value];
    final diastolic = diastolicValues[selectedDiastolic.value];
    
    if (systolic >= 90 && systolic <= 120 && diastolic >= 60 && diastolic <= 80) {
      healthStatus.value = 'Healthy';
      healthAdvice.value = 'Your blood pressure is normal. Maintain a healthy diet and regular exercise.';
    } else if (systolic > 140 || diastolic > 90) {
      healthStatus.value = 'High Risk';
      healthAdvice.value = 'Your blood pressure is elevated. Please consult a doctor and adjust your lifestyle.';
    } else {
      healthStatus.value = 'Slightly High';
      healthAdvice.value = 'Your blood pressure is slightly elevated. Pay attention to diet and increase exercise.';
    }
  }

  Future<void> onSaveTap() async {
    try {
      final systolic = systolicValues[selectedSystolic.value];
      final diastolic = diastolicValues[selectedDiastolic.value];
      final status = healthStatus.value;
      
      final bloodPressure = BloodPressure(
        systolic: systolic,
        diastolic: diastolic,
        status: status,
        createdAt: DateTime.now().toIso8601String(),
      );

      final db = Get.find<HealthGuardDB>().database;
      await db.insert('blood_pressure', bloodPressure.toMap());
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to save data');
    }
  }

  void onHistoryTap() {
    Get.toNamed('/health_guard_history', arguments: {'type': 'blood_pressure'});
  }

  @override
  void onClose() {
    systolicController.dispose();
    diastolicController.dispose();
    super.onClose();
  }
}
