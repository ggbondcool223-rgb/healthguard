import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../db_health_guard/data.dart';
import '../../db_health_guard/health_guard_entity.dart';

class HealthGuardHealthAnalysisLogic extends GetxController {
  final isLoading = true.obs;
  final bloodPressureSystolic = <double>[].obs;
  final bloodPressureDiastolic = <double>[].obs;
  final bloodPressureDates = <String>[].obs;
  final bloodSugarData = <double>[].obs;
  final bloodSugarDates = <String>[].obs;
  final heartRateData = <double>[].obs;
  final heartRateDates = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  String _formatDate(String iso) {
    try {
      final d = DateTime.parse(iso);
      return DateFormat('MM/dd').format(d);
    } catch (_) {
      return '';
    }
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      final db = Get.find<HealthGuardDB>().database;

      final bloodPressureResult = await db.query(
        'blood_pressure',
        orderBy: 'created_at DESC',
        limit: 7,
      );
      final bpReversed = bloodPressureResult.reversed.toList();
      bloodPressureSystolic.value =
          bpReversed.map((e) => (BloodPressure.fromMap(e).systolic.toDouble())).toList();
      bloodPressureDiastolic.value =
          bpReversed.map((e) => (BloodPressure.fromMap(e).diastolic.toDouble())).toList();
      bloodPressureDates.value =
          bpReversed.map((e) => _formatDate(e['created_at'] as String)).toList();

      final bloodSugarResult = await db.query(
        'blood_sugar',
        orderBy: 'created_at DESC',
        limit: 7,
      );
      final bsReversed = bloodSugarResult.reversed.toList();
      bloodSugarData.value =
          bsReversed.map((e) => BloodSugar.fromMap(e).value).toList();
      bloodSugarDates.value =
          bsReversed.map((e) => _formatDate(e['created_at'] as String)).toList();

      final heartRateResult = await db.query(
        'heart_rate',
        orderBy: 'created_at DESC',
        limit: 7,
      );
      final hrReversed = heartRateResult.reversed.toList();
      heartRateData.value =
          hrReversed.map((e) => HeartRate.fromMap(e).value.toDouble()).toList();
      heartRateDates.value =
          hrReversed.map((e) => _formatDate(e['created_at'] as String)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load analysis data');
    } finally {
      isLoading.value = false;
    }
  }
}
