import 'package:get/get.dart';

import '../../db_health_guard/data.dart';
import '../../db_health_guard/health_guard_entity.dart';

class HealthGuardHealthReportLogic extends GetxController {
  final avgBloodPressureSystolic = 0.0.obs;
  final avgBloodPressureDiastolic = 0.0.obs;
  final avgBloodSugar = 0.0.obs;
  final avgHeartRate = 0.0.obs;
  
  final bloodPressureStatus = ''.obs;
  final bloodSugarStatus = ''.obs;
  final heartRateStatus = ''.obs;
  
  final bpDataCount = 0.obs;
  final bsDataCount = 0.obs;
  final hrDataCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadLast7DaysData();
  }

  Future<void> loadLast7DaysData() async {
    try {
      final db = Get.find<HealthGuardDB>().database;

      final bpResult = await db.query(
        'blood_pressure',
        orderBy: 'created_at DESC',
        limit: 7,
      );
      if (bpResult.isNotEmpty) {
        bpDataCount.value = bpResult.length;
        final systolicList = bpResult.map((e) => (BloodPressure.fromMap(e).systolic).toDouble()).toList();
        final diastolicList = bpResult.map((e) => (BloodPressure.fromMap(e).diastolic).toDouble()).toList();
        avgBloodPressureSystolic.value = systolicList.reduce((a, b) => a + b) / systolicList.length;
        avgBloodPressureDiastolic.value = diastolicList.reduce((a, b) => a + b) / diastolicList.length;
        _analyzeBloodPressure();
      }

      final bsResult = await db.query(
        'blood_sugar',
        orderBy: 'created_at DESC',
        limit: 7,
      );
      if (bsResult.isNotEmpty) {
        bsDataCount.value = bsResult.length;
        final bsList = bsResult.map((e) => BloodSugar.fromMap(e).value).toList();
        avgBloodSugar.value = bsList.reduce((a, b) => a + b) / bsList.length;
        _analyzeBloodSugar();
      }

      final hrResult = await db.query(
        'heart_rate',
        orderBy: 'created_at DESC',
        limit: 7,
      );
      if (hrResult.isNotEmpty) {
        hrDataCount.value = hrResult.length;
        final hrList = hrResult.map((e) => (HeartRate.fromMap(e).value).toDouble()).toList();
        avgHeartRate.value = hrList.reduce((a, b) => a + b) / hrList.length;
        _analyzeHeartRate();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load health data');
    }
  }

  void _analyzeBloodPressure() {
    final sys = avgBloodPressureSystolic.value;
    final dia = avgBloodPressureDiastolic.value;
    
    if (sys < 120 && dia < 80) {
      bloodPressureStatus.value = 'healthy';
    } else if (sys >= 140 || dia >= 90) {
      bloodPressureStatus.value = 'high';
    } else {
      bloodPressureStatus.value = 'normal';
    }
  }

  void _analyzeBloodSugar() {
    final value = avgBloodSugar.value;
    
    if (value < 3.9) {
      bloodSugarStatus.value = 'low';
    } else if (value > 6.1) {
      bloodSugarStatus.value = 'high';
    } else {
      bloodSugarStatus.value = 'healthy';
    }
  }

  void _analyzeHeartRate() {
    final value = avgHeartRate.value;
    
    if (value < 60) {
      heartRateStatus.value = 'low';
    } else if (value > 100) {
      heartRateStatus.value = 'high';
    } else {
      heartRateStatus.value = 'healthy';
    }
  }
}
