import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'health_guard_recipe_detail_logic.dart';
import '../../main.dart';

class HealthGuardRecipeDetailPage extends GetView<HealthGuardRecipeDetailLogic> {
  const HealthGuardRecipeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:  true,
      appBar: AppBar(
        title: Obx(() => Text(
          controller.recipeName.value,
          overflow: TextOverflow.ellipsis,
        )),
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
          bottom:  false,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Obx(() => Column(
                children: [
                  _buildSection(Icons.spa, 'Benefits', controller.benefits.value, const Color(0xFF5FC970)),
                  _buildSection(Icons.shopping_basket, 'Ingredients', controller.ingredients.value, const Color(0xFFFF9A9E)),
                  _buildSection(Icons.restaurant_menu, 'Instructions', controller.instructions.value, const Color(0xFF4ECDC4)),
                  _buildTipCard(),
                  SizedBox(height: 16.h,)
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(IconData icon, String title, String content, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h,left: 16.w, right: 16.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 24.sp, color: color),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF333333),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            content,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF666666),
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F5E9), Color(0xFFF1F8F4)],
        ),
        borderRadius: BorderRadius.circular(16.w),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: primaryColor, size: 24.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'This recipe is suitable for regular consumption and helps maintain good health.',
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF666666),
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
