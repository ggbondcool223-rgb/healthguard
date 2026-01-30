import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'health_guard_health_report_logic.dart';
import '../../main.dart';

class HealthGuardHealthReportPage extends GetView<HealthGuardHealthReportLogic> {
  const HealthGuardHealthReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Health Analysis Report'),
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
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      _buildBloodPressureSection(),
                      SizedBox(height: 16.h),
                      _buildBloodSugarSection(),
                      SizedBox(height: 16.h),
                      _buildHeartRateSection(),
                      SizedBox(height: 20.h),
                      _buildReminder(),
                      SizedBox(height: 40.h),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4FC3F7), Color(0xFF29B6F6)],
        ),
        borderRadius: BorderRadius.circular(16.w),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4FC3F7).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.assignment, size: 48.sp, color: Colors.white),
          SizedBox(height: 12.h),
          Text(
            'Please check your health analysis report',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBloodPressureSection() {
    final avgSys = controller.avgBloodPressureSystolic.value;
    final avgDia = controller.avgBloodPressureDiastolic.value;
    final status = controller.bloodPressureStatus.value;
    final dataCount = controller.bpDataCount.value;
    
    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Blood Pressure',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Text(
                  status == 'healthy' ? ' is very healthy, please keep it up!' : ' has fluctuations',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: status == 'healthy' ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8.w),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Last 7 Days Average',
                      style: TextStyle(fontSize: 12.sp, color: const Color(0xFF999999)),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${avgSys.toStringAsFixed(1)} / ${avgDia.toStringAsFixed(1)} mmHg',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  child: Text(
                    '$dataCount records',
                    style: TextStyle(fontSize: 12.sp, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            '  Stable blood pressure is one of the indicators of human health, and maintaining blood pressure stability is very important. In mild cases, large fluctuations in blood pressure can cause discomfort, leading to insufficient blood supply to the brain, hypoxia, dizziness and other symptoms. In severe cases, if hypertensive patients have large blood pressure fluctuations, it will lead to coronary heart disease, myocardial infarction, cerebral infarction, and cardiovascular and cerebrovascular diseases.',
            style: TextStyle(fontSize: 13.sp, height: 1.6, color: const Color(0xFF666666)),
          ),
          SizedBox(height: 12.h),
          Text(
            '  Blood pressure health requires us to maintain good eating habits, good work and rest habits, good emotions, and appropriate exercise.',
            style: TextStyle(fontSize: 13.sp, height: 1.6, color: const Color(0xFF666666)),
          ),
          SizedBox(height: 12.h),
          _buildAdviceItem('1. Maintain good eating habits'),
          _buildAdviceText(
              'Patients need to pay attention to maintaining a light diet in daily life, avoid eating greasy, spicy and irritating foods, and can eat vegetables and fruits rich in vitamins, such as apples, persimmons, bananas, etc. At the same time, it is also necessary to avoid smoking and drinking, so as not to cause unstable blood pressure and cause discomfort symptoms such as dizziness and headache.'),
          _buildAdviceItem('2. Maintain good work and rest habits'),
          _buildAdviceText(
              'Patients need to pay attention to maintaining good work and rest habits in daily life, and avoid staying up late, so as not to cause endocrine disorders in the body, which will lead to an increase in blood pressure. It is recommended that patients drink warm water after waking up to supplement the water needed by the body, promote blood circulation, and improve the situation of elevated blood pressure.'),
          _buildAdviceItem('3. Maintain good emotions'),
          _buildAdviceText(
              'Patients also need to maintain good emotions in daily life, and avoid excessive tension and anxiety, so as not to cause sympathetic nerve excitement and cause elevated blood pressure. It is recommended that patients can do outdoor exercises such as mountain climbing and swimming, which will help relieve stress and maintain stable blood pressure.'),
          _buildAdviceItem('4. Appropriate exercise'),
          _buildAdviceText(
              'Patients can also do appropriate exercises in daily life, such as walking slowly or briskly, which can promote blood circulation in the body and can also help reduce blood pressure to a certain extent.'),
        ],
      ),
    );
  }

  Widget _buildBloodSugarSection() {
    final avgValue = controller.avgBloodSugar.value;
    final status = controller.bloodSugarStatus.value;
    final dataCount = controller.bsDataCount.value;
    
    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Blood Sugar',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Text(
                  status == 'healthy' ? ' is normal' : ' has fluctuations',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: status == 'healthy' ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8.w),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Last 7 Days Average',
                      style: TextStyle(fontSize: 12.sp, color: const Color(0xFF999999)),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${avgValue.toStringAsFixed(1)} mmol/L',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  child: Text(
                    '$dataCount records',
                    style: TextStyle(fontSize: 12.sp, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            '  Blood sugar fluctuations may cause symptoms such as dizziness, nausea, vomiting, and thirst. Timely treatment is needed to avoid aggravation of symptoms.',
            style: TextStyle(fontSize: 13.sp, height: 1.6, color: const Color(0xFF666666)),
          ),
          SizedBox(height: 8.h),
          _buildAdviceItem('1. Dizziness:'),
          _buildAdviceText(
              'The difference between the highest and lowest blood sugar levels in the human body during the day should not be too large, which may cause blood sugar fluctuations, leading to dizziness and affecting sleep quality.'),
          _buildAdviceItem('2. Nausea and vomiting:'),
          _buildAdviceText('When blood sugar rises, it may cause respiratory reactions, leading to nausea and vomiting, and dietary adjustments need to be made.'),
          _buildAdviceItem('3. Thirst:'),
          _buildAdviceText(
              'Blood sugar fluctuations may cause symptoms of thirst and frequent urination when blood sugar rises. You need to seek medical attention in time. With the help of doctors, you can effectively improve symptoms by taking metformin hydrochloride tablets, acarbose tablets, etc.'),
          SizedBox(height: 8.h),
          Text(
            'In addition, symptoms such as palpitations, sweating, and blurred vision may occur, and blood sugar levels need to be measured regularly.',
            style: TextStyle(fontSize: 13.sp, height: 1.6, color: const Color(0xFF666666)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeartRateSection() {
    final avgValue = controller.avgHeartRate.value;
    final status = controller.heartRateStatus.value;
    final dataCount = controller.hrDataCount.value;
    
    return Container(
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
          Text(
            'Heart Rate Record',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8.w),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Last 7 Days Average',
                      style: TextStyle(fontSize: 12.sp, color: const Color(0xFF999999)),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${avgValue.toStringAsFixed(0)} bpm',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.pink.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  child: Text(
                    '$dataCount records',
                    style: TextStyle(fontSize: 12.sp, color: Colors.pink),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Please record your latest heart rate value to help us analyze your heart rate.',
            style: TextStyle(fontSize: 13.sp, height: 1.6, color: const Color(0xFF666666)),
          ),
          SizedBox(height: 8.h),
          Text(
            'Heart rate refers to the number of heartbeats per minute in a normal person in a quiet state, also called resting heart rate, generally 60~100 beats/minute, which may vary due to age, gender or other physiological factors. Generally speaking, the younger the age, the faster the heart rate. The elderly have slower heartbeats than young people, and women have faster heart rates than men of the same age. These are all normal physiological phenomena.',
            style: TextStyle(fontSize: 13.sp, height: 1.6, color: const Color(0xFF666666)),
          ),
        ],
      ),
    );
  }

  Widget _buildReminder() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(16.w),
        border: Border.all(color: const Color(0xFFFFB74D), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: const Color(0xFFFF9800), size: 24.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'The above data is for reference only. Please consult a professional doctor for specific health conditions. It is recommended to have regular physical examinations and maintain a healthy lifestyle.',
              style: TextStyle(
                fontSize: 13.sp,
                height: 1.5,
                color: const Color(0xFF666666),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdviceItem(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 4.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF333333),
        ),
      ),
    );
  }

  Widget _buildAdviceText(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13.sp,
          height: 1.6,
          color: const Color(0xFF666666),
        ),
      ),
    );
  }
}
