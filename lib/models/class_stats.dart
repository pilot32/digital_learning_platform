class ClassStats {
  final String subject;
  final int students;
  final int progress;
  final int struggling;
  final String icon;

  ClassStats({
    required this.subject,
    required this.students,
    required this.progress,
    required this.struggling,
    required this.icon,
  });

  static List<ClassStats> get sampleData => [
    ClassStats(
      subject: "हिंदी",
      students: 45,
      progress: 68,
      struggling: 8,
      icon: "📚",
    ),
    ClassStats(
      subject: "अंग्रेजी",
      students: 42,
      progress: 54,
      struggling: 12,
      icon: "🇬🇧",
    ),
    ClassStats(
      subject: "गणित",
      students: 48,
      progress: 42,
      struggling: 18,
      icon: "🔢",
    ),
  ];
}