import 'package:get/get.dart';

import '../../db_health_guard/data.dart';

class HealthGuardHistoryLogic extends GetxController {
  final isLoading = true.obs;
  final allRecords = <Map<String, dynamic>>[].obs;
  final filterType = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('type')) {
      filterType.value = args['type'] as String;
    }
    loadHistory();
  }

  String getPageTitle() {
    switch (filterType.value) {
      case 'blood_sugar':
        return 'Blood Sugar History';
      case 'blood_pressure':
        return 'Blood Pressure History';
      case 'heart_rate':
        return 'Heart Rate History';
      default:
        return 'History Records';
    }
  }

  Future<void> loadHistory() async {
    try {
      isLoading.value = true;
      final db = Get.find<HealthGuardDB>().database;
      final records = <Map<String, dynamic>>[];

      if (filterType.value.isEmpty || filterType.value == 'blood_sugar') {
        final bloodSugarResult = await db.query(
          'blood_sugar',
          orderBy: 'created_at DESC',
        );
        for (var item in bloodSugarResult) {
          records.add({
            'type': 'blood_sugar',
            'status': item['status'] as String,
            'value': '${item['value']} mmol/L',
            'created_at': item['created_at'] as String,
          });
        }
      }

      if (filterType.value.isEmpty || filterType.value == 'blood_pressure') {
        final bloodPressureResult = await db.query(
          'blood_pressure',
          orderBy: 'created_at DESC',
        );
        for (var item in bloodPressureResult) {
          records.add({
            'type': 'blood_pressure',
            'status': item['status'] as String,
            'value': '${item['systolic']}/${item['diastolic']} mmHg',
            'created_at': item['created_at'] as String,
          });
        }
      }

      if (filterType.value.isEmpty || filterType.value == 'heart_rate') {
        final heartRateResult = await db.query(
          'heart_rate',
          orderBy: 'created_at DESC',
        );
        for (var item in heartRateResult) {
          records.add({
            'type': 'heart_rate',
            'status': item['status'] as String,
            'value': '${item['value']} bpm',
            'created_at': item['created_at'] as String,
          });
        }
      }

      records.sort((a, b) => b['created_at'].compareTo(a['created_at']));
      allRecords.value = records;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load history');
    } finally {
      isLoading.value = false;
    }
  }
}
