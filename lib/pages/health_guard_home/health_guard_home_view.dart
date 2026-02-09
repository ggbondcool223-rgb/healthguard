import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'health_guard_home_logic.dart';
import '../../main.dart';

class HealthGuardHomePage extends GetView<HealthGuardHomeLogic> {
  const HealthGuardHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Heart Rate Check'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgGradientStart, bgGradientEnd],
          ),
        ),
        child: Obx(() => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: SafeArea(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        _buildPersonalInfoCard(),
                        _buildBanner(),
                        _buildHealthMetrics(),
                        _buildCheckIn(),
                        _buildHealthKnowledge(),
                        _buildHealthAnalysis(),
                        SizedBox(height: 16.h)
                      ],
                    ),
                  ),
                ),
              )),
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return Obx(() => Container(
          margin: EdgeInsets.all(16.w),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primaryColor, const Color(0xFF4CAF50)],
            ),
            borderRadius: BorderRadius.circular(16.w),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Personal Info',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.onPersonalInfoTap,
                    child: Icon(Icons.edit, size: 14.sp, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  _buildInfoItem(
                      'Age',
                      (controller.userInfo.value?.age ?? 0) > 0
                          ? controller.userInfo.value?.age?.toString() ?? '--'
                          : '--'),
                  SizedBox(width: 10.w),
                  _buildInfoItem(
                      'Height',
                      (controller.userInfo.value?.height ?? 0) > 0
                          ? '${controller.userInfo.value?.height?.toStringAsFixed(1)} cm'
                          : '--'),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  _buildInfoItem(
                      'Weight',
                      (controller.userInfo.value?.weight ?? 0) > 0
                          ? '${controller.userInfo.value?.weight?.toStringAsFixed(1)} kg'
                          : '--'),
                  SizedBox(width: 10.w),
                  _buildInfoItem('Medical History',
                      controller.userInfo.value?.medicalHistory?.isNotEmpty == true
                          ? controller.userInfo.value?.medicalHistory ??
                          '--'
                          : '--'),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildInfoItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4FC3F7), Color(0xFF29B6F6)],
        ),
        borderRadius: BorderRadius.circular(16.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
                  'Heart Rate Check',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Camera Scan Detection',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: controller.onHeartRateDetectTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50.w),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Start',
                style: TextStyle(
                  color: const Color(0xFF29B6F6),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMetrics() {
    return Obx(() => Column(
          children: [
            _buildMetricCard(
              Icons.water_drop,
              'Blood Sugar',
              controller.latestBloodSugar.value?.value,
              'mmol/L',
              const Color(0xFFFF6B6B),
              controller.onBloodSugarTap,
              metricType: 'blood_sugar',
            ),
            _buildMetricCard(
              Icons.bloodtype,
              'Blood Pressure',
              null,
              'mmHg',
              const Color(0xFF4FC3F7),
              controller.onBloodPressureTap,
              metricType: 'blood_pressure',
              systolicValue: controller.latestBloodPressure.value?.systolic,
              diastolicValue: controller.latestBloodPressure.value?.diastolic,
            ),
            _buildMetricCard(
              Icons.monitor_heart,
              'Heart Rate',
              controller.latestHeartRate.value?.value.toDouble(),
              'bpm',
              const Color(0xFFFF6B9D),
              controller.onHeartRateTap,
              metricType: 'heart_rate',
            ),
          ],
        ));
  }

  String _getHealthStatusTip(
      String metricType, double? value, int? systolic, int? diastolic) {
    if (metricType == 'blood_sugar') {
      if (value == null) return 'No recent record, please add first';
      if (value < 3.9) return 'Low blood sugar, please pay attention';
      if (value >= 3.9 && value <= 6.1)
        return 'Your recent blood sugar status is good';
      return 'High blood sugar, please monitor';
    } else if (metricType == 'blood_pressure') {
      if (systolic == null || diastolic == null)
        return 'No recent record, please add first';
      if (systolic < 90 || diastolic < 60)
        return 'Low blood pressure, please pay attention';
      if (systolic >= 90 &&
          systolic <= 120 &&
          diastolic >= 60 &&
          diastolic <= 80) {
        return 'Your recent blood pressure is normal';
      }
      return 'High blood pressure, please monitor';
    } else if (metricType == 'heart_rate') {
      if (value == null) return 'No recent record, please add first';
      if (value < 60) return 'Low heart rate, please pay attention';
      if (value >= 60 && value <= 100)
        return 'Your recent heart rate is normal';
      return 'High heart rate, please pay attention';
    }
    return 'No recent record, please add first';
  }

  Widget _buildMetricCard(
    IconData icon,
    String title,
    double? value,
    String unit,
    Color color,
    VoidCallback onTap, {
    required String metricType,
    int? systolicValue,
    int? diastolicValue,
  }) {
    final systolic = systolicValue?.toString() ?? '--';
    final diastolic = diastolicValue?.toString() ?? '--';
    final displayValue = value != null
        ? (metricType == 'heart_rate'
            ? value.toInt().toString()
            : value.toStringAsFixed(1))
        : '--';
    final tip =
        _getHealthStatusTip(metricType, value, systolicValue, diastolicValue);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 24.sp, color: color),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF333333),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Text(
                  tip,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: const Color(0xFF999999),
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (metricType == 'blood_pressure')
                Expanded(
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: systolic,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF333333),
                                  ),
                                ),
                                TextSpan(
                                  text: ' ($unit)',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: const Color(0xFF999999),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Systolic',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF999999),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 32.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: diastolic,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF333333),
                                  ),
                                ),
                                TextSpan(
                                  text: ' ($unit)',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: const Color(0xFF999999),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Diastolic',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF999999),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              else
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: displayValue,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF333333),
                          ),
                        ),
                        TextSpan(
                          text: '  ($unit)',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF29B6F6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckIn() {
    return Obx(() => Container(
          margin:
              EdgeInsets.only(top: 8.w, bottom: 16.w, left: 16.w, right: 16.w),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Check In ${controller.consecutiveDays.value} Days',
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: controller.onCheckInMoreTap,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.w),
                          color: primaryColor),
                      child: Text(
                        'Check In',
                        style: TextStyle(fontSize: 12.sp, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(7, (index) => _buildDayItem(index)),
              ),
            ],
          ),
        ));
  }

  Widget _buildDayItem(int index) {
    final isChecked = index < controller.consecutiveDays.value;
    return Column(
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: isChecked ? primaryColor : const Color(0xFFE0E0E0),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isChecked
                ? Icon(Icons.check, color: Colors.white, size: 18.sp)
                : Text(
                    'Sign',
                    style: TextStyle(fontSize: 10.sp, color: Colors.black54),
                  ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Day ${index + 1}',
          style: TextStyle(fontSize: 10.sp, color: const Color(0xFF666666)),
        ),
      ],
    );
  }

  Widget _buildHealthKnowledge() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Health Knowledge',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: controller.onKnowledgeMoreTap,
                child: Text(
                  'View More',
                  style: TextStyle(fontSize: 12.sp, color: primaryColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 1.5,
            children: [
              _buildKnowledgeCard('High Blood Pressure Diet', 'Health Guide',
                  'hypertension_diet'),
              _buildKnowledgeCard('Hypertension Prevention',
                  'Scientific Prevention', 'hypertension_prevention'),
              _buildKnowledgeCard('Blood Sugar Measurement',
                  'Correct Monitoring', 'blood_sugar_measurement'),
              _buildKnowledgeCard('Exercise for High Risk',
                  'Scientific Exercise', 'exercise_high_risk'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKnowledgeCard(String title, String subtitle, String articleId) {
    return GestureDetector(
      onTap: () => controller.onKnowledgeCardTap(articleId),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11.sp, color: const Color(0xFF999999)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthAnalysis() {
    return Obx(() => Container(
          margin: EdgeInsets.all(16.w),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Health Statistics',
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: controller.onAnalysisTap,
                    child: Text(
                      'View Details',
                      style: TextStyle(fontSize: 12.sp, color: primaryColor),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAnalysisItem(
                    controller.bloodPressureCount.value,
                    'Blood Pressure',
                    const Color(0xFFFF6B6B),
                  ),
                  _buildAnalysisItem(
                    controller.bloodSugarCount.value,
                    'Blood Sugar',
                    const Color(0xFF4ECDC4),
                  ),
                  _buildAnalysisItem(
                    controller.heartRateCount.value,
                    'Heart Rate',
                    const Color(0xFFFF6B9D),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildAnalysisItem(int count, String label, Color color) {
    return Column(
      children: [
        Text(
          '$count Days',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: const Color(0xFF666666)),
        ),
      ],
    );
  }
}
