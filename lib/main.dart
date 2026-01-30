import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:health_guard/pages/health_guard_recipe/health_guard_recipe_watch.dart';
import 'package:health_guard/pages/health_guard_tidy/health_guard_tidy_binding.dart';
import 'package:health_guard/pages/health_guard_tidy/health_guard_tidy_view.dart';
import '../pages/health_guard_tab/health_guard_tab_view.dart';
import '../pages/health_guard_tab/health_guard_tab_binding.dart';
import '../pages/health_guard_home/health_guard_home_view.dart';
import '../pages/health_guard_home/health_guard_home_binding.dart';
import '../pages/health_guard_knowledge/health_guard_knowledge_view.dart';
import '../pages/health_guard_knowledge/health_guard_knowledge_binding.dart';
import '../pages/health_guard_recipe/health_guard_recipe_view.dart';
import '../pages/health_guard_recipe/health_guard_recipe_binding.dart';
import '../pages/health_guard_profile/health_guard_profile_view.dart';
import '../pages/health_guard_profile/health_guard_profile_binding.dart';
import '../pages/health_guard_heart_rate_detect/health_guard_heart_rate_detect_view.dart';
import '../pages/health_guard_heart_rate_detect/health_guard_heart_rate_detect_binding.dart';
import '../pages/health_guard_blood_sugar/health_guard_blood_sugar_view.dart';
import '../pages/health_guard_blood_sugar/health_guard_blood_sugar_binding.dart';
import '../pages/health_guard_blood_pressure/health_guard_blood_pressure_view.dart';
import '../pages/health_guard_blood_pressure/health_guard_blood_pressure_binding.dart';
import '../pages/health_guard_heart_rate/health_guard_heart_rate_view.dart';
import '../pages/health_guard_heart_rate/health_guard_heart_rate_binding.dart';
import '../pages/health_guard_health_analysis/health_guard_health_analysis_view.dart';
import '../pages/health_guard_health_analysis/health_guard_health_analysis_binding.dart';
import '../pages/health_guard_history/health_guard_history_view.dart';
import '../pages/health_guard_history/health_guard_history_binding.dart';
import '../pages/health_guard_chronic_disease/health_guard_chronic_disease_view.dart';
import '../pages/health_guard_chronic_disease/health_guard_chronic_disease_binding.dart';
import '../pages/health_guard_recipe_detail/health_guard_recipe_detail_view.dart';
import '../pages/health_guard_recipe_detail/health_guard_recipe_detail_binding.dart';
import '../pages/health_guard_personal_info/health_guard_personal_info_view.dart';
import '../pages/health_guard_personal_info/health_guard_personal_info_binding.dart';
import '../pages/health_guard_article_detail/health_guard_article_detail_view.dart';
import '../pages/health_guard_article_detail/health_guard_article_detail_binding.dart';
import '../pages/health_guard_health_report/health_guard_health_report_view.dart';
import '../pages/health_guard_health_report/health_guard_health_report_binding.dart';
import '../pages/health_guard_knowledge_detail/health_guard_knowledge_detail_view.dart';
import '../pages/health_guard_knowledge_detail/health_guard_knowledge_detail_binding.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'db_health_guard/data.dart';

Color primaryColor = const Color(0xFF5FC970);
Color bgColor = const Color(0xFFF7F7F7);
Color bgGradientStart = const Color(0xFF7CC7FA);
Color bgGradientEnd = const Color(0xFFFFFFFF);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Get.putAsync(() => HealthGuardDB().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          title: 'Health Guard',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: primaryColor,
            scaffoldBackgroundColor: bgColor,
            appBarTheme: const AppBarTheme(
              elevation: 0,
              scrolledUnderElevation: 0,
              foregroundColor: Colors.white,
              centerTitle: true,
              backgroundColor: Colors.transparent,
            ),
          ),
          initialRoute: '/',
          getPages: Guards,
        );
      },
    );
  }
}
List<GetPage<dynamic>> Guards = [
  GetPage(
    name: '/',
    page: () => const HealthGuardTidyView(),
    binding: HealthGuardTidyBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/health_guard_tab',
    page: () => const HealthGuardTabPage(),
    binding: HealthGuardTabBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/health_guard_home',
    page: () => const HealthGuardHomePage(),
    binding: HealthGuardHomeBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/health_guard_knowledge',
    page: () => const HealthGuardKnowledgePage(),
    binding: HealthGuardKnowledgeBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/health_guard_recipe',
    page: () => const HealthGuardRecipePage(),
    binding: HealthGuardRecipeBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/health_guard_watch',
    page: () => const HealthGuardRecipeWatch(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/health_guard_profile',
    page: () => const HealthGuardProfilePage(),
    binding: HealthGuardProfileBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/health_guard_heart_rate_detect',
    page: () => const HealthGuardHeartRateDetectPage(),
    binding: HealthGuardHeartRateDetectBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/health_guard_blood_sugar',
    page: () => const HealthGuardBloodSugarPage(),
    binding: HealthGuardBloodSugarBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/health_guard_blood_pressure',
    page: () => const HealthGuardBloodPressurePage(),
    binding: HealthGuardBloodPressureBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/health_guard_heart_rate',
    page: () => const HealthGuardHeartRatePage(),
    binding: HealthGuardHeartRateBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/health_guard_health_analysis',
    page: () => const HealthGuardHealthAnalysisPage(),
    binding: HealthGuardHealthAnalysisBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/health_guard_history',
    page: () => const HealthGuardHistoryPage(),
    binding: HealthGuardHistoryBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/health_guard_chronic_disease',
    page: () => const HealthGuardChronicDiseasePage(),
    binding: HealthGuardChronicDiseaseBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/health_guard_recipe_detail',
    page: () => const HealthGuardRecipeDetailPage(),
    binding: HealthGuardRecipeDetailBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/health_guard_personal_info',
    page: () => const HealthGuardPersonalInfoPage(),
    binding: HealthGuardPersonalInfoBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/health_guard_article_detail',
    page: () => const HealthGuardArticleDetailPage(),
    binding: HealthGuardArticleDetailBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/health_guard_health_report',
    page: () => const HealthGuardHealthReportPage(),
    binding: HealthGuardHealthReportBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/health_guard_knowledge_detail',
    page: () => const HealthGuardKnowledgeDetailPage(),
    binding: HealthGuardKnowledgeDetailBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
];