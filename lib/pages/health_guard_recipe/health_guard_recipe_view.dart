import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'health_guard_recipe_logic.dart';
import '../../main.dart';

class HealthGuardRecipePage extends GetView<HealthGuardRecipeLogic> {
  const HealthGuardRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Health Recipe'),
        automaticallyImplyLeading: false,
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
                  _buildSolarTermSection(),
                  SizedBox(height: 16.h),
                  _buildCategoryTabs(),
                  Obx(() => ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(16.w),
                        itemCount: controller.recipes.length,
                        itemBuilder: (context, index) {
                          final recipe = controller.recipes[index];
                          return _buildRecipeCard(recipe);
                        },
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSolarTermSection() {
    return Obx(() {
      if (controller.monthsData.isEmpty) {
        return const SizedBox.shrink();
      }

      final now = DateTime.now();
      final currentYear = now.year;
      const totalPages = 10000;
      final initialPage = totalPages ~/ 2 + controller.currentMonthIndex.value;

      return Container(
        height: 210.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: PageView.builder(
          itemCount: totalPages,
          controller: PageController(
            initialPage: initialPage,
            viewportFraction: 0.92,
          ),
          onPageChanged: (virtualIndex) {
            final offsetFromCenter = virtualIndex - (totalPages ~/ 2);
            final adjustedIndex = offsetFromCenter + now.month - 1;
            final realIndex = adjustedIndex % 12;
            final normalizedIndex = realIndex < 0 ? realIndex + 12 : realIndex;
            controller.onMonthChanged(normalizedIndex, currentYear);
          },
          itemBuilder: (context, virtualIndex) {
            return _buildMonthCard(virtualIndex, totalPages, currentYear);
          },
        ),
      );
    });
  }

  Widget _buildMonthCard(int virtualIndex, int totalPages, int currentYear) {
    return Obx(() {
      final offsetFromCenter = virtualIndex - (totalPages ~/ 2);
      final now = DateTime.now();
      final adjustedIndex = offsetFromCenter + now.month - 1;
      final realIndex = adjustedIndex % 12;
      final normalizedIndex = realIndex < 0 ? realIndex + 12 : realIndex;

      final isActive = controller.currentMonthIndex.value == normalizedIndex;
      final data = controller.monthsData[normalizedIndex];

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: isActive ? 0 : 12.h,
        ),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isActive
                ? [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)]
                : [const Color(0xFFF5F5F5), const Color(0xFFE0E0E0)],
          ),
          borderRadius: BorderRadius.circular(16.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isActive ? 0.12 : 0.06),
              blurRadius: isActive ? 12 : 6,
              offset: Offset(0, isActive ? 4 : 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['name'] ?? '',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: isActive
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFF757575),
              ),
            ),
            SizedBox(height: 12.h),
            if (isActive)
              Expanded(
                child: controller.monthlyRecipes.isEmpty
                    ? Center(
                        child: Text(
                          'No recipes available',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF757575),
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.w,
                          mainAxisSpacing: 8.h,
                          childAspectRatio: 2.2,
                        ),
                        itemCount: controller.monthlyRecipes.length,
                        itemBuilder: (context, recipeIndex) {
                          final recipe = controller.monthlyRecipes[recipeIndex];
                          return _buildMonthlyRecipeItem(recipe);
                        },
                      ),
              ),
            if (!isActive)
              Expanded(
                child: Center(
                  child: Icon(
                    Icons.swipe,
                    size: 48.sp,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildMonthlyRecipeItem(Map<String, dynamic> recipe) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        '/health_guard_recipe_detail',
        arguments: recipe,
      ),
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8.w),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              recipe['name'] as String,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF333333),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    recipe['benefits'] as String,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFF666666),

                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )),
                  SizedBox(width: 4.w,),
                  Icon(Icons.arrow_forward_ios_rounded,size: 12.sp,color: Colors.grey,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final categories = ['Home Cooking', 'Porridge', 'Soup', 'Tea', 'Tonic'];

    return Container(
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Obx(() {
            final isActive = controller.selectedCategory.value ==
                controller.categoryMap[category];
            return GestureDetector(
              onTap: () => controller.onCategoryChanged(category),
              child: Container(
                margin: EdgeInsets.only(right: 8.w),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: isActive
                      ? LinearGradient(
                          colors: [primaryColor, const Color(0xFF4CAF50)])
                      : null,
                  color: isActive ? null : Colors.white,
                  borderRadius: BorderRadius.circular(50.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isActive ? Colors.white : const Color(0xFF666666),
                      fontSize: 14.sp,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildRecipeCard(Map<String, dynamic> recipe) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        '/health_guard_recipe_detail',
        arguments: recipe,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe['name'] as String,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF333333),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Benifits:',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
            Text(
              recipe['benefits'] as String,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
