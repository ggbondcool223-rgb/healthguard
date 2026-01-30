import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heart_bpm/heart_bpm.dart';

import 'health_guard_heart_rate_detect_logic.dart';
import '../../main.dart';

class HealthGuardHeartRateDetectPage
    extends GetView<HealthGuardHeartRateDetectLogic> {
  const HealthGuardHeartRateDetectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Heart Rate Detection'),
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildInstructionCard(),
                _buildCameraView(context),
                _buildPulseAnimation(),
                _buildWaveform(),
                SizedBox(height: 30.h),
                _buildStartButton(),
                _buildDisclaimer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: primaryColor, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Place your finger on the back camera and flash',
              style: TextStyle(
                color: const Color(0xFF333333),
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraView(BuildContext context) {
    return Obx(() => controller.isDetecting.value
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            height: 100.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.w),
              child: HeartBPMDialog(
                cameraWidgetHeight: 100.w,
                cameraWidgetWidth: 100.w,
                context: context,
                onRawData: (value) {
                  controller.onRawData(value);
                },
                onBPM: (value) {
                  controller.onBPM(value);
                },
              ),
            ),
          )
        : const SizedBox());
  }

  Widget _buildPulseAnimation() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.h),
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Container(
            width: 150.w,
            height: 150.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Obx(() => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.monitor_heart,
                      size: controller.isDetecting.value ? 60.sp : 50.sp,
                      color:const Color(0xFFFF6B9D),
                    ),
                  )),
            ),
          ),
          SizedBox(height: 20.h),
          Obx(() => Text(
                controller.heartRate.value > 0
                    ? '${controller.heartRate.value} bpm'
                    : '--',
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.bold,
                  color: controller.isDetecting.value
                      ? Colors.red.shade400
                      : const Color(0xFF666666),
                ),
              )),
          SizedBox(height: 8.h),
          Obx(() => Text(
                controller.isDetecting.value
                    ? 'Measuring... (${controller.bpmValues.length} readings)'
                    : controller.heartRate.value > 0
                        ? _getHealthStatus(controller.heartRate.value)
                        : 'Press button to start',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF999999),
                ),
              )),
        ],
      ),
    );
  }

  String _getHealthStatus(int rate) {
    if (rate < 60) {
      return 'Low';
    } else if (rate >= 60 && rate <= 100) {
      return 'Normal';
    } else {
      return 'High';
    }
  }

  Widget _buildWaveform() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(16.w),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pulse Waveform',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
              Obx(() => Text(
                    controller.isDetecting.value
                        ? 'Real-time'
                        : controller.sensorValues.isNotEmpty
                            ? 'Last reading'
                            : 'Ready',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: controller.isDetecting.value
                          ? Colors.red.shade400
                          : const Color(0xFF999999),
                    ),
                  )),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            height: 120.h,
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(12.w),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.w),
              child: Obx(() {
                if (controller.sensorValues.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.graphic_eq,
                          size: 40.sp,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Waveform will appear here',
                          style: TextStyle(
                            color: const Color(0xFF999999),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return CustomPaint(
                  size: Size(double.infinity, 120.h),
                  painter: WaveformPainter(
                    controller.sensorValues
                        .map((e) => e.value.toDouble())
                        .toList(),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return Obx(() => GestureDetector(
          onTap: controller.onStartDetection,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: controller.isDetecting.value
                    ? [Colors.red.shade400, Colors.red.shade600]
                    : [primaryColor, const Color(0xFF4CAF50)],
              ),
              borderRadius: BorderRadius.circular(50.w),
              boxShadow: [
                BoxShadow(
                  color: (controller.isDetecting.value
                          ? Colors.red.shade400
                          : primaryColor)
                      .withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    controller.isDetecting.value
                        ? Icons.stop
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    controller.isDetecting.value
                        ? 'Stop & Save'
                        : 'Start Measurement',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildDisclaimer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Text(
        '*Non-medical professional equipment detection results are for reference only*\nBefore consulting with qualified medical personnel\nPlease do not use for self-diagnosis or treatment',
        style: TextStyle(
          fontSize: 11.sp,
          color: const Color(0xFF999999),
          height: 1.6,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final List<double> values;

  WaveformPainter(this.values);

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty || values.length < 2) return;

    final paint = Paint()
      ..color = Colors.red.shade400
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final backgroundPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.fill;

    // Draw background grid
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 0.5;

    for (int i = 0; i <= 4; i++) {
      final y = (size.height / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final path = Path();

    // Normalize values to fit the canvas height
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue;

    if (range == 0) return;

    final step = size.width / (values.length - 1);

    for (int i = 0; i < values.length; i++) {
      final x = i * step;
      final normalizedValue = (values[i] - minValue) / range;
      final y = size.height -
          (normalizedValue * size.height * 0.7) -
          (size.height * 0.15);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return true; // Always repaint for smooth animation
  }
}
