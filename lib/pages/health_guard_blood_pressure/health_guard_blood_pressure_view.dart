import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'health_guard_blood_pressure_logic.dart';
import '../../main.dart';

class HealthGuardBloodPressurePage extends GetView<HealthGuardBloodPressureLogic> {
  const HealthGuardBloodPressurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Add Blood Pressure'),
        actions: [
          IconButton(
            onPressed: controller.onHistoryTap,
            icon: Icon(Icons.history, color: primaryColor),
          ),
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
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildDualPicker(),
                  _buildStatusCard(),
                  _buildSaveButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDualPicker() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  'Systolic',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8.h),
                Text('mmHg', style: TextStyle(fontSize: 12.sp, color: const Color(0xFF999999))),
                SizedBox(height: 16.h),
                SizedBox(
                  height: 200.h,
                  child: ListWheelScrollView.useDelegate(
                    controller: controller.systolicController,
                    itemExtent: 40.h,
                    perspective: 0.005,
                    diameterRatio: 1.2,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: controller.onSystolicChanged,
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: controller.systolicValues.length,
                      builder: (context, index) {
                        return Obx(() {
                          final isSelected = index == controller.selectedSystolic.value;
                          return Center(
                            child: Text(
                              controller.systolicValues[index].toString(),
                              style: TextStyle(
                                fontSize: isSelected ? 32.sp : 16.sp,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                                color: isSelected ? primaryColor : const Color(0xFFCCCCCC),
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 200.h,
            color: const Color(0xFFE0E0E0),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Diastolic',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8.h),
                Text('mmHg', style: TextStyle(fontSize: 12.sp, color: const Color(0xFF999999))),
                SizedBox(height: 16.h),
                SizedBox(
                  height: 200.h,
                  child: ListWheelScrollView.useDelegate(
                    controller: controller.diastolicController,
                    itemExtent: 40.h,
                    perspective: 0.005,
                    diameterRatio: 1.2,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: controller.onDiastolicChanged,
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: controller.diastolicValues.length,
                      builder: (context, index) {
                        return Obx(() {
                          final isSelected = index == controller.selectedDiastolic.value;
                          return Center(
                            child: Text(
                              controller.diastolicValues[index].toString(),
                              style: TextStyle(
                                fontSize: isSelected ? 32.sp : 16.sp,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                                color: isSelected ? primaryColor : const Color(0xFFCCCCCC),
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Obx(() => Container(
      margin: EdgeInsets.all(20.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F5E9), Color(0xFFF1F8F4)],
        ),
        borderRadius: BorderRadius.circular(16.w),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: primaryColor, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                controller.healthStatus.value,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            controller.healthAdvice.value,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF666666),
              height: 1.8,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ));
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: controller.onSaveTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, const Color(0xFF4CAF50)],
          ),
          borderRadius: BorderRadius.circular(50.w),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Save Data',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
