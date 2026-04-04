import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/activity_model.dart';
import 'firestore_service.dart';
import 'achievement_service.dart';

class ActivityService {
  static final AchievementService _achievementService = AchievementService();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static CollectionReference _getUserActivities(String userId) {
    return _firestore.collection('users').doc(userId).collection('activities');
  }

  static Future<void> saveActivity(ActivityLog activity) async {
    try {
      await _getUserActivities(activity.userId)
          .add(activity.toMap())
          .timeout(const Duration(seconds: 10));

      try {
        final String formattedType = activity.type.isNotEmpty 
            ? '${activity.type[0].toUpperCase()}${activity.type.substring(1).toLowerCase()}' 
            : activity.type;
        await FirestoreService().logActivityByTitle(formattedType, note: activity.notes);
      } catch (e) {
        // If the user hasn't created a rigid Habit mapped to this exact template yet, 
        // silently bypass this exception to allow raw Activity Logs to persist functionally standalone.
        debugPrint('Background streak sync bypassed: $e');
      }

      // Notify achievements service
      await _achievementService.notifyActivity('activity_logged', context: {'type': activity.type});
    } on TimeoutException {
      // If server sync takes too long, we assume success because Firestore
      // will persist locally and sync in the background.
      debugPrint('Activity save timed out, will sync in background');
    } catch (e) {
      debugPrint('Error saving activity: $e');
      rethrow;
    }
  }

  static Stream<List<ActivityLog>> listenToActivities(String userId) {
    return _getUserActivities(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ActivityLog.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  static Future<void> deleteActivity(String userId, String activityId) async {
    try {
      await _getUserActivities(userId).doc(activityId).delete();
    } catch (e) {
      debugPrint('Error deleting activity: $e');
      rethrow;
    }
  }
}
