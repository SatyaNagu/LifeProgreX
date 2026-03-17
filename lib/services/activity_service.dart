import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/activity_model.dart';

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
    } on TimeoutException {
      // If server sync takes too long, we assume success because Firestore
      // will persist locally and sync in the background.
      print('Activity save timed out, will sync in background');
    } catch (e) {
      print('Error saving activity: $e');
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
      print('Error deleting activity: $e');
      rethrow;
    }
  }
}
