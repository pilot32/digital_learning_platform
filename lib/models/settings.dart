class Settings {
  final int? settingId;
  final int studentId;
  final String fontSize; // 'small', 'medium', 'large'
  final String appLanguage; // 'hindi', 'english'
  final bool downloadEnabled;

  Settings({
    this.settingId,
    required this.studentId,
    this.fontSize = 'medium',
    this.appLanguage = 'hindi',
    this.downloadEnabled = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'setting_id': settingId,
      'student_id': studentId,
      'font_size': fontSize,
      'app_language': appLanguage,
      'download_enabled': downloadEnabled ? 1 : 0,
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      settingId: map['setting_id'],
      studentId: map['student_id'],
      fontSize: map['font_size'] ?? 'medium',
      appLanguage: map['app_language'] ?? 'hindi',
      downloadEnabled: map['download_enabled'] == 1,
    );
  }

  Settings copyWith({
    int? settingId,
    int? studentId,
    String? fontSize,
    String? appLanguage,
    bool? downloadEnabled,
  }) {
    return Settings(
      settingId: settingId ?? this.settingId,
      studentId: studentId ?? this.studentId,
      fontSize: fontSize ?? this.fontSize,
      appLanguage: appLanguage ?? this.appLanguage,
      downloadEnabled: downloadEnabled ?? this.downloadEnabled,
    );
  }
}
