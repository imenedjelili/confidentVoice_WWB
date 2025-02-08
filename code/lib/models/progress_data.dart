class ProgressData {
  final Duration todayReadingTime;
  final int todayContributions;
  final List<DailyProgress> weeklyProgress;
  final int totalContributions;
  final List<Achievement> achievements;
  final int currentStreak;

  ProgressData({
    required this.todayReadingTime,
    required this.todayContributions,
    required this.weeklyProgress,
    required this.totalContributions,
    required this.achievements,
    required this.currentStreak,
  });

  factory ProgressData.fromMap(Map<String, dynamic> map) {
    return ProgressData(
      todayReadingTime: Duration(minutes: map['todayReadingTime'] ?? 0),
      todayContributions: map['todayContributions'] ?? 0,
      weeklyProgress: List<DailyProgress>.from(
        (map['weeklyProgress'] ?? []).map((x) => DailyProgress.fromMap(x)),
      ),
      totalContributions: map['totalContributions'] ?? 0,
      achievements: List<Achievement>.from(
        (map['achievements'] ?? []).map((x) => Achievement.fromMap(x)),
      ),
      currentStreak: map['currentStreak'] ?? 0,
    );
  }
}

class DailyProgress {
  final DateTime date;
  final Duration readingTime;
  final int contributions;

  DailyProgress({
    required this.date,
    required this.readingTime,
    required this.contributions,
  });

  factory DailyProgress.fromMap(Map<String, dynamic> map) {
    return DailyProgress(
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      readingTime: Duration(minutes: map['readingTime'] ?? 0),
      contributions: map['contributions'] ?? 0,
    );
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final double progress; // 0.0 to 1.0

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.isUnlocked,
    this.unlockedAt,
    required this.progress,
  });

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      icon: map['icon'] ?? '',
      isUnlocked: map['isUnlocked'] ?? false,
      unlockedAt: map['unlockedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['unlockedAt'])
          : null,
      progress: map['progress']?.toDouble() ?? 0.0,
    );
  }
}
