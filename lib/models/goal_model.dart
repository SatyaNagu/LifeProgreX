import 'package:cloud_firestore/cloud_firestore.dart';

enum GoalCategory { fitness, learning, wellness, career, habits, personal }

extension GoalCategoryExtension on GoalCategory {
  String get name {
    return toString().split('.').last;
  }
}

class GoalModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final GoalCategory category;
  final DateTime targetDate;
  final DateTime createdAt;
  final bool isCompleted;

  GoalModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.targetDate,
    required this.createdAt,
    this.isCompleted = false,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json, String documentId) {
    final tDate = json['targetDate'] as Timestamp?;
    final cDate = json['createdAt'] as Timestamp?;
    
    // Parse category safely
    GoalCategory parsedCategory = GoalCategory.personal;
    final categoryStr = json['category'] as String?;
    if (categoryStr != null) {
      parsedCategory = GoalCategory.values.firstWhere(
        (e) => e.toString().split('.').last.toLowerCase() == categoryStr.toLowerCase(),
        orElse: () => GoalCategory.personal,
      );
    }

    return GoalModel(
      id: documentId,
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: parsedCategory,
      targetDate: tDate?.toDate() ?? DateTime.now(),
      createdAt: cDate?.toDate() ?? DateTime.now(),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'category': category.toString().split('.').last[0].toUpperCase() + category.toString().split('.').last.substring(1),
      'targetDate': Timestamp.fromDate(targetDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'isCompleted': isCompleted,
    };
  }

  GoalModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    GoalCategory? category,
    DateTime? targetDate,
    DateTime? createdAt,
    bool? isCompleted,
  }) {
    return GoalModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      targetDate: targetDate ?? this.targetDate,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
