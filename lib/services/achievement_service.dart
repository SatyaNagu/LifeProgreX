import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/achievement_model.dart';
import 'dart:developer' as dev;

class AchievementService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static final AchievementService _instance = AchievementService._internal();
  factory AchievementService() => _instance;
  AchievementService._internal();

  String? get _userId => _auth.currentUser?.uid;

  // Stream of all achievements with merged user progress (for Settings > Achievements)
  Stream<List<Map<String, dynamic>>> getAchievementsStream() {
    final uid = _userId;
    if (uid == null) return Stream.value([]);

    return _db
        .collection('users')
        .doc(uid)
        .collection('achievements')
        .snapshots()
        .map((snapshot) {
      final userAchievements = {
        for (var doc in snapshot.docs) 
          doc.id: UserAchievement.fromJson(doc.data())
      };

      return AchievementConstants.allAchievements.map((def) {
        final progress = userAchievements[def.id] ?? UserAchievement(achievementId: def.id);
        return {
          'definition': def,
          'progress': progress,
        };
      }).toList();
    });
  }

  // Stream of only unlocked achievements for the personal "Hall of Fame"
  Stream<List<Map<String, dynamic>>> getEarnedAchievementsStream() {
    final uid = _userId;
    if (uid == null) return Stream.value([]);

    return _db
        .collection('users')
        .doc(uid)
        .collection('achievements')
        .where('isUnlocked', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      final userAchievements = {
        for (var doc in snapshot.docs) 
          doc.id: UserAchievement.fromJson(doc.data())
      };

      // Filter definition list to only include those in unlocked set
      return AchievementConstants.allAchievements
          .where((def) => userAchievements.containsKey(def.id))
          .map((def) => {
            'definition': def,
            'progress': userAchievements[def.id]!,
          }).toList();
    });
  }

  // Notify the service that an activity occurred
  Future<void> notifyActivity(String activityType, {double value = 1.0, Map<String, dynamic>? context}) async {
    final uid = _userId;
    if (uid == null) return;

    // Logic to map activity types to achievement IDs
    List<String> affectedIds = [];

    if (activityType == 'habit_complete') {
      affectedIds.add('habit_comp_1');
      affectedIds.add('habit_total_100');
      affectedIds.add('habit_total_1000');
      affectedIds.add('habit_total_10000');
      
      final streak = context?['streak'] as int? ?? 0;
      if (streak >= 1) affectedIds.add('streak_1');
      if (streak >= 7) affectedIds.add('streak_7');
      if (streak >= 14) affectedIds.add('streak_14');
      if (streak >= 30) affectedIds.add('streak_30');
      if (streak >= 90) affectedIds.add('streak_90');
      if (streak >= 180) affectedIds.add('streak_180');
      if (streak >= 365) affectedIds.add('streak_365');
      if (streak >= 500) affectedIds.add('streak_500');
      if (streak >= 1000) affectedIds.add('streak_1000');
    } else if (activityType == 'habit_created') {
      affectedIds.add('habit_create_1');
      affectedIds.add('habit_create_5');
      affectedIds.add('habit_create_10');
      affectedIds.add('habit_create_25');
      affectedIds.add('habit_create_50');
      affectedIds.add('habit_create_100');
    } else if (activityType == 'mood_logged') {
      affectedIds.add('mood_1');
      affectedIds.add('mood_7');
      affectedIds.add('mood_30');
      affectedIds.add('mood_100');
      affectedIds.add('mood_365');
    } else if (activityType == 'goal_complete') {
      affectedIds.add('goal_comp_1');
      affectedIds.add('goal_comp_10');
      affectedIds.add('goal_comp_25');
    } else if (activityType == 'activity_logged') {
      final type = context?['type'] as String? ?? '';
      if (type.toLowerCase() == 'workout') {
         affectedIds.add('workout_1');
         affectedIds.add('workout_10');
         affectedIds.add('workout_50');
         affectedIds.add('workout_100');
         affectedIds.add('workout_250');
         affectedIds.add('workout_500');
      } else if (type.toLowerCase() == 'reading') {
         affectedIds.add('read_1');
         affectedIds.add('read_10');
         affectedIds.add('read_50');
         affectedIds.add('read_100');
      } else if (type.toLowerCase() == 'skill') {
         affectedIds.add('skill_1');
         affectedIds.add('skill_10');
         affectedIds.add('skill_50');
      }
    }

    for (var id in affectedIds) {
      await _updateAchievementProgress(uid, id, value.toInt());
    }
  }

  // Improved refreshAllAchievements logic to backfill habits, goals, and moods correctly.
  Future<void> refreshAllAchievements() async {
    final uid = _userId;
    if (uid == null) return;

    // 1. Habits & Streaks
    final habitsSnapshot = await _db.collection('habits').where('userId', isEqualTo: uid).get();
    int totalHabits = habitsSnapshot.docs.length;
    int maxStreak = 0;
    
    for (var doc in habitsSnapshot.docs) {
      final streak = doc.data()['currentStreak'] ?? 0;
      if (streak > maxStreak) maxStreak = streak;
    }

    // Update habit creation counts
    await _updateAchievementProgress(uid, 'habit_create_1', totalHabits, mode: 'set');
    await _updateAchievementProgress(uid, 'habit_create_5', totalHabits, mode: 'set');
    await _updateAchievementProgress(uid, 'habit_create_10', totalHabits, mode: 'set');
    await _updateAchievementProgress(uid, 'habit_create_25', totalHabits, mode: 'set');
    await _updateAchievementProgress(uid, 'habit_create_50', totalHabits, mode: 'set');
    await _updateAchievementProgress(uid, 'habit_create_100', totalHabits, mode: 'set');

    // Update streak counts
    await _updateAchievementProgress(uid, 'streak_1', maxStreak, mode: 'set');
    await _updateAchievementProgress(uid, 'streak_7', maxStreak, mode: 'set');
    await _updateAchievementProgress(uid, 'streak_14', maxStreak, mode: 'set');
    await _updateAchievementProgress(uid, 'streak_30', maxStreak, mode: 'set');
    await _updateAchievementProgress(uid, 'streak_90', maxStreak, mode: 'set');
    await _updateAchievementProgress(uid, 'streak_180', maxStreak, mode: 'set');
    await _updateAchievementProgress(uid, 'streak_365', maxStreak, mode: 'set');
    await _updateAchievementProgress(uid, 'streak_500', maxStreak, mode: 'set');
    await _updateAchievementProgress(uid, 'streak_1000', maxStreak, mode: 'set');

    // 2. Goals
    final goalsSnapshot = await _db.collection('users').doc(uid).collection('goals').get();
    int totalGoalComps = goalsSnapshot.docs.where((doc) => doc.data()['isCompleted'] == true).length;
    
    await _updateAchievementProgress(uid, 'goal_comp_1', totalGoalComps, mode: 'set');
    await _updateAchievementProgress(uid, 'goal_comp_10', totalGoalComps, mode: 'set');
    await _updateAchievementProgress(uid, 'goal_comp_25', totalGoalComps, mode: 'set');

    // 3. Mood Logs
    final moodSnapshot = await _db.collection('users').doc(uid).collection('mood_logs').get();
    int totalMoodLogs = moodSnapshot.docs.length;
    
    await _updateAchievementProgress(uid, 'mood_1', totalMoodLogs, mode: 'set');
    await _updateAchievementProgress(uid, 'mood_7', totalMoodLogs, mode: 'set');
    await _updateAchievementProgress(uid, 'mood_30', totalMoodLogs, mode: 'set');
    await _updateAchievementProgress(uid, 'mood_100', totalMoodLogs, mode: 'set');
    await _updateAchievementProgress(uid, 'mood_365', totalMoodLogs, mode: 'set');
  }

  Future<void> _updateAchievementProgress(String uid, String achievementId, int value, {String mode = 'increment'}) async {
    try {
      final ref = _db.collection('users').doc(uid).collection('achievements').doc(achievementId);
      final def = AchievementConstants.allAchievements.firstWhere((a) => a.id == achievementId);

      await _db.runTransaction((transaction) async {
        final doc = await transaction.get(ref);
        int current = 0;
        bool wasUnlocked = false;
        String? oldUnlockedAt;

        if (doc.exists) {
          current = doc.data()?['currentValue'] ?? 0;
          wasUnlocked = doc.data()?['isUnlocked'] ?? false;
          oldUnlockedAt = doc.data()?['unlockedAt'] as String?;
        }

        int newValue;
        if (mode == 'set') {
          newValue = value;
        } else {
          newValue = current + value;
        }
        
        // Safety check: don't decrease if it's already higher
        if (newValue < current && mode == 'set') {
           newValue = current;
        }

        bool isUnlocked = newValue >= def.targetValue;
        
        final data = {
          'achievementId': achievementId,
          'currentValue': newValue,
          'isUnlocked': isUnlocked,
          'unlockedAt': (isUnlocked && !wasUnlocked) 
              ? DateTime.now().toIso8601String() 
              : (wasUnlocked ? oldUnlockedAt : null),
        };

        transaction.set(ref, data);
        dev.log('Achievement Update: $achievementId -> $newValue (Unlocked: $isUnlocked)');
      });
    } catch (e) {
      dev.log('Error updating achievement $achievementId: $e');
    }
  }
}
