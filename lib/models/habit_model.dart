import 'package:cloud_firestore/cloud_firestore.dart';

enum HabitCategory { health, knowledge, career, happiness }

class HabitModel {
  final String id;
  final String userId;
  final String title;
  final HabitCategory category;
  final DateTime createdAt;
  final int currentStreak;

  HabitModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.category,
    required this.createdAt,
    this.currentStreak = 0,
  });

  factory HabitModel.fromJson(Map<String, dynamic> json, String documentId) {
    final timestamp = json['createdAt'] as Timestamp?;
    
    // Parse category safely across the boundary
    HabitCategory parsedCategory = HabitCategory.health;
    final categoryStr = json['category'] as String?;
    if (categoryStr != null) {
      parsedCategory = HabitCategory.values.firstWhere(
        (e) => e.toString().split('.').last.toLowerCase() == categoryStr.toLowerCase(),
        orElse: () => HabitCategory.health,
      );
    }

    return HabitModel(
      id: documentId,
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      category: parsedCategory,
      createdAt: timestamp?.toDate() ?? DateTime.now(),
      currentStreak: json['currentStreak'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'category': category.toString().split('.').last[0].toUpperCase() + category.toString().split('.').last.substring(1),
      'createdAt': Timestamp.fromDate(createdAt),
      'currentStreak': currentStreak,
    };
  }
}
