import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';

class HealthGuardDB extends GetxService {
  static Database? _database;

  Future<HealthGuardDB> init() async {
    _database = await _initDatabase();
    return this;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'health_guard.db');
    return await openDatabase(
      path,
      version: 6,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_info (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        age INTEGER,
        height REAL,
        weight REAL,
        medical_history TEXT,
        last_check_in TEXT,
        check_in_streak INTEGER DEFAULT 0,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE blood_sugar (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        value REAL NOT NULL,
        type TEXT NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE blood_pressure (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        systolic INTEGER NOT NULL,
        diastolic INTEGER NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE heart_rate (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        value INTEGER NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE check_in (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL UNIQUE,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE articles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        category TEXT NOT NULL,
        source TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE recipes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        ingredients TEXT NOT NULL,
        instructions TEXT NOT NULL,
        benefits TEXT NOT NULL,
        category TEXT NOT NULL,
        season TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    await _insertDefaultData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE user_info ADD COLUMN last_check_in TEXT');
      await db.execute('ALTER TABLE user_info ADD COLUMN check_in_streak INTEGER DEFAULT 0');
    }
    if (oldVersion < 3) {
      await db.delete('articles');
      await _insertDefaultData(db);
    }
    if (oldVersion < 4 || oldVersion < 5 || oldVersion < 6) {
      await db.delete('recipes');
      await _insertRecipeData(db);
    }
  }

  Future<void> _insertDefaultData(Database db) async {
    final articlesData = [
      {
        'title': 'Managing Diabetes Through Lifestyle Changes',
        'content': 'Diabetes management requires a comprehensive approach including diet control, regular exercise, and medication adherence. Monitor your blood sugar levels regularly, maintain a balanced diet with complex carbohydrates, increase fiber intake, and avoid processed sugars. Regular physical activity helps improve insulin sensitivity and control blood sugar levels. Aim for at least 150 minutes of moderate exercise per week.',
        'category': 'chronic_disease',
        'source': '',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'title': 'Understanding Hypertension and Its Risks',
        'content': 'Hypertension, or high blood pressure, is a serious condition that can lead to heart disease, stroke, and kidney problems. Regular monitoring is essential. Maintain a healthy weight, reduce sodium intake to less than 2,300mg daily, exercise regularly, limit alcohol consumption, and manage stress effectively. Medications may be necessary when lifestyle changes are not sufficient.',
        'category': 'chronic_disease',
        'source': '',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'title': 'Heart Disease Prevention Strategies',
        'content': 'Cardiovascular disease remains the leading cause of death worldwide. Prevention includes maintaining healthy cholesterol levels, controlling blood pressure, staying physically active, eating a heart-healthy diet rich in fruits and vegetables, avoiding tobacco, managing diabetes, and reducing stress. Regular check-ups and early detection are crucial for successful treatment and management.',
        'category': 'chronic_disease',
        'source': '',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'title': 'Living with Chronic Kidney Disease',
        'content': 'Chronic kidney disease requires careful management to slow progression. This includes controlling blood pressure and diabetes, following a kidney-friendly diet low in sodium, potassium, and phosphorus, staying hydrated, avoiding NSAIDs, and regular monitoring of kidney function. Early stages may not show symptoms, making regular check-ups essential for at-risk individuals.',
        'category': 'chronic_disease',
        'source': '',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'title': 'Recognizing Heart Attack Symptoms',
        'content': 'Heart attack symptoms include chest pain or discomfort, shortness of breath, pain in arms, back, neck or jaw, cold sweat, nausea, and lightheadedness. Women may experience different symptoms like unusual fatigue, sleep disturbances, or indigestion. If you suspect a heart attack, call emergency services immediately. Every minute counts - early treatment can save lives and prevent heart damage.',
        'category': 'emergency',
        'source': '',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'title': 'Stroke Warning Signs and Response',
        'content': 'Remember FAST: Face drooping, Arm weakness, Speech difficulty, Time to call emergency. Other symptoms include sudden confusion, trouble seeing, severe headache, or loss of balance. Immediate medical attention is critical. Treatment within the first few hours can significantly improve outcomes. Do not wait or drive yourself - call emergency services immediately.',
        'category': 'emergency',
        'source': '',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'title': 'Severe Hypoglycemia Emergency Care',
        'content': 'Severe low blood sugar can be life-threatening. Symptoms include confusion, seizures, unconsciousness, rapid heartbeat, and shakiness. If conscious, give 15-20g fast-acting carbs like glucose tablets or juice. Recheck after 15 minutes. If unconscious, do not give anything by mouth - call emergency services. Use glucagon if available and trained. Prevention includes regular meals and proper medication management.',
        'category': 'emergency',
        'source': '',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'title': 'Hypertensive Crisis: When to Seek Help',
        'content': 'A hypertensive crisis occurs when blood pressure exceeds 180/120 mmHg. Symptoms may include severe headache, vision problems, chest pain, difficulty breathing, or confusion. This is a medical emergency requiring immediate hospital care. Do not wait to see if pressure comes down - organ damage can occur rapidly. Regular monitoring and medication compliance help prevent such emergencies.',
        'category': 'emergency',
        'source': '',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'title': 'Debunking Common Diabetes Myths',
        'content': 'Myth: Eating too much sugar causes diabetes. Fact: Type 2 diabetes results from genetics and lifestyle factors, not just sugar. Myth: People with diabetes cannot eat carbs. Fact: Carbs are important but should be counted and balanced. Myth: Diabetes is not serious. Fact: Diabetes is a serious condition requiring proper management. Always consult healthcare professionals for accurate information.',
        'category': 'fact_check',
        'source': '',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'title': 'Blood Pressure Medication Misconceptions',
        'content': 'Myth: You can stop medication when pressure is normal. Fact: Medication keeps it normal - stopping can cause dangerous spikes. Myth: Natural remedies can replace medication. Fact: While lifestyle helps, medication is often necessary and proven effective. Myth: Side effects are worse than the disease. Fact: Uncontrolled hypertension causes far more damage. Discuss concerns with your doctor, not stopping medication.',
        'category': 'fact_check',
        'source': '',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'title': 'Heart Health Myths Explained',
        'content': 'Myth: Heart disease only affects the elderly. Fact: It can affect people of all ages, risk increases with poor lifestyle. Myth: Heart disease is a man\'s disease. Fact: It is the leading cause of death for women too. Myth: If you have heart disease, avoid exercise. Fact: Appropriate exercise is beneficial and recommended. Consult your healthcare provider for personalized advice.',
        'category': 'fact_check',
        'source': '',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'title': 'Cholesterol Facts vs Fiction',
        'content': 'Myth: All cholesterol is bad. Fact: HDL is protective "good" cholesterol. Myth: Dietary cholesterol is the main problem. Fact: Saturated and trans fats have bigger impact. Myth: Thin people don\'t need to worry about cholesterol. Fact: Anyone can have high cholesterol regardless of weight. Myth: Statins are dangerous. Fact: For many, benefits far outweigh risks. Regular testing and proper management are essential.',
        'category': 'fact_check',
        'source': '',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'title': 'Healthy Eating for Better Wellness',
        'content': 'A balanced diet is fundamental to good health. Include plenty of fruits, vegetables, whole grains, lean proteins, and healthy fats. Limit processed foods, added sugars, and excessive sodium. Proper nutrition supports immune function, maintains healthy weight, provides energy, and reduces chronic disease risk. Stay hydrated and practice mindful eating habits.',
        'category': 'knowledge',
        'source': '',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'title': 'The Importance of Regular Exercise',
        'content': 'Physical activity is essential for overall health and well-being. Regular exercise strengthens the cardiovascular system, improves mental health, helps maintain healthy weight, strengthens bones and muscles, and reduces chronic disease risk. Aim for at least 150 minutes of moderate aerobic activity weekly, plus muscle-strengthening activities twice per week. Find activities you enjoy to maintain consistency.',
        'category': 'knowledge',
        'source': '',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'title': 'Sleep and Your Health',
        'content': 'Quality sleep is crucial for physical and mental health. Adults need 7-9 hours per night. Poor sleep increases risk of obesity, diabetes, heart disease, and mental health issues. Maintain a consistent schedule, create a relaxing bedtime routine, keep the bedroom cool and dark, limit screen time before bed, and avoid caffeine late in the day. If you have persistent sleep problems, consult a healthcare provider.',
        'category': 'knowledge',
        'source': '',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'title': 'Stress Management for Better Health',
        'content': 'Chronic stress negatively impacts both physical and mental health. It can lead to high blood pressure, heart disease, obesity, and diabetes. Effective stress management techniques include regular exercise, meditation, deep breathing, yoga, adequate sleep, social connections, and time management. Seek professional help if stress becomes overwhelming. Remember, managing stress is not a luxury but a necessity for health.',
        'category': 'knowledge',
        'source': '',
        'created_at': DateTime.now().toIso8601String(),
      },
    ];

    for (var article in articlesData) {
      await db.insert('articles', article);
    }

    await _insertRecipeData(db);
  }

  Future<void> _insertRecipeData(Database db) async {
    final recipesData = [
      {
        'name': 'Steamed Fish with Ginger and Scallion',
        'ingredients': 'Fresh sea bass or tilapia (1 whole fish, about 500g), ginger (30g, sliced), scallions (4 stalks, cut into sections), soy sauce (3 tbsp), sesame oil (1 tbsp), cooking wine (2 tbsp), salt (1/2 tsp), white pepper (1/4 tsp), vegetable oil (2 tbsp)',
        'instructions': '1. Clean the fish thoroughly and make 3-4 diagonal cuts on each side.\n2. Rub salt and white pepper inside and outside the fish.\n3. Place ginger slices and half of the scallions inside the fish cavity and on top.\n4. Steam over high heat for 10-12 minutes until fish is cooked through.\n5. Remove ginger and scallions from the top.\n6. Heat oil until smoking and pour over the fish.\n7. Drizzle with soy sauce and sesame oil.\n8. Garnish with fresh scallions.',
        'benefits': 'High in protein and omega-3 fatty acids, supports heart health, brain function, and reduces inflammation. Low in calories and easy to digest, making it ideal for people with high blood pressure and those recovering from illness.',
        'category': 'home_cooking',
        'season': 'all',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Stir-Fried Vegetables with Mushrooms',
        'ingredients': 'Shiitake mushrooms (150g, sliced), broccoli (200g, cut into florets), carrots (1 medium, sliced), baby corn (100g), snow peas (100g), garlic (3 cloves, minced), ginger (1 inch, minced), oyster sauce (2 tbsp), light soy sauce (1 tbsp), vegetable oil (2 tbsp), sesame oil (1 tsp), cornstarch (1 tsp mixed with 2 tbsp water)',
        'instructions': '1. Blanch broccoli in boiling water for 2 minutes, drain and set aside.\n2. Heat oil in a wok over high heat.\n3. Add garlic and ginger, stir-fry until fragrant (30 seconds).\n4. Add mushrooms and carrots, stir-fry for 2 minutes.\n5. Add baby corn and snow peas, continue stir-frying for 2 minutes.\n6. Add blanched broccoli, oyster sauce, and soy sauce.\n7. Stir in cornstarch mixture to thicken the sauce.\n8. Drizzle with sesame oil before serving.',
        'benefits': 'Rich in vitamins, minerals, and dietary fiber. Mushrooms provide immune-boosting properties and vitamin D. Low in calories and helps with weight management. Supports digestive health and may help reduce cholesterol levels.',
        'category': 'home_cooking',
        'season': 'all',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Tofu and Vegetable Stir-Fry',
        'ingredients': 'Firm tofu (400g, cubed), bell peppers (2, mixed colors, diced), onion (1 medium, sliced), garlic (4 cloves, minced), soy sauce (3 tbsp), hoisin sauce (2 tbsp), rice vinegar (1 tbsp), brown sugar (1 tsp), cornstarch (2 tbsp for coating tofu), vegetable oil (3 tbsp), sesame seeds (1 tbsp for garnish)',
        'instructions': '1. Press tofu to remove excess water, cut into cubes and coat with cornstarch.\n2. Heat 2 tbsp oil in a wok, fry tofu until golden on all sides, remove and set aside.\n3. Add remaining oil, stir-fry garlic until fragrant.\n4. Add onions and bell peppers, stir-fry for 3 minutes until tender-crisp.\n5. Return tofu to the wok.\n6. Mix soy sauce, hoisin sauce, rice vinegar, and brown sugar, pour over the mixture.\n7. Stir-fry for 2 more minutes.\n8. Garnish with sesame seeds.',
        'benefits': 'Excellent source of plant-based protein and calcium. Tofu contains isoflavones which may help reduce cholesterol and support bone health. Low in saturated fat and helps maintain stable blood sugar levels. Rich in iron and antioxidants.',
        'category': 'home_cooking',
        'season': 'all',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Chicken and Vegetable Congee',
        'ingredients': 'Jasmine rice (1 cup, rinsed), chicken breast (200g, diced), chicken stock (8 cups), ginger (2 inches, julienned), dried scallops (2, optional), shiitake mushrooms (4, sliced), century egg (1, diced, optional), scallions (3 stalks, chopped), cilantro (for garnish), salt (to taste), white pepper (to taste), sesame oil (1 tbsp)',
        'instructions': '1. Soak rice in water for 30 minutes, drain.\n2. Bring chicken stock to boil in a large pot.\n3. Add rice and dried scallops, reduce heat to medium-low.\n4. Stir occasionally and cook for 45 minutes until rice breaks down.\n5. Add chicken, ginger, and mushrooms, cook for 15 minutes.\n6. Add century egg if using, cook for 5 more minutes.\n7. Season with salt and white pepper.\n8. Stir in sesame oil.\n9. Serve hot, garnished with scallions and cilantro.',
        'benefits': 'Easily digestible and gentle on the stomach, perfect for people with digestive issues or recovering from illness. Provides sustained energy and warmth. Rich in protein and minerals. Helps boost immunity and provides hydration. Traditional remedy for colds and flu.',
        'category': 'porridge',
        'season': 'all',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Sweet Potato and Millet Porridge',
        'ingredients': 'Millet (1 cup, rinsed), sweet potato (1 large, peeled and cubed), water (8 cups), goji berries (2 tbsp), red dates (6, pitted), rock sugar or honey (2-3 tbsp, adjust to taste), dried longan (10 pieces, optional)',
        'instructions': '1. Soak millet in water for 30 minutes, drain.\n2. Bring water to boil in a large pot.\n3. Add millet and reduce heat to medium-low.\n4. Cook for 20 minutes, stirring occasionally.\n5. Add sweet potato cubes and continue cooking for 15 minutes.\n6. Add goji berries, red dates, and longan.\n7. Cook for another 10 minutes until sweet potato is soft and porridge is creamy.\n8. Add rock sugar or honey to taste.\n9. Serve warm.',
        'benefits': 'Rich in dietary fiber, vitamins A and C, and complex carbohydrates. Supports digestive health and helps regulate blood sugar. Millet is gluten-free and easy to digest. Goji berries and red dates provide antioxidants and support immune function. Excellent for people with diabetes when consumed in moderation.',
        'category': 'porridge',
        'season': 'all',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Century Egg and Lean Pork Congee',
        'ingredients': 'Jasmine rice (1 cup, rinsed), lean pork (150g, thinly sliced), century eggs (2, diced), salted egg (1, optional), ginger (2 inches, julienned), water or stock (10 cups), dried scallops (3), peanuts (1/4 cup, optional), scallions (chopped), cilantro (chopped), soy sauce (for marinating), white pepper, salt, sesame oil',
        'instructions': '1. Marinate pork with soy sauce and white pepper for 15 minutes.\n2. Soak rice and peanuts for 30 minutes.\n3. Bring water to boil, add rice, dried scallops, and half the ginger.\n4. Cook on medium-low heat for 45 minutes, stirring occasionally.\n5. Add marinated pork and remaining ginger, cook for 10 minutes.\n6. Add century eggs and salted egg if using, cook for 5 minutes.\n7. Season with salt and white pepper.\n8. Drizzle with sesame oil.\n9. Garnish with scallions and cilantro.',
        'benefits': 'High in protein and essential amino acids. Century eggs provide minerals like iron and selenium. The congee is warming and nourishing, excellent for building strength and energy. Supports digestive health and is easily absorbed by the body. Traditional comfort food that helps with recovery.',
        'category': 'porridge',
        'season': 'all',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Herbal Chicken Soup',
        'ingredients': 'Whole chicken (1, about 1.5kg), ginseng root (20g), astragalus root (15g), dried red dates (8), goji berries (2 tbsp), angelica root (10g), codonopsis root (15g), ginger (3 slices), water (12 cups), salt (to taste), rice wine (2 tbsp)',
        'instructions': '1. Clean chicken thoroughly and blanch in boiling water for 5 minutes to remove impurities.\n2. Rinse all herbs under running water.\n3. Place chicken in a large pot with water, bring to boil.\n4. Add all herbs, ginseng, astragalus, dates, angelica, codonopsis, and ginger.\n5. Add rice wine and reduce heat to low.\n6. Simmer for 2.5-3 hours until chicken is tender and broth is rich.\n7. Skim off any foam during cooking.\n8. Season with salt to taste.\n9. Serve hot with the chicken meat and drink the nutritious broth.',
        'benefits': 'Powerful immune system booster and energy enhancer. Ginseng improves vitality and mental clarity. Astragalus strengthens immune function. Angelica nourishes blood and improves circulation. Excellent for recovery after illness, postpartum care, or during cold winter months. Helps combat fatigue and weakness.',
        'category': 'soup',
        'season': 'winter',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Winter Melon and Pork Rib Soup',
        'ingredients': 'Pork ribs (500g, cut into pieces), winter melon (800g, cut into chunks with skin on), dried scallops (3), ginger (3 slices), dried shiitake mushrooms (5, soaked), goji berries (1 tbsp), water (10 cups), salt (to taste), white pepper (to taste)',
        'instructions': '1. Blanch pork ribs in boiling water for 5 minutes, rinse and drain.\n2. Place ribs, dried scallops, ginger, and soaked mushrooms in a large pot with water.\n3. Bring to boil, then reduce heat to low and simmer for 1 hour.\n4. Add winter melon chunks (with skin for more nutrients).\n5. Continue simmering for 45 minutes until winter melon is soft and translucent.\n6. Add goji berries and cook for 10 more minutes.\n7. Season with salt and white pepper.\n8. Serve hot.',
        'benefits': 'Winter melon is extremely hydrating and helps reduce body heat, making it perfect for hot weather. Rich in vitamin C and potassium. Helps with fluid retention and supports kidney function. Low in calories and aids in weight management. The combination of pork ribs provides collagen for joint and skin health.',
        'category': 'soup',
        'season': 'summer',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Lotus Root and Peanut Soup',
        'ingredients': 'Fresh lotus root (400g, peeled and sliced), raw peanuts (1/2 cup, with red skin), pork ribs or chicken (300g), dried octopus (20g, optional), red dates (6), ginger (2 slices), water (10 cups), salt (to taste)',
        'instructions': '1. Soak peanuts and dried octopus for 30 minutes.\n2. Blanch meat in boiling water, rinse and drain.\n3. Peel and slice lotus root, soak in water with a little vinegar to prevent browning.\n4. Place meat, peanuts, octopus, and ginger in a pot with water.\n5. Bring to boil, reduce heat and simmer for 1 hour.\n6. Add lotus root and red dates.\n7. Continue simmering for another hour until lotus root is tender.\n8. Season with salt.\n9. Serve warm.',
        'benefits': 'Lotus root is cooling and helps clear heat from the body. Rich in dietary fiber, vitamin C, and potassium. Peanuts provide protein and healthy fats. The soup nourishes blood, strengthens the spleen, and supports digestive health. Helps improve skin complexion and reduces inflammation. Good for respiratory health.',
        'category': 'soup',
        'season': 'autumn',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Chrysanthemum and Goji Berry Tea',
        'ingredients': 'Dried chrysanthemum flowers (10-12 flowers), goji berries (1 tbsp), rock sugar or honey (1-2 tsp, optional), hot water (4 cups)',
        'instructions': '1. Rinse chrysanthemum flowers and goji berries under running water.\n2. Place chrysanthemum flowers in a teapot or large cup.\n3. Pour hot water (around 90°C/194°F, not boiling) over the flowers.\n4. Add goji berries.\n5. Cover and steep for 5-8 minutes.\n6. Add rock sugar or honey to taste if desired.\n7. Can be refilled with hot water 2-3 times.\n8. Drink warm or let cool for a refreshing beverage.',
        'benefits': 'Excellent for eye health and reducing eye strain, especially for people who work long hours at computers. Chrysanthemum has cooling properties and helps reduce internal heat. Goji berries are rich in antioxidants and support liver and kidney health. Helps lower blood pressure, reduce fever, and calm the mind. May improve sleep quality.',
        'category': 'tea',
        'season': 'summer',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Ginger and Red Date Tea',
        'ingredients': 'Fresh ginger (30g, sliced), red dates (8, pitted and sliced), brown sugar or honey (2 tbsp), water (4 cups), dried longan (10 pieces, optional)',
        'instructions': '1. Slice ginger and red dates.\n2. Bring water to boil in a pot.\n3. Add ginger slices and reduce heat to medium.\n4. Simmer for 10 minutes to extract ginger essence.\n5. Add red dates and longan if using.\n6. Continue simmering for 15 minutes.\n7. Add brown sugar and stir until dissolved.\n8. Strain if desired or serve with the ingredients.\n9. Drink hot for best warming effects.',
        'benefits': 'Warming and energizing, perfect for cold weather or when feeling chilled. Ginger aids digestion, reduces nausea, and has anti-inflammatory properties. Red dates nourish blood and improve circulation. Helps relieve menstrual discomfort and supports immune function. Great for people with cold constitution or poor circulation.',
        'category': 'tea',
        'season': 'winter',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Oolong Tea with Osmanthus',
        'ingredients': 'High-quality oolong tea leaves (2 tsp), dried osmanthus flowers (1 tsp), hot water (4 cups at 90-95°C)',
        'instructions': '1. Rinse teapot with hot water to warm it.\n2. Add oolong tea leaves to the teapot.\n3. Pour a small amount of hot water to rinse the leaves, discard immediately.\n4. Add osmanthus flowers.\n5. Pour hot water over the tea and flowers.\n6. Steep for 3-4 minutes for the first infusion.\n7. Pour and enjoy.\n8. Can be re-steeped 3-5 times, increasing steeping time by 30 seconds each time.\n9. Best enjoyed without sweetener to appreciate the natural fragrance.',
        'benefits': 'Oolong tea aids in weight management and boosts metabolism. Rich in antioxidants that support heart health. Osmanthus adds a sweet fragrance and helps relieve cough and phlegm. May improve dental health and freshen breath. The combination helps with digestion and reduces bloating. Provides gentle energy without the jitters.',
        'category': 'tea',
        'season': 'all',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Bird\'s Nest Soup with Rock Sugar',
        'ingredients': 'Dried bird\'s nest (10g), water (4 cups for soaking, 3 cups for cooking), rock sugar (2-3 tbsp, adjust to taste), red dates (3, optional), goji berries (1 tsp, optional)',
        'instructions': '1. Soak bird\'s nest in cold water for 4-6 hours until expanded and soft.\n2. Carefully remove any feathers or impurities with tweezers.\n3. Drain and rinse gently.\n4. Place cleaned bird\'s nest in a double boiler or heatproof bowl.\n5. Add 3 cups of water.\n6. Steam or double-boil for 1.5-2 hours until the bird\'s nest becomes gelatinous.\n7. Add rock sugar in the last 15 minutes.\n8. Add red dates and goji berries if using in the last 10 minutes.\n9. Serve warm or chilled.',
        'benefits': 'Considered a premium tonic in Chinese medicine. Rich in proteins, amino acids, and growth factors. Promotes skin health, elasticity, and anti-aging. Supports respiratory health and boosts immune system. May improve digestion and enhance nutrient absorption. Excellent for postpartum recovery and general wellness. Helps with fatigue and improves overall vitality.',
        'category': 'tonic',
        'season': 'all',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Double-Boiled Papaya Snow Fungus Soup',
        'ingredients': 'Ripe papaya (1 small, about 500g), snow fungus/white fungus (20g, soaked), rock sugar (3 tbsp), water (3 cups), goji berries (1 tbsp), almonds (10 pieces, optional), red dates (4, pitted)',
        'instructions': '1. Soak snow fungus in water for 2 hours until fully expanded.\n2. Remove the hard yellow stem and tear into small pieces.\n3. Cut papaya in half, remove seeds, and scoop out some flesh, leaving the shell intact.\n4. Place snow fungus, papaya flesh, rock sugar, dates, almonds, and water in the papaya shell.\n5. Place in a steamer or double boiler.\n6. Steam for 2 hours until snow fungus is soft and gelatinous.\n7. Add goji berries in the last 10 minutes.\n8. Serve warm in the papaya shell.',
        'benefits': 'Snow fungus is rich in collagen and excellent for skin hydration and elasticity. Papaya contains digestive enzymes and vitamin C. The soup moisturizes lungs and throat, perfect for dry climates. Helps improve complexion and reduce fine lines. Supports immune function and provides natural anti-aging benefits. Gentle on the stomach and suitable for all ages.',
        'category': 'tonic',
        'season': 'all',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Cordyceps and Black Chicken Soup',
        'ingredients': 'Black-boned chicken (1, about 1kg), cordyceps sinensis (5-8 pieces) or cordyceps flower (30g), red dates (6), goji berries (2 tbsp), dried longan (10 pieces), Chinese yam (100g, sliced), ginger (3 slices), water (10 cups), rice wine (2 tbsp), salt (to taste)',
        'instructions': '1. Clean chicken thoroughly and remove excess fat. Blanch in boiling water for 5 minutes.\n2. Rinse cordyceps gently and soak for 10 minutes.\n3. Place chicken in a double boiler or large pot with water.\n4. Add cordyceps, red dates, longan, Chinese yam, and ginger.\n5. Add rice wine.\n6. Double-boil for 3-4 hours or simmer on low heat for 2.5 hours.\n7. Add goji berries in the last 10 minutes.\n8. Season with salt to taste.\n9. Serve hot, consuming both the broth and chicken.',
        'benefits': 'Highly prized tonic for overall wellness and vitality. Cordyceps enhances energy, stamina, and athletic performance. Black chicken is richer in nutrients than regular chicken. Supports kidney and lung function. Boosts immune system and helps with recovery from illness. May improve respiratory health. Excellent for people with fatigue, low energy, or weakened immune systems. Traditional remedy for anti-aging and longevity.',
        'category': 'tonic',
        'season': 'winter',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Braised Pork Belly with Preserved Vegetables',
        'ingredients': 'Pork belly (500g, skin-on), preserved mustard greens (200g, soaked and chopped), garlic (5 cloves, minced), ginger (3 slices), star anise (2), cinnamon stick (1), dark soy sauce (3 tbsp), light soy sauce (2 tbsp), rice wine (3 tbsp), rock sugar (2 tbsp), vegetable oil (2 tbsp), water (2 cups)',
        'instructions': '1. Cut pork belly into 2-inch squares. Blanch in boiling water for 5 minutes, drain.\n2. Heat oil in a wok, add rock sugar and melt until caramelized.\n3. Add pork belly and sear until golden brown on all sides.\n4. Add garlic, ginger, star anise, and cinnamon, stir-fry until fragrant.\n5. Pour in soy sauces and rice wine, stir to coat.\n6. Add water and bring to boil.\n7. Transfer to a clay pot or covered pot, simmer on low heat for 1.5 hours.\n8. Add preserved vegetables and cook for another 30 minutes.\n9. Serve hot over rice.',
        'benefits': 'Rich in protein and B vitamins. Pork belly provides essential fatty acids and energy. Preserved vegetables aid digestion and add beneficial probiotics. The slow braising makes the dish easier to digest. Provides warmth and energy, especially good for cold weather. Traditional comfort food that satisfies and nourishes.',
        'category': 'home_cooking',
        'season': 'winter',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Kung Pao Chicken with Cashews',
        'ingredients': 'Chicken breast (400g, cubed), cashew nuts (1/2 cup, roasted), dried chili peppers (8-10), Sichuan peppercorns (1 tsp), scallions (3, cut into sections), garlic (4 cloves, minced), ginger (1 inch, minced), soy sauce (2 tbsp), rice vinegar (1 tbsp), sugar (1 tbsp), cornstarch (1 tbsp), vegetable oil (3 tbsp), sesame oil (1 tsp)',
        'instructions': '1. Marinate chicken with 1 tbsp soy sauce and cornstarch for 15 minutes.\n2. Mix remaining soy sauce, vinegar, and sugar for the sauce.\n3. Heat oil in a wok over high heat.\n4. Add dried chilies and Sichuan peppercorns, stir-fry for 30 seconds until fragrant.\n5. Add chicken and stir-fry until golden, about 4-5 minutes.\n6. Add garlic, ginger, and scallions, stir-fry for 1 minute.\n7. Pour in the sauce and stir well.\n8. Add roasted cashews and toss together.\n9. Drizzle with sesame oil before serving.',
        'benefits': 'High in protein and healthy fats from cashews. Provides essential minerals like zinc and magnesium. Capsaicin from chilies boosts metabolism and may help with weight management. Supports immune function and provides sustained energy. The spices aid digestion and improve circulation.',
        'category': 'home_cooking',
        'season': 'all',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Salt-Baked Shrimp with Garlic',
        'ingredients': 'Large prawns or shrimp (500g, with shells), coarse sea salt (2 cups), garlic (1 whole bulb, cloves separated), ginger (2 inches, sliced), scallions (3 stalks, tied in knots), Sichuan peppercorns (1 tbsp), bay leaves (3), star anise (2), rice wine (2 tbsp)',
        'instructions': '1. Clean shrimp, trim legs but keep shells and heads on. Devein if needed.\n2. Marinate shrimp with rice wine for 10 minutes.\n3. Heat a wok or large pan over medium heat.\n4. Add sea salt, peppercorns, bay leaves, star anise, and stir constantly for 5 minutes until salt is hot.\n5. Make a well in the center, place garlic, ginger, and scallions.\n6. Arrange shrimp on top.\n7. Cover shrimp with the hot salt mixture.\n8. Cover wok with lid and cook for 8-10 minutes on low heat.\n9. Remove shrimp, brush off excess salt, and serve hot.',
        'benefits': 'Excellent source of lean protein and omega-3 fatty acids. Rich in selenium, vitamin B12, and minerals. Supports heart health and brain function. Low in calories and helps with weight management. Garlic provides immune-boosting and anti-inflammatory properties. Easy to digest and ideal for maintaining healthy cholesterol levels.',
        'category': 'home_cooking',
        'season': 'all',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Seafood and Vegetable Congee',
        'ingredients': 'Jasmine rice (1 cup, rinsed), shrimp (150g, peeled and deveined), squid (100g, cleaned and sliced), fish fillet (100g, sliced), fish stock or water (10 cups), ginger (3 slices, julienned), celery (2 stalks, chopped), dried scallops (3), shiitake mushrooms (4, sliced), scallions (chopped), cilantro (chopped), white pepper, salt, sesame oil (1 tbsp)',
        'instructions': '1. Soak rice for 30 minutes, drain.\n2. Bring stock to boil in a large pot.\n3. Add rice, dried scallops, and half the ginger.\n4. Cook on medium-low heat for 45 minutes, stirring occasionally until rice breaks down.\n5. Add mushrooms and celery, cook for 10 minutes.\n6. Add seafood and remaining ginger, cook for 5-7 minutes until seafood is just cooked.\n7. Season with salt and white pepper.\n8. Stir in sesame oil.\n9. Garnish with scallions and cilantro.',
        'benefits': 'Rich in high-quality protein and omega-3 fatty acids from seafood. Provides essential minerals like iodine, zinc, and selenium. Supports brain health, heart function, and immune system. Easy to digest and provides sustained energy. Excellent for post-workout recovery or when feeling under the weather. The light yet nourishing combination is perfect for maintaining health.',
        'category': 'porridge',
        'season': 'all',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Pumpkin and Oat Porridge',
        'ingredients': 'Pumpkin (300g, peeled and cubed), rolled oats (1 cup), jasmine rice (1/2 cup, rinsed), water or milk (8 cups), cinnamon (1/2 tsp), nutmeg (1/4 tsp), ginger powder (1/4 tsp), honey or maple syrup (2-3 tbsp), walnuts (1/4 cup, chopped), raisins (2 tbsp)',
        'instructions': '1. Soak rice for 30 minutes, drain.\n2. Bring water or milk to boil in a large pot.\n3. Add rice and pumpkin cubes.\n4. Reduce heat to medium-low and cook for 25 minutes.\n5. Add rolled oats and continue cooking for 15 minutes, stirring frequently.\n6. Add cinnamon, nutmeg, and ginger powder.\n7. Cook until porridge is creamy and pumpkin is very soft, about 10 more minutes.\n8. Add honey or maple syrup to taste.\n9. Serve hot, topped with walnuts and raisins.',
        'benefits': 'Rich in beta-carotene, vitamin A, and dietary fiber. Pumpkin supports eye health and immune function. Oats provide heart-healthy soluble fiber that helps lower cholesterol. The combination helps regulate blood sugar levels. Provides long-lasting energy and promotes digestive health. Warming spices aid circulation and digestion. Perfect for breakfast or when recovering from illness.',
        'category': 'porridge',
        'season': 'autumn',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Red Bean and Barley Porridge',
        'ingredients': 'Red adzuki beans (1 cup, soaked overnight), pearl barley (1/2 cup, soaked), glutinous rice (1/2 cup, rinsed), water (10 cups), dried tangerine peel (1 piece), red dates (6, pitted), rock sugar or honey (3 tbsp, adjust to taste), goji berries (1 tbsp)',
        'instructions': '1. Drain soaked beans and barley.\n2. Bring water to boil in a large pot.\n3. Add red beans, barley, and tangerine peel.\n4. Reduce heat to medium-low and simmer for 1 hour.\n5. Add glutinous rice and red dates.\n6. Continue cooking for 45 minutes, stirring occasionally.\n7. Add more water if needed to maintain desired consistency.\n8. Add rock sugar and goji berries.\n9. Cook for 10 more minutes until sugar dissolves.\n10. Serve warm or chilled.',
        'benefits': 'Excellent for removing excess water retention and reducing swelling. Red beans and barley are traditionally used to promote healthy fluid balance. Rich in dietary fiber, protein, and B vitamins. Supports kidney function and digestive health. Helps detoxify the body and may aid in weight management. The combination nourishes blood and improves circulation. Perfect for hot humid weather or when feeling bloated.',
        'category': 'porridge',
        'season': 'summer',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Tomato and Egg Drop Soup',
        'ingredients': 'Ripe tomatoes (4 large, cut into wedges), eggs (3, beaten), chicken or vegetable stock (6 cups), ginger (2 slices), garlic (2 cloves, minced), scallions (3 stalks, chopped), sugar (1 tsp), salt (to taste), white pepper (to taste), sesame oil (1 tbsp), cornstarch (1 tbsp mixed with 2 tbsp water)',
        'instructions': '1. Heat a large pot with a little oil over medium heat.\n2. Add ginger and garlic, stir-fry until fragrant.\n3. Add tomato wedges and sugar, stir-fry for 3-4 minutes until tomatoes start to break down.\n4. Pour in stock and bring to boil.\n5. Reduce heat and simmer for 10 minutes.\n6. Stir in cornstarch mixture to slightly thicken the soup.\n7. Slowly drizzle beaten eggs while stirring gently to create ribbons.\n8. Season with salt and white pepper.\n9. Drizzle with sesame oil and garnish with scallions.',
        'benefits': 'Tomatoes are rich in lycopene, a powerful antioxidant that supports heart health and may reduce cancer risk. High in vitamin C and potassium. Eggs provide complete protein and essential amino acids. The soup is light yet nutritious, easy to digest, and comforting. Helps boost immune function and supports eye health. Perfect for any season and suitable for all ages.',
        'category': 'soup',
        'season': 'all',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Watercress and Pork Lung Soup',
        'ingredients': 'Fresh watercress (400g, washed), pork lung (300g, cleaned thoroughly) or substitute with pork ribs (400g), dried figs (6), dried apricot kernels (20g), almonds (1/4 cup), red dates (5), ginger (3 slices), water (10 cups), salt (to taste)',
        'instructions': '1. Clean pork lung thoroughly by rinsing multiple times until water runs clear, or use pork ribs as substitute.\n2. Blanch meat in boiling water for 5 minutes, rinse and drain.\n3. Soak dried figs and apricot kernels for 15 minutes.\n4. Bring water to boil in a large pot.\n5. Add meat, figs, apricot kernels, almonds, dates, and ginger.\n6. Bring back to boil, then reduce heat to low.\n7. Simmer for 2 hours.\n8. Add watercress and cook for another 30 minutes.\n9. Season with salt to taste.',
        'benefits': 'Traditional soup for respiratory health and clearing lung heat. Watercress is cooling and rich in vitamins A, C, and minerals. Helps relieve cough, reduce phlegm, and soothe sore throat. The combination moisturizes the lungs and throat, making it excellent for dry climates or respiratory conditions. Supports immune function and helps combat seasonal allergies. Traditional remedy for smokers or those exposed to air pollution.',
        'category': 'soup',
        'season': 'autumn',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Fish Maw and Chicken Soup',
        'ingredients': 'Dried fish maw (100g, soaked and cut into pieces), chicken (500g, cut into pieces), dried scallops (4), shiitake mushrooms (6, soaked), ginger (4 slices), red dates (8), goji berries (2 tbsp), rice wine (2 tbsp), water (10 cups), salt (to taste), white pepper (to taste)',
        'instructions': '1. Soak fish maw in cold water for 24 hours until soft, changing water several times. Cut into bite-sized pieces.\n2. Blanch chicken in boiling water for 5 minutes, rinse and drain.\n3. Place chicken, dried scallops, mushrooms, and ginger in a large pot with water.\n4. Bring to boil, add rice wine, then reduce heat to low.\n5. Simmer for 1.5 hours.\n6. Add fish maw and red dates, continue simmering for 45 minutes.\n7. Add goji berries and cook for 10 more minutes.\n8. Season with salt and white pepper.\n9. Serve hot.',
        'benefits': 'Fish maw is extremely rich in collagen, which promotes skin elasticity, joint health, and tissue repair. High in protein and calcium. Supports bone health and may help reduce signs of aging. Excellent for postpartum recovery and building strength. The soup nourishes blood, improves circulation, and enhances overall vitality. Traditional beauty tonic highly valued in Chinese cuisine. Helps with recovery from surgery or illness.',
        'category': 'soup',
        'season': 'all',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Hawthorn Berry and Rose Tea',
        'ingredients': 'Dried hawthorn berries (15-20 pieces), dried rose buds (8-10), rock sugar or honey (1-2 tbsp, optional), hot water (4 cups), dried tangerine peel (1 small piece, optional)',
        'instructions': '1. Rinse hawthorn berries and rose buds under running water.\n2. Crush hawthorn berries slightly to release more flavor.\n3. Place hawthorn berries and tangerine peel if using in a teapot.\n4. Pour hot water (around 90°C/194°F) over them.\n5. Steep for 5 minutes.\n6. Add rose buds and steep for another 3-5 minutes.\n7. Add rock sugar or honey to taste if desired.\n8. Can be refilled with hot water once.\n9. Drink warm for best benefits.',
        'benefits': 'Hawthorn berries support cardiovascular health and may help lower blood pressure and cholesterol. Aids digestion, especially after heavy or fatty meals, and helps reduce bloating. Rose buds calm the mind, relieve stress, and promote healthy skin. The tea has a pleasant fruity-floral aroma. May help with weight management by improving fat metabolism. Suitable for people with high blood pressure or digestive issues.',
        'category': 'tea',
        'season': 'all',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Lemon Ginger Honey Tea',
        'ingredients': 'Fresh ginger (40g, thinly sliced), fresh lemon (1 large, sliced), honey (3-4 tbsp), hot water (4 cups), fresh mint leaves (optional, 5-6 leaves)',
        'instructions': '1. Slice ginger thinly and lemon into rounds.\n2. Bring water to boil in a pot.\n3. Add ginger slices and reduce heat to medium.\n4. Simmer for 10-15 minutes to extract ginger essence.\n5. Remove from heat and let cool slightly to around 60°C.\n6. Add lemon slices (avoid boiling water to preserve vitamin C).\n7. Stir in honey until dissolved.\n8. Add fresh mint leaves if using.\n9. Strain if desired or serve with the ingredients.\n10. Drink warm or chill for a refreshing cold beverage.',
        'benefits': 'Powerful immune booster rich in vitamin C and antioxidants. Ginger aids digestion, reduces nausea, and has strong anti-inflammatory properties. Honey provides natural antibacterial benefits and soothes sore throat. The combination helps fight colds and flu, relieves congestion, and supports respiratory health. May boost metabolism and aid in weight management. Refreshing and energizing any time of day.',
        'category': 'tea',
        'season': 'all',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Herbal Cooling Tea',
        'ingredients': 'Honeysuckle flowers (15g), chrysanthemum flowers (10g), licorice root (5g), dried bamboo leaves (10g), dried mint (5g), rock sugar (2 tbsp, adjust to taste), water (6 cups)',
        'instructions': '1. Rinse all herbs under running water.\n2. Bring water to boil in a pot.\n3. Add licorice root and bamboo leaves first.\n4. Reduce heat to medium and simmer for 10 minutes.\n5. Add honeysuckle and chrysanthemum flowers.\n6. Simmer for another 10 minutes.\n7. Turn off heat and add dried mint.\n8. Cover and steep for 5 minutes.\n9. Strain the tea and add rock sugar.\n10. Can be served warm or chilled.',
        'benefits': 'Traditional cooling herbal tea that helps clear body heat and reduce inflammation. Honeysuckle has natural antibacterial and antiviral properties. Excellent for relieving sore throat, fever, and heat-related symptoms. Helps detoxify the body and support liver function. Chrysanthemum calms the mind and supports eye health. Perfect for hot summer weather or when experiencing internal heat symptoms. May help with acne and skin conditions related to heat.',
        'category': 'tea',
        'season': 'summer',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Ginseng and Deer Antler Tonic Soup',
        'ingredients': 'Korean red ginseng (20g), deer antler slices (10g), lean pork or chicken (300g), Chinese yam (100g, sliced), goji berries (2 tbsp), red dates (8), dried longan (15 pieces), angelica root (10g), ginger (3 slices), rice wine (2 tbsp), water (8 cups), salt (to taste)',
        'instructions': '1. Soak ginseng and deer antler in rice wine for 30 minutes.\n2. Clean meat and blanch in boiling water for 5 minutes, rinse and drain.\n3. Place meat in a double boiler or clay pot with water.\n4. Add ginseng, deer antler (with soaking wine), Chinese yam, angelica, and ginger.\n5. Bring to boil, then reduce heat to very low.\n6. Double-boil for 3-4 hours or simmer gently for 2.5 hours.\n7. Add dates, longan, and goji berries in the last 30 minutes.\n8. Season with salt lightly.\n9. Serve hot, consuming both broth and ingredients.',
        'benefits': 'Premium tonic highly valued for enhancing vitality, energy, and stamina. Ginseng improves mental clarity, reduces fatigue, and boosts overall wellness. Deer antler is traditionally used to strengthen bones, support kidney function, and improve athletic performance. May enhance immune function and support healthy aging. Excellent for people recovering from illness, experiencing chronic fatigue, or needing energy restoration. Best consumed in winter or for those with cold constitution.',
        'category': 'tonic',
        'season': 'winter',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Sea Cucumber and Fish Maw Soup',
        'ingredients': 'Dried sea cucumber (100g, soaked and cleaned), dried fish maw (50g, soaked), chicken (400g, cut into pieces), dried scallops (5), shiitake mushrooms (6, soaked), ginger (4 slices), scallions (2 stalks), rice wine (3 tbsp), water (10 cups), salt (to taste), white pepper (to taste)',
        'instructions': '1. Soak sea cucumber for 48 hours, changing water daily. Clean thoroughly and cut into pieces.\n2. Soak fish maw for 24 hours, cut into pieces.\n3. Blanch chicken in boiling water for 5 minutes, rinse and drain.\n4. Place chicken, dried scallops, mushrooms, ginger, and scallions in a pot with water.\n5. Bring to boil, add rice wine, reduce heat to low.\n6. Simmer for 1.5 hours.\n7. Add sea cucumber and fish maw.\n8. Continue simmering gently for 1 hour.\n9. Season with salt and white pepper.\n10. Serve hot.',
        'benefits': 'Ultra-premium tonic soup extremely rich in collagen and protein. Sea cucumber contains bioactive compounds that support immune function, wound healing, and joint health. Highly valued for anti-aging properties and tissue regeneration. Fish maw enhances skin elasticity and promotes healthy connective tissue. The combination nourishes kidney essence and improves overall vitality. Excellent for postpartum recovery, building strength after illness, or maintaining youthful appearance. May improve bone density and support cardiovascular health.',
        'category': 'tonic',
        'season': 'all',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'name': 'American Ginseng and Frog Soup',
        'ingredients': 'Dried field frog or American bullfrog legs (4-6 pieces, about 200g, cleaned), American ginseng slices (15g), dried figs (6), dried lily bulbs (30g, soaked), dried longan (12 pieces), goji berries (2 tbsp), Chinese yam (80g, sliced), red dates (6), ginger (3 slices), water (8 cups), salt (to taste)',
        'instructions': '1. Soak lily bulbs for 1 hour.\n2. Clean frog thoroughly and blanch in boiling water with ginger for 5 minutes. Rinse and drain.\n3. Place frog in a double boiler or large pot with water.\n4. Add American ginseng, figs, lily bulbs, Chinese yam, and remaining ginger.\n5. Bring to boil, then reduce heat to very low.\n6. Double-boil for 2.5-3 hours or simmer gently for 2 hours.\n7. Add dates, longan, and goji berries in the last 30 minutes.\n8. Season with salt to taste.\n9. Serve hot.',
        'benefits': 'Powerful tonic traditionally used to nourish lungs and moisturize dry respiratory passages. American ginseng is cooling and helps reduce body heat while boosting energy without overstimulation. Frog meat is rich in protein and considered beneficial for respiratory health. The soup helps relieve chronic cough, dry throat, and lung conditions. Lily bulbs calm the mind and improve sleep quality. Excellent for people with dry constitution, smokers, or those with respiratory issues. The combination supports overall wellness and longevity.',
        'category': 'tonic',
        'season': 'autumn',
        'created_at': DateTime.now().toIso8601String(),
      },
    ];

    for (var recipe in recipesData) {
      await db.insert('recipes', recipe);
    }
  }

  Database get database => _database!;
}
