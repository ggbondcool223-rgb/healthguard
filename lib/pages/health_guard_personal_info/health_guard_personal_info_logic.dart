import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../db_health_guard/data.dart';
import '../../db_health_guard/health_guard_entity.dart';

class HealthGuardPersonalInfoLogic extends GetxController {
  final age = 0.obs;
  final height = 0.0.obs;
  final weight = 0.0.obs;
  final medicalHistory = ''.obs;
  
  final checkInDays = 0.obs;
  final bloodSugarDays = 0.obs;
  final bloodPressureDays = 0.obs;
  final heartRateDays = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
    loadHealthStats();
  }

  Future<void> loadUserInfo() async {
    try {
      final db = Get.find<HealthGuardDB>().database;
      final result = await db.query('user_info', limit: 1);
      
      if (result.isNotEmpty) {
        final userInfo = UserInfo.fromMap(result.first);
        age.value = userInfo.age ?? 50;
        height.value = userInfo.height ?? 0.0;
        weight.value = userInfo.weight ?? 0.0;
        medicalHistory.value = userInfo.medicalHistory ?? '';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user info');
    }
  }

  void onEditField(String field) {
    String initialValue = '';
    String hint = 'Enter $field';
    int maxLines = 1;
    
    switch (field) {
      case 'Age':
        initialValue = age.value > 0 ? age.value.toString() : '';
        hint = 'Enter age (years)';
        break;
      case 'Height':
        initialValue = height.value > 0 ? height.value.toStringAsFixed(1) : '';
        hint = 'Enter height (cm)';
        break;
      case 'Weight':
        initialValue = weight.value > 0 ? weight.value.toStringAsFixed(1) : '';
        hint = 'Enter weight (kg)';
        break;
      case 'Medical History':
        initialValue = medicalHistory.value;
        hint = 'Enter medical history';
        maxLines = 5;
        break;
    }
    
    final controller = TextEditingController(text: initialValue);
    
    Get.defaultDialog(
      title: 'Edit $field',
      content: TextField(
        controller: controller,
        keyboardType: field == 'Medical History' ? TextInputType.multiline : TextInputType.number,
        decoration: InputDecoration(hintText: hint),
        maxLines: maxLines,
      ),
      textConfirm: 'Save',
      textCancel: 'Cancel',
      onConfirm: () async {
        final value = controller.text;
        if (value.isNotEmpty) {
          if (field != 'Medical History') {
            final numValue = double.tryParse(value);
            if (numValue == null || numValue <= 0) {
              Fluttertoast.showToast(msg: '$field must be greater than 0');
              return;
            }
          }
          await saveField(field, value);
          Get.back();
        }
      },
    );
  }

  Future<void> saveField(String field, String value) async {
    try {
      final db = Get.find<HealthGuardDB>().database;
      final result = await db.query('user_info', limit: 1);

      Map<String, dynamic> data = {
        'age': age.value,
        'height': height.value,
        'weight': weight.value,
        'medical_history': medicalHistory.value,
        'created_at': DateTime.now().toIso8601String(),
      };

      switch (field) {
        case 'Age':
          age.value = int.tryParse(value) ?? age.value;
          data['age'] = age.value;
          break;
        case 'Height':
          final heightValue = double.tryParse(value);
          if (heightValue != null) {
            height.value = double.parse(heightValue.toStringAsFixed(1));
          }
          data['height'] = height.value;
          break;
        case 'Weight':
          final weightValue = double.tryParse(value);
          if (weightValue != null) {
            weight.value = double.parse(weightValue.toStringAsFixed(1));
          }
          data['weight'] = weight.value;
          break;
        case 'Medical History':
          medicalHistory.value = value;
          data['medical_history'] = medicalHistory.value;
          break;
      }

      if (result.isEmpty) {
        await db.insert('user_info', data);
      } else {
        await db.update(
          'user_info',
          data,
          where: 'id = ?',
          whereArgs: [result.first['id']],
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save information');
    }
  }

  Future<void> loadHealthStats() async {
    try {
      final db = Get.find<HealthGuardDB>().database;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      bloodSugarDays.value = await _calculateConsecutiveDays('blood_sugar', today);
      bloodPressureDays.value = await _calculateConsecutiveDays('blood_pressure', today);
      heartRateDays.value = await _calculateConsecutiveDays('heart_rate', today);
      
      await loadCheckInDays();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load health statistics');
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

      checkInDays.value = days;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load check-in data');
    }
  }

  Future<int> _calculateConsecutiveDays(String tableName, DateTime today) async {
    try {
      final db = Get.find<HealthGuardDB>().database;
      final result = await db.query(
        tableName,
        orderBy: 'created_at DESC',
        limit: 100,
      );

      if (result.isEmpty) return 0;

      int consecutiveDays = 0;
      DateTime checkDate = today;

      for (var record in result) {
        final recordDate = DateTime.parse(record['created_at'] as String);
        final recordDay = DateTime(recordDate.year, recordDate.month, recordDate.day);

        if (recordDay.isAtSameMomentAs(checkDate)) {
          consecutiveDays++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else if (recordDay.isBefore(checkDate)) {
          break;
        }
      }

      return consecutiveDays;
    } catch (e) {
      return 0;
    }
  }

  Future<void> onCheckIn() async {
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

  void onGoalCardTap(String type) {
    if (type == 'Daily Check-in') {
      onCheckIn();
    } else {
      String historyType = '';
      switch (type) {
        case 'Blood Sugar':
          historyType = 'blood_sugar';
          break;
        case 'Blood Pressure':
          historyType = 'blood_pressure';
          break;
        case 'Heart Rate':
          historyType = 'heart_rate';
          break;
      }
      if (historyType.isNotEmpty) {
        Get.toNamed('/health_guard_history', arguments: {'type': historyType});
      }
    }
  }
}
