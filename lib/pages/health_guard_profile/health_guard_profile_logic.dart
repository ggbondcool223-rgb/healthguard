import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../db_health_guard/data.dart';

class HealthGuardProfileLogic extends GetxController {
  final bloodSugarCount = 0.obs;
  final bloodPressureCount = 0.obs;
  final heartRateCount = 0.obs;
  final appVersion = '1.0.0'.obs;

  @override
  void onInit() async {
    super.onInit();
    loadStats();
    var info = await PackageInfo.fromPlatform();
    appVersion.value = info.version;
  }

  Future<void> loadStats() async {
    try {
      final db = Get.find<HealthGuardDB>().database;

      final bloodSugarResult = await db.query('blood_sugar');
      bloodSugarCount.value = bloodSugarResult.length;

      final bloodPressureResult = await db.query('blood_pressure');
      bloodPressureCount.value = bloodPressureResult.length;

      final heartRateResult = await db.query('heart_rate');
      heartRateCount.value = heartRateResult.length;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load statistics');
    }
  }

  Future<void> onCleanAllData() async {
    Get.defaultDialog(
      title: 'Clean All Data',
      middleText: 'Are you sure you want to delete all health data? This action cannot be undone.',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Get.theme.colorScheme.onError,
      buttonColor: Get.theme.colorScheme.error,
      onConfirm: () async {
        try {
          final db = Get.find<HealthGuardDB>().database;
          
          await db.delete('blood_sugar');
          await db.delete('blood_pressure');
          await db.delete('heart_rate');
          await db.delete('check_in');
          await db.delete('user_info');
          
          await loadStats();
          
          Get.back();
          Get.snackbar('Success', 'All data has been deleted successfully');
        } catch (e) {
          Get.snackbar('Error', 'Failed to delete data');
        }
      },
    );
  }
}
