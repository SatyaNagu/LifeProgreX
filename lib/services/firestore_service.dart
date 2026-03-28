import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/habit_model.dart';
import 'dart:developer';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add a new habit mapping UID exactly as stipulated by Security Rules
  Future<void> addHabit(HabitModel habit) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User must be logged in to add a habit.');

      // Ensure the habit is written to this specific user exactly
      final habitData = habit.toJson();
      habitData['userId'] = user.uid; // Hardware-level safety override

      // Write to Firestore using an auto-generated Document ID
      await _db.collection('habits').add(habitData);
    } on FirebaseException catch (e) {
      throw Exception('Database Error adding Habit: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Logs a new execution step and increments the current streak using a true database transaction
  Future<void> logActivity(String habitId, {String? note}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User must be logged in to log activity.');

      final habitRef = _db.collection('habits').doc(habitId);

      await _db.runTransaction((transaction) async {
        final habitDoc = await transaction.get(habitRef);
        if (!habitDoc.exists) {
          throw Exception('Habit does not exist.');
        }
        
        // Ensure user owns this habit before permitting transaction mutability
        if (habitDoc.data()?['userId'] != user.uid) {
           throw Exception('Permission denied: Identity mismatch.');
        }

        // Increment the streak safely by 1
        final int currentStreak = habitDoc.data()?['currentStreak'] ?? 0;
        transaction.update(habitRef, {'currentStreak': currentStreak + 1});

        // Add the discrete log event atomically 
        final logRef = _db.collection('activity_logs').doc();
        transaction.set(logRef, {
          'habitId': habitId,
          'userId': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
          'note': note,
        });
      });
    } on FirebaseException catch (e) {
      throw Exception('Database Error logging Activity: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected Transaction error: $e');
    }
  }

  // Locates the generic Title of a user's Habit array to retrieve its unique Document UUID, before running the transaction.
  Future<void> logActivityByTitle(String title, {String? note}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User must be logged in to log activity.');

      final snapshot = await _db
          .collection('habits')
          .where('userId', isEqualTo: user.uid)
          .where('title', isEqualTo: title)
          .limit(1)
          .get();

      String habitId;
      if (snapshot.docs.isEmpty) {
        // Auto-create the prerequisite Habit object to securely track the new Streak!
        final newHabit = HabitModel(
          id: '',
          userId: user.uid,
          title: title,
          category: HabitCategory.health, // Default enum category
          createdAt: DateTime.now(),
          currentStreak: 0,
        );
        final habitData = newHabit.toJson();
        habitData['userId'] = user.uid; // Security constraint
        final docRef = await _db.collection('habits').add(habitData);
        habitId = docRef.id;
      } else {
        habitId = snapshot.docs.first.id;
      }

      // Execute the native unified transaction
      await logActivity(habitId, note: note);
    } on FirebaseException catch (e) {
      throw Exception('Database Error looking up "$title": ${e.message}');
    } catch (e) {
      throw Exception('Unexpected Lookup error: $e');
    }
  }

  // Creates a secure realtime WebSocket connection returning only this specific user's streams
  Stream<List<HabitModel>> getHabitsStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    try {
      return _db
          .collection('habits')
          .where('userId', isEqualTo: user.uid)
          .snapshots()
          .map((snapshot) {
              final models = snapshot.docs
                  .map((doc) => HabitModel.fromJson(doc.data(), doc.id))
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
