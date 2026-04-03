import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/goal_model.dart';
import 'dart:developer';

class GoalService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addGoal(GoalModel goal) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User must be logged in to add a goal.');

      final goalData = goal.toJson();
      goalData['userId'] = user.uid; // Hardware-level safety override

      await _db.collection('users').doc(user.uid).collection('goals').add(goalData);
    } on FirebaseException catch (e) {
      throw Exception('Database Error adding Goal: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> updateGoal(GoalModel goal) async {
    try {
      final user = _auth.currentUser;
      if (user == null || goal.id.isEmpty) throw Exception('Validation failed.');

      final goalData = goal.toJson();
      await _db.collection('users').doc(user.uid).collection('goals').doc(goal.id).update(goalData);
    } on FirebaseException catch (e) {
      throw Exception('Database Error updating Goal: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> deleteGoal(String id) async {
    try {
      final user = _auth.currentUser;
       if (user == null) throw Exception('Not logged in');
      if (id.isEmpty) throw Exception('Invalid ID.');
      await _db.collection('users').doc(user.uid).collection('goals').doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception('Database Error deleting Goal: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Stream<List<GoalModel>> getGoalsStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    try {
      return _db
          .collection('users')
          .doc(user.uid)
          .collection('goals')
          .snapshots()
          .map((snapshot) {
              final models = snapshot.docs
                  .map((doc) => GoalModel.fromJson(doc.data(), doc.id))
                  .toList();
                  
              // Sort locally to completely bypass Firebase Composite Index restrictions
              models.sort((a, b) => b.createdAt.compareTo(a.createdAt));
              return models;
          });
    } on FirebaseException catch (e) {
      log('Firestore Stream Initialization Error: ${e.message}');
      throw Exception('Streaming Error: ${e.message}');
    } catch (e) {
      log('Unexpected Stream Error: $e');
      throw Exception('Unexpected Stream Error: $e');
    }
  }
}
