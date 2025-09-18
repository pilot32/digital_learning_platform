class Lesson {
  final int? lessonId;
  final int subjectId;
  final String lessonTitle;
  final String lessonContent;
  final String? mediaUrl;
  final String status; // 'completed', 'in-progress', 'upcoming'
  final int durationMinutes;
  final int lesson_order;

  Lesson({
    this.lessonId,
    required this.subjectId,
    required this.lessonTitle,
    required this.lessonContent,
    this.mediaUrl,
    this.status = 'upcoming',
    required this.durationMinutes,
    required this.lesson_order,
  });

  Map<String, dynamic> toMap() {
    return {
      'lesson_id': lessonId,
      'subject_id': subjectId,
      'lesson_title': lessonTitle,
      'lesson_content': lessonContent,
      'media_url': mediaUrl,
      'status': status,
      'duration_minutes': durationMinutes,
      'lesson_order': lesson_order,
    };
  }

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      lessonId: map['lesson_id'],
      subjectId: map['subject_id'],
      lessonTitle: map['lesson_title'],
      lessonContent: map['lesson_content'],
      mediaUrl: map['media_url'],
      status: map['status'] ?? 'upcoming',
      durationMinutes: map['duration_minutes'],
      lesson_order: map['lesson_order'],
    );
  }

  Lesson copyWith({
    int? lessonId,
    int? subjectId,
    String? lessonTitle,
    String? lessonContent,
    String? mediaUrl,
    String? status,
    int? durationMinutes,
    int? lesson_order,
  }) {
    return Lesson(
      lessonId: lessonId ?? this.lessonId,
      subjectId: subjectId ?? this.subjectId,
      lessonTitle: lessonTitle ?? this.lessonTitle,
      lessonContent: lessonContent ?? this.lessonContent,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      status: status ?? this.status,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      lesson_order: lesson_order ?? this.lesson_order,
    );
  }
}
