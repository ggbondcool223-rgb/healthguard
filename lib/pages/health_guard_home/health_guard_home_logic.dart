import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:health_guard/pages/health_guard_tab/health_guard_tab_logic.dart';
import 'package:intl/intl.dart';

import '../../db_health_guard/data.dart';
import '../../db_health_guard/health_guard_entity.dart';

class HealthGuardHomeLogic extends GetxController {
  final isLoading = true.obs;
  final userInfo = Rxn<UserInfo>();
  final latestBloodSugar = Rxn<BloodSugar>();
  final latestBloodPressure = Rxn<BloodPressure>();
  final latestHeartRate = Rxn<HeartRate>();
  final consecutiveDays = 0.obs;
  final bloodPressureCount = 0.obs;
  final bloodSugarCount = 0.obs;
  final heartRateCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        loadUserInfo(),
        loadLatestHealthData(),
        loadCheckInDays(),
        loadHealthAnalysis(),
      ]);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadUserInfo() async {
    try {
      final db = Get.find<HealthGuardDB>().database;
      final result = await db.query('user_info', limit: 1);
      if (result.isNotEmpty) {
        userInfo.value = UserInfo.fromMap(result.first);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user info');
    }
  }

  Future<void> loadLatestHealthData() async {
    try {
      final db = Get.find<HealthGuardDB>().database;
      
      final bloodSugarResult = await db.query(
        'blood_sugar',
        orderBy: 'created_at DESC',
        limit: 1,
      );
      if (bloodSugarResult.isNotEmpty) {
        latestBloodSugar.value = BloodSugar.fromMap(bloodSugarResult.first);
      }

      final bloodPressureResult = await db.query(
        'blood_pressure',
        orderBy: 'created_at DESC',
        limit: 1,
      );
      if (bloodPressureResult.isNotEmpty) {
        latestBloodPressure.value = BloodPressure.fromMap(bloodPressureResult.first);
      }

      final heartRateResult = await db.query(
        'heart_rate',
        orderBy: 'created_at DESC',
        limit: 1,
      );
      if (heartRateResult.isNotEmpty) {
        latestHeartRate.value = HeartRate.fromMap(heartRateResult.first);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load health data');
    }
  }

  Future<void> loadCheckInDays() async {
    try {
      final db = Get.find<HealthGuardDB>().database;
      final checkIns = await db.query(
        'check_in',
        orderBy: 'date DESC',
      );

      int days = 0;
      DateTime? lastDate;

      for (var checkIn in checkIns) {
        final date = DateTime.parse(checkIn['date'] as String);
        if (lastDate == null) {
          lastDate = date;
          days = 1;
        } else {
          if (lastDate.difference(date).inDays == 1) {
            days++;
            lastDate = date;
          } else {
            break;
          }
        }
      }

      consecutiveDays.value = days;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load check-in data');
    }
  }

  Future<void> loadHealthAnalysis() async {
    try {
      final db = Get.find<HealthGuardDB>().database;
      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
      final dateStr = sevenDaysAgo.toIso8601String();

      final bloodPressureResult = await db.query(
        'blood_pressure',
        where: 'created_at >= ?',
        whereArgs: [dateStr],
      );
      bloodPressureCount.value = bloodPressureResult.length;

      final bloodSugarResult = await db.query(
        'blood_sugar',
        where: 'created_at >= ?',
        whereArgs: [dateStr],
      );
      bloodSugarCount.value = bloodSugarResult.length;

      final heartRateResult = await db.query(
        'heart_rate',
        where: 'created_at >= ?',
        whereArgs: [dateStr],
      );
      heartRateCount.value = heartRateResult.length;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load analysis data');
    }
  }

  void onPersonalInfoTap() {
    Get.toNamed('/health_guard_personal_info')?.then((_) => loadData());
  }

  void onBloodSugarTap() {
    Get.toNamed('/health_guard_blood_sugar')?.then((_) => loadData());
  }

  void onBloodPressureTap() {
    Get.toNamed('/health_guard_blood_pressure')?.then((_) => loadData());
  }

  void onHeartRateTap() {
    Get.toNamed('/health_guard_heart_rate')?.then((_) => loadData());
  }

  void onHeartRateDetectTap() {
    Get.toNamed('/health_guard_heart_rate_detect')?.then((_) => loadData());
  }

  void onHistoryTap() {
    Get.toNamed('/health_guard_history');
  }

  Future<void> onCheckInMoreTap() async {
    try {
      final db = Get.find<HealthGuardDB>().database;
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final result = await db.query(
        'check_in',
        where: 'date = ?',
        whereArgs: [today],
      );

      if (result.isNotEmpty) {
        Fluttertoast.showToast(msg: 'Today already checked in');
        return;
      }

      await db.insert('check_in', {
        'date': today,
        'created_at': DateTime.now().toIso8601String(),
      });

      await loadCheckInDays();
      Fluttertoast.showToast(msg: 'Check in success');
    } catch (e) {
      Get.snackbar('Error', 'Failed to check in');
    }
  }

  void onKnowledgeMoreTap() {
    Get.find<HealthGuardTabLogic>().onTabTap(1);
  }

  void onKnowledgeCardTap(String articleId) {
    Get.toNamed(
      '/health_guard_article_detail',
      arguments: articleId,
    );
  }

  void onAnalysisTap() {
    Get.toNamed('/health_guard_health_analysis');
  }
}
