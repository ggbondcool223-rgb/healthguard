import 'package:get/get.dart';

class HealthGuardArticleDetailLogic extends GetxController {
  final title = ''.obs;
  final intro = ''.obs;
  final guidelines = <String>[].obs;
  final conclusion = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final id = Get.parameters['id'] ?? Get.arguments as String? ?? 'hypertension_diet';
    _loadArticle(id);
  }

  void _loadArticle(String id) {
    final data = _articleContent[id] ?? _articleContent['hypertension_diet']!;
    title.value = data['title'] as String;
    intro.value = data['intro'] as String;
    guidelines.value = List<String>.from(data['guidelines'] as List);
    conclusion.value = data['conclusion'] as String;
  }

  static final Map<String, Map<String, dynamic>> _articleContent = {
    'hypertension_diet': {
      'title': 'Hypertension Daily Diet Guidelines',
      'intro':
          'Hypertension is a chronic disease with complex causes. As it progresses, it affects the heart, brain, kidneys and blood vessels, with very high rates of disability and mortality. With hypertension affecting younger people, please take good care of yourself. Adjust your routine and sleep on time.',
      'guidelines': [
        'Control total energy intake to achieve and maintain ideal body weight.',
        'Strictly control sodium intake: less than 6g salt per day for normal adults; 3~5g per day for mild hypertension or family history; even less for moderate to severe hypertension.',
        'Reduce fat and limit cholesterol: prefer vegetable oils, limit animal fat; fat 40~50g/day, cholesterol 300~400mg/day.',
        'Eat more foods rich in potassium, calcium and magnesium, such as celery and potatoes.',
        'Eat more fresh vegetables and fruits to get enough vitamin C.',
        'Eat more foods that protect blood vessels and help lower blood pressure and lipids: e.g. celery, carrots, tomatoes, cucumber, kelp, banana; and hawthorn, mushroom, garlic, onion, fish, mung beans.',
        'Eat more high-fiber foods such as corn, soybeans and oats.',
        'Avoid very salty foods, preserved products, dried shrimp, preserved eggs, instant noodles and strong spicy foods.',
        'Get enough protein: about 1g/kg per day from tofu, soy products, skim milk, yogurt, fish and shrimp.',
        'Avoid strong tea and coffee; quit smoking and limit alcohol.',
        'Eat in moderation at regular times; avoid overeating or starving; keep meals light.',
      ],
      'conclusion':
          'With a balanced diet, a positive mindset and moderate exercise, you can stay healthy and live longer.',
    },
    'hypertension_prevention': {
      'title': 'Hypertension Prevention',
      'intro':
          'Hypertension is a common cardiovascular condition. If not controlled in time, it can lead to serious health problems. Prevention and early management are key.',
      'guidelines': [
        'Check blood pressure regularly and keep a record.',
        'Maintain a healthy weight and avoid obesity.',
        'Reduce salt intake and eat a balanced diet.',
        'Exercise regularly, at least 30 minutes most days.',
        'Limit alcohol and avoid smoking.',
        'Manage stress and get enough sleep.',
        'Take prescribed medication consistently if advised by your doctor.',
      ],
      'conclusion': 'Small daily habits can make a big difference in preventing and controlling hypertension.',
    },
    'blood_sugar_measurement': {
      'title': 'Blood Sugar Measurement',
      'intro':
          'Blood sugar monitoring is an important part of diabetes management. Correct measurement helps you and your doctor make better decisions.',
      'guidelines': [
        'Wash hands with soap and dry well before testing.',
        'Use a fresh lancet and test strip each time.',
        'Follow the meter instructions for sample size and timing.',
        'Record results with date, time and whether fasting or after meals.',
        'Store strips and meter according to the manufacturer guidelines.',
        'Discuss your targets and results regularly with your care team.',
      ],
      'conclusion': 'Accurate monitoring supports better blood sugar control and long-term health.',
    },
    'exercise_high_risk': {
      'title': 'Exercise for High Risk Groups',
      'intro':
          'Scientific exercise is beneficial for people with hypertension, diabetes or other cardiovascular risks. Choose safe, suitable activities.',
      'guidelines': [
        'Consult your doctor before starting or changing an exercise program.',
        'Start slowly and increase duration and intensity gradually.',
        'Prefer walking, swimming, cycling and light aerobic activities.',
        'Avoid heavy lifting and sudden intense effort if advised.',
        'Warm up and cool down to reduce injury risk.',
        'Stop and seek help if you feel chest pain, severe shortness of breath or dizziness.',
      ],
      'conclusion': 'Regular, moderate exercise can improve heart health and overall wellbeing.',
    },
  };
}
