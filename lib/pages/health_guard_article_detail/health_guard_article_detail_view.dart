import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'health_guard_article_detail_logic.dart';
import '../../main.dart';

class HealthGuardArticleDetailPage extends GetView<HealthGuardArticleDetailLogic> {
  const HealthGuardArticleDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Obx(() => Text(
          controller.title.value,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 16.sp),
        )),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF64B5F6),
              const Color(0xFFBBDEFB),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(20.w),
              child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.title.value,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1565C0),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          controller.intro.value,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF424242),
                            height: 1.6,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Icon(
                        Icons.medical_services,
                        size: 64.sp,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  ...controller.guidelines.map((item) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${controller.guidelines.indexOf(item) + 1}. ',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1565C0),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF424242),
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                  SizedBox(height: 20.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                    child: Text(
                      controller.conclusion.value,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF424242),
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }
}
