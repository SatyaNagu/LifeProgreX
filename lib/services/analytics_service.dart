import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/habit_model.dart';
import '../models/mood_log_model.dart';
import '../models/achievement_model.dart';
import '../models/activity_model.dart';
import 'achievement_service.dart';

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
  final List<String> earnedBadges;
  final int readingMinutes;
  final int workoutSessions;
  final int learningMinutes;
  final int habitsCompleted;

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
    required this.earnedBadges,
    required this.readingMinutes,
    required this.workoutSessions,
    required this.learningMinutes,
    required this.habitsCompleted,
  });
}

class AnalyticsService {
  final AchievementService _achievementService = AchievementService();
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

    // Notify achievements
    await _achievementService.notifyActivity('mood_logged');
  }

  // Listens to all analytics data reactively
  Stream<AnalyticsData> getAnalyticsDataStream(String timeframe) {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    // Dynamic timeframe scoping
    final now = DateTime.now();
    DateTime startTime;
    switch (timeframe.toLowerCase()) {
      case 'today':
      case 'day':
        startTime = DateTime(now.year, now.month, now.day);
        break;
      case 'week':
        startTime = now.subtract(const Duration(days: 7));
        break;
      case 'month':
        startTime = DateTime(now.year, now.month - 1, now.day);
        break;
      case 'year':
        startTime = DateTime(now.year - 1, now.month, now.day);
        break;
      default:
        startTime = now.subtract(const Duration(days: 7));
    }

    return _db
        .collection('habits')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .asyncMap((habitSnapshot) async {
          final habits = habitSnapshot.docs
              .map((doc) => HabitModel.fromJson(doc.data(), doc.id))
              .toList();

          // Fetch Activities (Quick Logs) bounded by dynamic timeframe
          final activitySnapshot = await _db
              .collection('users')
              .doc(user.uid)
              .collection('activities')
              .where(
                'createdAt',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startTime),
              )
              .orderBy('createdAt', descending: true)
              .get();

          final activities = activitySnapshot.docs
              .map((doc) => ActivityLog.fromMap(doc.data(), doc.id))
              .toList();

          // Extrapolate Moods from Activities
          final moods = <MoodLogModel>[];
          for (var a in activities) {
            if (a.type.toLowerCase() == 'mood' && a.value != null) {
              int score = 4; // Default to 'Okay'
              final lbl = a.value!.toLowerCase();
              if (lbl == 'terrible') {
                score = 0;
              } else if (lbl == 'bad')
                score = 2;
              else if (lbl == 'okay')
                score = 4;
              else if (lbl == 'good')
                score = 6;
              else if (lbl == 'great')
                score = 8;
              else if (lbl == 'amazing')
                score = 10;

              final emoji = a.data['emoji'] ?? '😐';

              moods.add(
                MoodLogModel(
                  id: a.id,
                  userId: a.userId,
                  score: score,
                  emoji: emoji,
                  timestamp: a.createdAt,
                ),
              );
            }
          }

          // Fetch Earned Achievements
          final achievementSnapshot = await _db
              .collection('users')
              .doc(user.uid)
              .collection('achievements')
              .where('isUnlocked', isEqualTo: true)
              .get();

          final earnedBadgeIds = achievementSnapshot.docs
              .map((doc) => doc.id)
              .toList();

          return _computeAnalytics(
            habits,
            moods,
            activities,
            timeframe,
            earnedBadgeIds,
          );
        });
  }

  AnalyticsData _computeAnalytics(
    List<HabitModel> habits,
    List<MoodLogModel> moods,
    List<ActivityLog> activities,
    String timeframe,
    List<String> earnedBadgeIds,
  ) {
    // 1. Life Score (based on % of habits that have streaks > 0)
    double lifeScore = 0.0;
    int activeHabits = habits.where((h) => h.currentStreak > 0).length;
    if (habits.isNotEmpty) {
      lifeScore = activeHabits / habits.length;
    }

    // 2. Mood Stats (0-10 scale mapped mathematically)
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
      double progress = catHabits.isNotEmpty
          ? (active / catHabits.length)
          : 0.0;
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

    // Achievements
    final earnedBadges = AchievementConstants.allAchievements
        .where((def) => earnedBadgeIds.contains(def.id))
        .map((def) => def.badge)
        .toList();

    int achievementsCount = earnedBadgeIds.length;

    // Wellness scale 1-10
    double wellnessScore = (lifeScore * 10 + avgMood) / 2;
    if (wellnessScore.isNaN) wellnessScore = 0.0;

    // 6. Granular Stats for Life Resume
    int rMin = 0;
    int wCount = 0;
    int lMin = 0;
    int hCompleted = activities.length;

    for (var a in activities) {
      final type = a.type.toLowerCase();
      if (type.contains('read')) {
        rMin += (a.duration ?? 0);
      } else if (type.contains('workout') ||
          type.contains('gym') ||
          type.contains('fit')) {
        wCount++;
      } else if (type.contains('learn') || type.contains('skill')) {
        lMin += (a.duration ?? 0);
      }
    }

    // Securely trim timelineEvents to last 20 inside memory to prevent UI lag.
    final timelineEvents = activities
        .take(20)
        .map((a) => {'type': a.type, 'time': a.createdAt})
        .toList();

    return AnalyticsData(
      lifeScore: lifeScore,
      averageMood: avgMood, // Contains the 0-10 float metric
      weekMoods:
          moods, // Now accurately bound dynamically to the timeframe logs
      categoryStats: catStats,
      maxStreak: maxStreak,
      totalGoals: totalGoals,
      achievements: achievementsCount,
      wellnessScore: wellnessScore,
      timelineEvents: timelineEvents,
      earnedBadges: earnedBadges,
      readingMinutes: rMin,
      workoutSessions: wCount,
      learningMinutes: lMin,
      habitsCompleted: hCompleted,
    );
  }
}
