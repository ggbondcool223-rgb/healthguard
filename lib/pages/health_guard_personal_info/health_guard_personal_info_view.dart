import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'health_guard_personal_info_logic.dart';
import '../../main.dart';

class HealthGuardPersonalInfoPage extends GetView<HealthGuardPersonalInfoLogic> {
  const HealthGuardPersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Personal Information'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgGradientStart, bgGradientEnd],
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildInfoCard(),
                  _buildGoalsSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Obx(() => Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, const Color(0xFF4CAF50)],
        ),
        borderRadius: BorderRadius.circular(20.w),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 16,
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
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox()
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              _buildInfoItem('Age', controller.age.value > 0 ? controller.age.value.toString() : '--'),
              SizedBox(width: 12.w),
              _buildInfoItem('Height', controller.height.value > 0 ? '${controller.height.value.toStringAsFixed(1)} cm' : '--'),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildInfoItem('Weight', controller.weight.value > 0 ? '${controller.weight.value.toStringAsFixed(1)} kg' : '--'),
              SizedBox(width: 12.w),
              _buildInfoItem('Medical History', controller.medicalHistory.value.isEmpty ? '--' : controller.medicalHistory.value),
            ],
          ),
        ],
      ),
    ));
  }

  Widget _buildInfoItem(String label, String value) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.onEditField(label),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.keyboard_arrow_right_sharp, color: Colors.white.withOpacity(0.9), size: 14.sp),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsSection() {
    return Obx(() => Container(
      margin: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
            child: Text(
              'Daily Health Goals',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF333333),
              ),
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 1.2,
            children: [
              _buildGoalCard(Icons.calendar_today, 'Daily Check-in', '${controller.checkInDays.value} Days', const Color(0xFFFFB75E)),
              _buildGoalCard(Icons.water_drop, 'Blood Sugar', '${controller.bloodSugarDays.value} Days', const Color(0xFFFF6B6B)),
              _buildGoalCard(Icons.bloodtype, 'Blood Pressure', '${controller.bloodPressureDays.value} Days', const Color(0xFF4FC3F7)),
              _buildGoalCard(Icons.monitor_heart, 'Heart Rate', '${controller.heartRateDays.value} Days', const Color(0xFFFF6B9D)),
            ],
          ),
        ],
      ),
    ));
  }

  Widget _buildGoalCard(IconData icon, String label, String days, Color color) {
    return GestureDetector(
      onTap: () => controller.onGoalCardTap(label),
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36.sp, color: color),
            SizedBox(height: 12.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF333333),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  days,
                  style: TextStyle(fontSize: 12.sp, color: primaryColor, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 4.w),
                Icon(Icons.arrow_forward_ios, size: 10.sp, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
