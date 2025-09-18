class Progress {
  final int? progressId;
  final int studentId;
  final int lessonId;
  final bool isCompleted;
  final int timeSpentMinutes;
  final DateTime lastAccessed;

  Progress({
    this.progressId,
    required this.studentId,
    required this.lessonId,
    this.isCompleted = false,
    this.timeSpentMinutes = 0,
    required this.lastAccessed,
  });

  Map<String, dynamic> toMap() {
    return {
      'progress_id': progressId,
      'student_id': studentId,
      'lesson_id': lessonId,
      'is_completed': isCompleted ? 1 : 0,
      'time_spent_minutes': timeSpentMinutes,
      'last_accessed': lastAccessed.toIso8601String(),
    };
  }

  factory Progress.fromMap(Map<String, dynamic> map) {
    return Progress(
      progressId: map['progress_id'],
      studentId: map['student_id'],
      lessonId: map['lesson_id'],
      isCompleted: map['is_completed'] == 1,
      timeSpentMinutes: map['time_spent_minutes'] ?? 0,
      lastAccessed: DateTime.parse(map['last_accessed']),
    );
  }

  Progress copyWith({
    int? progressId,
    int? studentId,
    int? lessonId,
    bool? isCompleted,
    int? timeSpentMinutes,
    DateTime? lastAccessed,
  }) {
    return Progress(
      progressId: progressId ?? this.progressId,
      studentId: studentId ?? this.studentId,
      lessonId: lessonId ?? this.lessonId,
      isCompleted: isCompleted ?? this.isCompleted,
      timeSpentMinutes: timeSpentMinutes ?? this.timeSpentMinutes,
      lastAccessed: lastAccessed ?? this.lastAccessed,
    );
  }
}
