import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'health_guard_profile_logic.dart';
import '../../main.dart';

class HealthGuardProfilePage extends GetView<HealthGuardProfileLogic> {
  const HealthGuardProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
              onPressed: () =>
                  Get.toNamed('/health_guard_personal_info'),
              icon: Icon(Icons.edit_rounded, color: Colors.white, size: 20.sp))
        ],
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
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildStats(),
                  _buildMenu(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              _buildStatCard(Icons.water_drop, 'Blood Sugar Records',
                  controller.bloodSugarCount.value, const Color(0xFFFF6B6B)),
              SizedBox(width: 12.w),
              _buildStatCard(Icons.bloodtype, 'Blood Pressure Records',
                  controller.bloodPressureCount.value, const Color(0xFF4FC3F7)),
              SizedBox(width: 12.w),
              _buildStatCard(Icons.monitor_heart, 'Heart Rate Records',
                  controller.heartRateCount.value, const Color(0xFFFF6B9D)),
            ],
          ),
        ));
  }

  Widget _buildStatCard(IconData icon, String label, int count, Color color) {
    return Expanded(
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
          children: [
            Icon(icon, size: 32.sp, color: color),
            SizedBox(height: 12.h),
            Text(
              label,
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF666666)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu() {
    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.w),
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
          _buildMenuItem(Icons.cleaning_services_sharp, 'Clean all data', controller.onCleanAllData),
          Obx(() {
            return _buildMenuItem(Icons.info, 'App Version', () {},
                showDivider: false, subLabel: controller.appVersion.value);
          }),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap,
      {bool showDivider = true, String subLabel = ''}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  alignment: Alignment.center,
                  child: Icon(icon, size: 18.sp, color: primaryColor),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                        fontSize: 15.sp, color: const Color(0xFF333333)),
                  ),
                ),
                subLabel.isEmpty
                    ? Icon(Icons.chevron_right,
                        size: 20.sp, color: const Color(0xFFC0C0C0))
                    : Text(
                        subLabel,
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
              height: 1,
              indent: 60.w,
              endIndent: 20.w,
              color: const Color(0xFFF0F0F0)),
      ],
    );
  }
}
