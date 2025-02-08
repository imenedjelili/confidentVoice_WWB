import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:confident_voice/models/progress_data.dart';

class ProgressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateReadingTime(Duration time) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month}-${today.day}';

    await _firestore.collection('user_progress').doc(user.uid).set({
      'lastReadDate': today.millisecondsSinceEpoch,
      'dailyProgress.$todayStr.readingTime': FieldValue.increment(time.inMinutes),
    }, SetOptions(merge: true));

    await _updateStreak();
  }

  Future<void> updateContributions() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month}-${today.day}';

    await _firestore.collection('user_progress').doc(user.uid).set({
      'lastContributionDate': today.millisecondsSinceEpoch,
      'dailyProgress.$todayStr.contributions': FieldValue.increment(1),
      'totalContributions': FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  Future<void> _updateStreak() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _firestore.collection('user_progress').doc(user.uid).get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final lastReadDate = DateTime.fromMillisecondsSinceEpoch(data['lastReadDate'] ?? 0);
    final today = DateTime.now();

    if (lastReadDate.difference(today).inDays.abs() <= 1) {
      await _firestore.collection('user_progress').doc(user.uid).set({
        'currentStreak': FieldValue.increment(1),
      }, SetOptions(merge: true));
    } else {
      await _firestore.collection('user_progress').doc(user.uid).set({
        'currentStreak': 1,
      }, SetOptions(merge: true));
    }
  }

  Future<ProgressData> getProgressData() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final doc = await _firestore.collection('user_progress').doc(user.uid).get();
    if (!doc.exists) {
      return ProgressData(
        todayReadingTime: Duration.zero,
        todayContributions: 0,
        weeklyProgress: [],
        totalContributions: 0,
        achievements: [],
        currentStreak: 0,
      );
    }

    final data = doc.data()!;
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month}-${today.day}';

    final weeklyProgress = <DailyProgress>[];
    for (int i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final dateStr = '${date.year}-${date.month}-${date.day}';
      final dailyData = (data['dailyProgress'] ?? {})[dateStr] ?? {};
      
      weeklyProgress.add(DailyProgress(
        date: date,
        readingTime: Duration(minutes: dailyData['readingTime'] ?? 0),
        contributions: dailyData['contributions'] ?? 0,
      ));
    }

    return ProgressData(
      todayReadingTime: Duration(minutes: (data['dailyProgress'] ?? {})[todayStr]?['readingTime'] ?? 0),
      todayContributions: (data['dailyProgress'] ?? {})[todayStr]?['contributions'] ?? 0,
      weeklyProgress: weeklyProgress,
      totalContributions: data['totalContributions'] ?? 0,
      achievements: _getAchievements(data),
      currentStreak: data['currentStreak'] ?? 0,
    );
  }

  List<Achievement> _getAchievements(Map<String, dynamic> data) {
    final totalContributions = data['totalContributions'] ?? 0;
    final currentStreak = data['currentStreak'] ?? 0;

    return [
      Achievement(
        id: 'first_contribution',
        title: 'First Contribution',
        description: 'Make your first contribution',
        icon: '🌟',
        isUnlocked: totalContributions > 0,
        progress: totalContributions > 0 ? 1.0 : 0.0,
      ),
      Achievement(
        id: 'contribution_master',
        title: 'Contribution Master',
        description: 'Make 100 contributions',
        icon: '👑',
        isUnlocked: totalContributions >= 100,
        progress: (totalContributions / 100).clamp(0.0, 1.0),
      ),
      Achievement(
        id: 'streak_warrior',
        title: 'Streak Warrior',
        description: 'Maintain a 7-day streak',
        icon: '🔥',
        isUnlocked: currentStreak >= 7,
        progress: (currentStreak / 7).clamp(0.0, 1.0),
      ),
    ];
  }
}
