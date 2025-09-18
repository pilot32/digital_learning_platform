class Subject {
  final int? subjectId;
  final String subjectName;
  final String description;
  final int totalLessons;
  final String category; // 'main' or 'advanced'
  final String icon;
  final String color;

  Subject({
    this.subjectId,
    required this.subjectName,
    required this.description,
    required this.totalLessons,
    required this.category,
    required this.icon,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'subject_id': subjectId,
      'subject_name': subjectName,
      'description': description,
      'total_lessons': totalLessons,
      'category': category,
      'icon': icon,
      'color': color,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      subjectId: map['subject_id'],
      subjectName: map['subject_name'],
      description: map['description'],
      totalLessons: map['total_lessons'],
      category: map['category'],
      icon: map['icon'],
      color: map['color'],
    );
  }

  Subject copyWith({
    int? subjectId,
    String? subjectName,
    String? description,
    int? totalLessons,
    String? category,
    String? icon,
    String? color,
  }) {
    return Subject(
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      description: description ?? this.description,
      totalLessons: totalLessons ?? this.totalLessons,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }
}
