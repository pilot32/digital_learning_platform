class Student {
  final int? studentId;
  final String name;
  final String email;
  final String password; // hashed
  final String grade;
  final String? profileImageUrl;
  final int streakDays;
  final int totalStars;
  final int badgesEarned;
  final DateTime createdAt;

  Student({
    this.studentId,
    required this.name,
    required this.email,
    required this.password,
    required this.grade,
    this.profileImageUrl,
    this.streakDays = 0,
    this.totalStars = 0,
    this.badgesEarned = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'student_id': studentId,
      'name': name,
      'email': email,
      'password': password,
      'grade': grade,
      'profile_image_url': profileImageUrl,
      'streak_days': streakDays,
      'total_stars': totalStars,
      'badges_earned': badgesEarned,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      studentId: map['student_id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      grade: map['grade'],
      profileImageUrl: map['profile_image_url'],
      streakDays: map['streak_days'] ?? 0,
      totalStars: map['total_stars'] ?? 0,
      badgesEarned: map['badges_earned'] ?? 0,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Student copyWith({
    int? studentId,
    String? name,
    String? email,
    String? password,
    String? grade,
    String? profileImageUrl,
    int? streakDays,
    int? totalStars,
    int? badgesEarned,
    DateTime? createdAt,
  }) {
    return Student(
      studentId: studentId ?? this.studentId,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      grade: grade ?? this.grade,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      streakDays: streakDays ?? this.streakDays,
      totalStars: totalStars ?? this.totalStars,
      badgesEarned: badgesEarned ?? this.badgesEarned,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
