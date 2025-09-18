class Quiz {
  final int? quizId;
  final int subjectId;
  final String quizTitle;
  final int totalQuestions;

  Quiz({
    this.quizId,
    required this.subjectId,
    required this.quizTitle,
    required this.totalQuestions,
  });

  Map<String, dynamic> toMap() {
    return {
      'quiz_id': quizId,
      'subject_id': subjectId,
      'quiz_title': quizTitle,
      'total_questions': totalQuestions,
    };
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      quizId: map['quiz_id'],
      subjectId: map['subject_id'],
      quizTitle: map['quiz_title'],
      totalQuestions: map['total_questions'],
    );
  }

  Quiz copyWith({
    int? quizId,
    int? subjectId,
    String? quizTitle,
    int? totalQuestions,
  }) {
    return Quiz(
      quizId: quizId ?? this.quizId,
      subjectId: subjectId ?? this.subjectId,
      quizTitle: quizTitle ?? this.quizTitle,
      totalQuestions: totalQuestions ?? this.totalQuestions,
    );
  }
}

class QuizQuestion {
  final int? questionId;
  final int quizId;
  final String questionText;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctOption;

  QuizQuestion({
    this.questionId,
    required this.quizId,
    required this.questionText,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctOption,
  });

  Map<String, dynamic> toMap() {
    return {
      'question_id': questionId,
      'quiz_id': quizId,
      'question_text': questionText,
      'option_a': optionA,
      'option_b': optionB,
      'option_c': optionC,
      'option_d': optionD,
      'correct_option': correctOption,
    };
  }

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      questionId: map['question_id'],
      quizId: map['quiz_id'],
      questionText: map['question_text'],
      optionA: map['option_a'],
      optionB: map['option_b'],
      optionC: map['option_c'],
      optionD: map['option_d'],
      correctOption: map['correct_option'],
    );
  }

  QuizQuestion copyWith({
    int? questionId,
    int? quizId,
    String? questionText,
    String? optionA,
    String? optionB,
    String? optionC,
    String? optionD,
    String? correctOption,
  }) {
    return QuizQuestion(
      questionId: questionId ?? this.questionId,
      quizId: quizId ?? this.quizId,
      questionText: questionText ?? this.questionText,
      optionA: optionA ?? this.optionA,
      optionB: optionB ?? this.optionB,
      optionC: optionC ?? this.optionC,
      optionD: optionD ?? this.optionD,
      correctOption: correctOption ?? this.correctOption,
    );
  }
}

class QuizResult {
  final int? resultId;
  final int studentId;
  final int quizId;
  final int score;
  final DateTime completedAt;

  QuizResult({
    this.resultId,
    required this.studentId,
    required this.quizId,
    required this.score,
    required this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'result_id': resultId,
      'student_id': studentId,
      'quiz_id': quizId,
      'score': score,
      'completed_at': completedAt.toIso8601String(),
    };
  }

  factory QuizResult.fromMap(Map<String, dynamic> map) {
    return QuizResult(
      resultId: map['result_id'],
      studentId: map['student_id'],
      quizId: map['quiz_id'],
      score: map['score'],
      completedAt: DateTime.parse(map['completed_at']),
    );
  }

  QuizResult copyWith({
    int? resultId,
    int? studentId,
    int? quizId,
    int? score,
    DateTime? completedAt,
  }) {
    return QuizResult(
      resultId: resultId ?? this.resultId,
      studentId: studentId ?? this.studentId,
      quizId: quizId ?? this.quizId,
      score: score ?? this.score,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
