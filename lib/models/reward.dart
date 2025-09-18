class Reward {
  final int? rewardId;
  final int studentId;
  final String rewardType; // 'star', 'badge', 'streak'
  final int rewardValue;
  final DateTime earnedAt;
  final String? description;

  Reward({
    this.rewardId,
    required this.studentId,
    required this.rewardType,
    required this.rewardValue,
    required this.earnedAt,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'reward_id': rewardId,
      'student_id': studentId,
      'reward_type': rewardType,
      'reward_value': rewardValue,
      'earned_at': earnedAt.toIso8601String(),
      'description': description,
    };
  }

  factory Reward.fromMap(Map<String, dynamic> map) {
    return Reward(
      rewardId: map['reward_id'],
      studentId: map['student_id'],
      rewardType: map['reward_type'],
      rewardValue: map['reward_value'],
      earnedAt: DateTime.parse(map['earned_at']),
      description: map['description'],
    );
  }

  Reward copyWith({
    int? rewardId,
    int? studentId,
    String? rewardType,
    int? rewardValue,
    DateTime? earnedAt,
    String? description,
  }) {
    return Reward(
      rewardId: rewardId ?? this.rewardId,
      studentId: studentId ?? this.studentId,
      rewardType: rewardType ?? this.rewardType,
      rewardValue: rewardValue ?? this.rewardValue,
      earnedAt: earnedAt ?? this.earnedAt,
      description: description ?? this.description,
    );
  }
}
