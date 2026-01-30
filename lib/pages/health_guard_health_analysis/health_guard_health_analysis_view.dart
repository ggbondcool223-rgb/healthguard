import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';

import 'health_guard_health_analysis_logic.dart';
import '../../main.dart';

class HealthGuardHealthAnalysisPage
    extends GetView<HealthGuardHealthAnalysisLogic> {
  const HealthGuardHealthAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Health Analysis'),
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
          bottom: false,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Obx(() => Column(
                    children: [
                      _buildSection(
                          Icon(
                            Icons.water_drop,
                            color: const Color(0xFFFF6B6B),
                          ),
                          'Blood Sugar',
                          controller.bloodSugarData,
                          controller.bloodSugarDates,
                          const Color(0xFFFF6B6B),
                          'blood_sugar'),
                      _buildBloodPressureSection(),
                      _buildSection(
                          Icon(
                            Icons.monitor_heart,
                            color: const Color(0xFFFF6B9D),
                          ),
                          'Heart Rate',
                          controller.heartRateData,
                          controller.heartRateDates,
                          const Color(0xFFFF6B9D),
                          'heart_rate'),
                      _buildAnalysisButton(),
                      SizedBox(height: 40.h),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    Icon icon,
    String title,
    List<double> data,
    List<String> dates,
    Color color,
    String historyType,
  ) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  icon,
                  SizedBox(width: 8.w),
                  Text(
                    title,
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed('/health_guard_history', arguments: {'type': historyType});
                },
                child: Text(
                  'View All',
                  style: TextStyle(fontSize: 12.sp, color: primaryColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (data.isEmpty)
            Container(
              height: 200.h,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 48.sp, color: Colors.grey),
                  SizedBox(height: 12.h),
                  Text(
                    'No data available',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                ],
              ),
            )
          else
            Column(
              children: [
                SizedBox(
                  height: 200.h,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true, drawVerticalLine: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              final i = value.toInt();
                              if (i >= 0 && i < dates.length) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 8.h),
                                  child: Text(
                                    dates[i],
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: const Color(0xFF666666),
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          left: BorderSide(color: Colors.grey.shade300, width: 1),
                          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                      ),
                      minX: 0,
                      maxX: (data.length - 1).toDouble(),
                      lineBarsData: [
                        LineChartBarData(
                          spots: data
                              .asMap()
                              .entries
                              .map((e) => FlSpot(e.key.toDouble(), e.value))
                              .toList(),
                          isCurved: true,
                          color: color,
                          barWidth: 3,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: color.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                _buildLegend(title, color),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildBloodPressureSection() {
    return Obx(() {
      final systolic = controller.bloodPressureSystolic;
      final diastolic = controller.bloodPressureDiastolic;
      final dates = controller.bloodPressureDates;
      final isEmpty = systolic.isEmpty && diastolic.isEmpty;
      return Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.bloodtype, color: const Color(0xFF4FC3F7)),
                    SizedBox(width: 8.w),
                    Text(
                      'Blood Pressure',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/health_guard_history', arguments: {'type': 'blood_pressure'});
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(fontSize: 12.sp, color: primaryColor),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (isEmpty)
              Container(
                height: 200.h,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 48.sp, color: Colors.grey),
                    SizedBox(height: 12.h),
                    Text(
                      'No data available',
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  SizedBox(
                    height: 200.h,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true, drawVerticalLine: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                final i = value.toInt();
                                if (i >= 0 && i < dates.length) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 8.h),
                                    child: Text(
                                      dates[i],
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: const Color(0xFF666666),
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border(
                            left: BorderSide(color: Colors.grey.shade300, width: 1),
                            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                          ),
                        ),
                        minX: 0,
                        maxX: (dates.length - 1).toDouble(),
                        lineBarsData: [
                          LineChartBarData(
                            spots: systolic
                                .asMap()
                                .entries
                                .map((e) => FlSpot(e.key.toDouble(), e.value))
                                .toList(),
                            isCurved: true,
                            color: const Color(0xFFE53935),
                            barWidth: 2.5,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(show: false),
                          ),
                          LineChartBarData(
                            spots: diastolic
                                .asMap()
                                .entries
                                .map((e) => FlSpot(e.key.toDouble(), e.value))
                                .toList(),
                            isCurved: true,
                            color: const Color(0xFF1E88E5),
                            barWidth: 2.5,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildBloodPressureLegend(),
                ],
              ),
          ],
        ),
      );
    });
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 16.w,
          height: 16.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.w),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF666666),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBloodPressureLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 16.w,
          height: 16.w,
          decoration: BoxDecoration(
            color: const Color(0xFFE53935),
            borderRadius: BorderRadius.circular(4.w),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          'Systolic',
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF666666),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 20.w),
        Container(
          width: 16.w,
          height: 16.w,
          decoration: BoxDecoration(
            color: const Color(0xFF1E88E5),
            borderRadius: BorderRadius.circular(4.w),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          'Diastolic',
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF666666),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisButton() {
    return Container(
      margin: EdgeInsets.all(16.w),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Get.toNamed('/health_guard_health_report');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.w),
          ),
          elevation: 4,
          shadowColor: primaryColor.withOpacity(0.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              'View Health Analysis Report',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
