import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/activity_model.dart';
import 'firestore_service.dart';
import '../utils/quick_log_manager.dart';

class ActivityService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static CollectionReference _getUserActivities(String userId) {
    return _firestore.collection('users').doc(userId).collection('activities');
  }

  static Future<void> saveActivity(ActivityLog activity) async {
    try {
      await _getUserActivities(activity.userId)
          .add(activity.toMap())
          .timeout(const Duration(seconds: 10));

      // Quietly attempt to increment the Habit streak if an explicit matching Habit exists!
      try {
        final String formattedType = activity.type.isNotEmpty 
            ? '${activity.type[0].toUpperCase()}${activity.type.substring(1).toLowerCase()}' 
            : activity.type;
        await FirestoreService().logActivityByTitle(formattedType, note: activity.notes);
        // Hide the Quick Log from the user's dashboard for the rest of the day
        await QuickLogManager.markAsCompleted(activity.type);
      } catch (e) {
        // If the user hasn't created a rigid Habit mapped to this exact template yet, 
        // silently bypass this exception to allow raw Activity Logs to persist functionally standalone.
        debugPrint('Background streak sync bypassed: $e');
      }
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
