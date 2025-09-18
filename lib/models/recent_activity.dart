class RecentActivity {
  final String student;
  final String subject;
  final String action;
  final String time;
  final String type;

  RecentActivity({
    required this.student,
    required this.subject,
    required this.action,
    required this.time,
    required this.type,
  });

  static List<RecentActivity> get sampleData => [
    RecentActivity(
      student: "राज कुमार",
      subject: "गणित",
      action: "पाठ पूरा किया",
      time: "2 मिनट पहले",
      type: "success",
    ),
    RecentActivity(
      student: "सुनीता शर्मा",
      subject: "हिंदी",
      action: "कुइज़ में संघर्ष",
      time: "15 मिनट पहले",
      type: "warning",
    ),
    RecentActivity(
      student: "अमित सिंह",
      subject: "अंग्रेजी",
      action: "7 दिन की लकीर पूरी",
      time: "1 घंटा पहले",
      type: "success",
    ),
  ];
}