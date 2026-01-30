import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'health_guard_history_logic.dart';
import '../../main.dart';

class HealthGuardHistoryPage extends GetView<HealthGuardHistoryLogic> {
  const HealthGuardHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(controller.getPageTitle()),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgGradientStart, bgGradientEnd],
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SafeArea(
              bottom: false,
              child: Obx(() => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : controller.allRecords.isEmpty
                      ? Center(
                          child: Text(
                            'No Records',
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF999999)),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          itemCount: controller.allRecords.length,
                          itemBuilder: (context, index) {
                            final record = controller.allRecords[index];
                            return _buildRecordCard(record);
                          },
                        ))),
        ),
      ),
    );
  }

  Widget _buildRecordCard(Map<String, dynamic> record) {
    final isWarning = record['status'] == 'High Risk' ||
        record['status'] == 'Slightly High' ||
        record['status'] == 'Low Blood Sugar' ||
        record['status'] == 'Low Heart Rate' ||
        record['status'] == 'High Heart Rate';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isWarning
              ? [const Color(0xFFFFF5E6), const Color(0xFFFFFAF0)]
              : [const Color(0xFFE8F5E9), const Color(0xFFF1F8F4)],
        ),
        borderRadius: BorderRadius.circular(16.w),
        border: Border(
          left: BorderSide(
            color: isWarning ? const Color(0xFFFFA726) : primaryColor,
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record['status'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isWarning ? const Color(0xFFFFA726) : primaryColor,
                  ),
                ),
                SizedBox(height: 8.h),
                if (record['type'] == 'blood_pressure')
                  _buildBloodPressureValue(record['value'], isWarning)
                else
                  Text(
                    record['value'],
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: isWarning ? const Color(0xFFFFA726) : primaryColor,
                    ),
                  ),
                SizedBox(height: 4.h),
                Text(
                  DateFormat('yyyy/MM/dd HH:mm')
                      .format(DateTime.parse(record['created_at'])),
                  style: TextStyle(
                      fontSize: 12.sp, color: const Color(0xFF999999)),
                ),
              ],
            ),
          ),
          Icon(
            _getIconForType(record['type']),
            size: 32.sp,
            color: isWarning
                ? const Color(0xFFFFA726).withOpacity(0.3)
                : primaryColor.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildBloodPressureValue(String value, bool isWarning) {
    final parts = value.split('/');
    if (parts.length != 2) {
      return Text(
        value,
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          color: isWarning ? const Color(0xFFFFA726) : primaryColor,
        ),
      );
    }
    
    final systolic = parts[0].trim();
    final diastolicWithUnit = parts[1].trim();
    final diastolic = diastolicWithUnit.replaceAll(' mmHg', '');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Systolic: ',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF666666),
              ),
            ),
            Text(
              systolic,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: isWarning ? const Color(0xFFFFA726) : primaryColor,
              ),
            ),
            Text(
              ' mmHg',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF666666),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Text(
              'Diastolic: ',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF666666),
              ),
            ),
            Text(
              diastolic,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: isWarning ? const Color(0xFFFFA726) : primaryColor,
              ),
            ),
            Text(
              ' mmHg',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF666666),
              ),
            ),
          ],
        ),
      ],
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'blood_sugar':
        return Icons.water_drop;
      case 'blood_pressure':
        return Icons.bloodtype;
      case 'heart_rate':
        return Icons.monitor_heart;
      default:
        return Icons.healing;
    }
  }
}
