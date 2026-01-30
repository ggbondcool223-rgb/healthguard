class UserInfo {
  final int? id;
  final int? age;
  final double? height;
  final double? weight;
  final String? medicalHistory;
  final String? lastCheckIn;
  final int? checkInStreak;
  final String? createdAt;

  const UserInfo({
    this.id,
    this.age,
    this.height,
    this.weight,
    this.medicalHistory,
    this.lastCheckIn,
    this.checkInStreak,
    this.createdAt,
  });

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      id: map['id'] as int?,
      age: map['age'] as int?,
      height: map['height'] as double?,
      weight: map['weight'] as double?,
      medicalHistory: map['medical_history'] as String?,
      lastCheckIn: map['last_check_in'] as String?,
      checkInStreak: map['check_in_streak'] as int?,
      createdAt: map['created_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'age': age,
      'height': height,
      'weight': weight,
      'medical_history': medicalHistory,
      'last_check_in': lastCheckIn,
      'check_in_streak': checkInStreak,
      'created_at': createdAt ?? DateTime.now().toIso8601String(),
    };
  }
}

class BloodSugar {
  final int? id;
  final double value;
  final String type;
  final String status;
  final String createdAt;

  const BloodSugar({
    this.id,
    required this.value,
    required this.type,
    required this.status,
    required this.createdAt,
  });

  factory BloodSugar.fromMap(Map<String, dynamic> map) {
    return BloodSugar(
      id: map['id'] as int?,
      value: map['value'] as double,
      type: map['type'] as String,
      status: map['status'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'value': value,
      'type': type,
      'status': status,
      'created_at': createdAt,
    };
  }
}

class BloodPressure {
  final int? id;
  final int systolic;
  final int diastolic;
  final String status;
  final String createdAt;

  const BloodPressure({
    this.id,
    required this.systolic,
    required this.diastolic,
    required this.status,
    required this.createdAt,
  });

  factory BloodPressure.fromMap(Map<String, dynamic> map) {
    return BloodPressure(
      id: map['id'] as int?,
      systolic: map['systolic'] as int,
      diastolic: map['diastolic'] as int,
      status: map['status'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'systolic': systolic,
      'diastolic': diastolic,
      'status': status,
      'created_at': createdAt,
    };
  }
}

class HeartRate {
  final int? id;
  final int value;
  final String status;
  final String createdAt;

  const HeartRate({
    this.id,
    required this.value,
    required this.status,
    required this.createdAt,
  });

  factory HeartRate.fromMap(Map<String, dynamic> map) {
    return HeartRate(
      id: map['id'] as int?,
      value: map['value'] as int,
      status: map['status'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'value': value,
      'status': status,
      'created_at': createdAt,
    };
  }
}

class CheckIn {
  final int? id;
  final String date;
  final String createdAt;

  const CheckIn({
    this.id,
    required this.date,
    required this.createdAt,
  });

  factory CheckIn.fromMap(Map<String, dynamic> map) {
    return CheckIn(
      id: map['id'] as int?,
      date: map['date'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'date': date,
      'created_at': createdAt,
    };
  }
}

class Article {
  final int? id;
  final String title;
  final String content;
  final String category;
  final String source;
  final String createdAt;

  const Article({
    this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.source,
    required this.createdAt,
  });

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      category: map['category'] as String,
      source: map['source'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'content': content,
      'category': category,
      'source': source,
      'created_at': createdAt,
    };
  }
}

class Recipe {
  final int? id;
  final String name;
  final String ingredients;
  final String instructions;
  final String benefits;
  final String category;
  final String? season;
  final String createdAt;

  const Recipe({
    this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.benefits,
    required this.category,
    this.season,
    required this.createdAt,
  });

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] as int?,
      name: map['name'] as String,
      ingredients: map['ingredients'] as String,
      instructions: map['instructions'] as String,
      benefits: map['benefits'] as String,
      category: map['category'] as String,
      season: map['season'] as String?,
      createdAt: map['created_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'ingredients': ingredients,
      'instructions': instructions,
      'benefits': benefits,
      'category': category,
      'season': season,
      'created_at': createdAt,
    };
  }
}
