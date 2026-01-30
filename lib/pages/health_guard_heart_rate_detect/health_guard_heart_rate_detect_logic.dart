import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:heart_bpm/heart_bpm.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../db_health_guard/data.dart';
import '../../db_health_guard/health_guard_entity.dart';

class HealthGuardHeartRateDetectLogic extends GetxController {
  final heartRate = 0.obs;
  final isDetecting = false.obs;
  final sensorValues = <SensorValue>[].obs;
  final bpmValues = <int>[].obs;

  void onStartDetection() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      Fluttertoast.showToast(msg: 'Camera permission is required');
      return;
    }
    if (isDetecting.value) {
      _saveHeartRate();
    } else {
      isDetecting.value = true;
      sensorValues.clear();
      bpmValues.clear();
      heartRate.value = 0;
    }
  }

  void onRawData(SensorValue value) {
    if (sensorValues.length >= 100) {
      sensorValues.removeAt(0);
    }
    sensorValues.add(value);
  }

  void onBPM(int value) {
    if (value > 0 && value < 200) {
      heartRate.value = value;
      if (bpmValues.length >= 20) {
        bpmValues.removeAt(0);
      }
      bpmValues.add(value);
    }
  }

  Future<void> _saveHeartRate() async {
    isDetecting.value = false;

    if (bpmValues.isEmpty) {
      Fluttertoast.showToast(msg: 'No valid heart rate data collected');
      return;
    }

    try {
      final avgRate =
          (bpmValues.reduce((a, b) => a + b) / bpmValues.length).round();
      heartRate.value = avgRate;

      final status = _getHealthStatus(avgRate);

      final heartRateData = HeartRate(
        value: avgRate,
        status: status,
        createdAt: DateTime.now().toIso8601String(),
      );

      final db = Get.find<HealthGuardDB>().database;
      await db.insert('heart_rate', heartRateData.toMap());

      Fluttertoast.showToast(msg: 'Heart rate: $avgRate bpm - $status');
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save heart rate: ${e.toString()}',
        duration: const Duration(seconds: 2),
      );
    }
  }

  String _getHealthStatus(int rate) {
    if (rate < 60) {
      return 'Low';
    } else if (rate >= 60 && rate <= 100) {
      return 'Normal';
    } else {
      return 'High';
    }
  }
}
