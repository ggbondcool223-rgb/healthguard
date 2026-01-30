import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'health_guard_tab_logic.dart';
import '../../main.dart';

class HealthGuardTabPage extends GetView<HealthGuardTabLogic> {
  const HealthGuardTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: controller.pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.black.withOpacity(0.1),
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                controller.tabItems.length,
                (index) => _buildTabItem(index),
              ),
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildTabItem(int index) {
    final isActive = controller.currentIndex.value == index;
    final item = controller.tabItems[index];
    
    return GestureDetector(
      onTap: () => controller.onTabTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item['icon'],
              size: 24.sp,
              color: isActive ? primaryColor : const Color(0xFF8E8E93),
            ),
            SizedBox(height: 4.h),
            Text(
              item['label'],
              style: TextStyle(
                fontSize: 10.sp,
                color: isActive ? primaryColor : const Color(0xFF8E8E93),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
