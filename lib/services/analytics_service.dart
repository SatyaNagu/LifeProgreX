import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/habit_model.dart';
import '../models/mood_log_model.dart';

class AnalyticsData {
  final double lifeScore;
  final double averageMood;
  final List<MoodLogModel> weekMoods;
  final Map<HabitCategory, Map<String, dynamic>> categoryStats;
  final int maxStreak;
  final int totalGoals;
  final int achievements;
  final double wellnessScore;
  final List<Map<String, dynamic>> timelineEvents;

  AnalyticsData({
    required this.lifeScore,
    required this.averageMood,
    required this.weekMoods,
    required this.categoryStats,
    required this.maxStreak,
    required this.totalGoals,
    required this.achievements,
    required this.wellnessScore,
    required this.timelineEvents,
  });
}

class AnalyticsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Save mood to a new user subcollection
  Future<void> logMood(int score, String emoji) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    await _db.collection('users').doc(user.uid).collection('mood_logs').add({
      'userId': user.uid,
      'score': score,
      'emoji': emoji,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Listens to all analytics data reactively
  Stream<AnalyticsData> getAnalyticsDataStream(String timeframe) {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    // We use RxDart or just parallel streams. To keep it simple without adding new dependencies,
    // we'll stream Habits and combine data using a Future inside the stream, 
    // or just listen to the Habit stream and periodically fetch Moods/Activities.
    
    // For a simple stream implementation, we'll stream habits, then future-fetch the rest:
    return _db
        .collection('habits')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .asyncMap((habitSnapshot) async {
      
      final habits = habitSnapshot.docs
          .map((doc) => HabitModel.fromJson(doc.data(), doc.id))
          .toList();

      // Fetch Mood Logs (Last 7 days for ease)
      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
      final moodSnapshot = await _db
          .collection('users')
          .doc(user.uid)
          .collection('mood_logs')
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(sevenDaysAgo))
          .orderBy('timestamp', descending: true)
          .get();

      final moods = moodSnapshot.docs
          .map((doc) => MoodLogModel.fromJson(doc.data(), doc.id))
          .toList();

      // Fetch Activities (Quick Logs)
      final activitySnapshot = await _db
          .collection('users')
          .doc(user.uid)
          .collection('activities')
          .orderBy('createdAt', descending: true)
          .limit(20) // Limit to recent 20 for timeline
          .get();
          
      final activities = activitySnapshot.docs.map((doc) => doc.data()).toList();

      return _computeAnalytics(habits, moods, activities, timeframe);
    });
  }

  AnalyticsData _computeAnalytics(
    List<HabitModel> habits, 
    List<MoodLogModel> moods, 
    List<Map<String, dynamic>> activities, 
    String timeframe
  ) {
    // 1. Life Score (based on % of habits that have streaks > 0, just a proxy metric)
    double lifeScore = 0.0;
    int activeHabits = habits.where((h) => h.currentStreak > 0).length;
    if (habits.isNotEmpty) {
      lifeScore = activeHabits / habits.length;
    }

    // 2. Mood Stats
    double totalMood = 0;
    for (var m in moods) {
      totalMood += m.score;
    }
    double avgMood = moods.isNotEmpty ? (totalMood / moods.length) : 0.0;

    // 3. Category Stats
    Map<HabitCategory, Map<String, dynamic>> catStats = {};
    for (var category in HabitCategory.values) {
       final catHabits = habits.where((h) => h.category == category).toList();
       int active = catHabits.where((h) => h.currentStreak > 0).length;
       double progress = catHabits.isNotEmpty ? (active / catHabits.length) : 0.0;
       catStats[category] = {
         'progress': progress,
         'active': active,
         'total': catHabits.length,
       };
    }

    // 4. Max Streak & Goals
    int maxStreak = 0;
    for (var h in habits) {
      if (h.currentStreak > maxStreak) maxStreak = h.currentStreak;
    }
    int totalGoals = habits.length;
    
    // Achievements (e.g. streaks > 10)
    int achievements = habits.where((h) => h.currentStreak >= 10).length;
    
    // Wellness scale 1-10
    double wellnessScore = (lifeScore * 10 + avgMood) / 2;
    if (wellnessScore.isNaN) wellnessScore = 0.0;

    // 5. Timeline Formatting (Basic mapping)
    List<Map<String, dynamic>> timeline = activities.map((a) {
      final t = a['createdAt'] as Timestamp?;
      return {
        'type': a['type'] ?? 'Unknown',
        'time': t?.toDate() ?? DateTime.now(),
      };
    }).toList();

    return AnalyticsData(
      lifeScore: lifeScore,
      averageMood: avgMood,
      weekMoods: moods,
      categoryStats: catStats,
      maxStreak: maxStreak,
      totalGoals: totalGoals,
      achievements: achievements,
      wellnessScore: wellnessScore,
      timelineEvents: timeline,
    );
  }
}
