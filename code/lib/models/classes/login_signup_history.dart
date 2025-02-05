class LoginSignupHistory {
  final int id;
  final int userId;
  final String timestamp;
  final String activity;

  const LoginSignupHistory({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.activity,
  });

  factory LoginSignupHistory.fromMap(Map<String, dynamic> map) {
    return LoginSignupHistory(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      timestamp: map['timestamp'] as String,
      activity: map['activity'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'timestamp': timestamp,
      'activity': activity,
    };
  }

  @override
  String toString() {
    return 'LoginSignupHistory{id: $id, userId: $userId, timestamp: $timestamp, activity: $activity}';
  }
}
