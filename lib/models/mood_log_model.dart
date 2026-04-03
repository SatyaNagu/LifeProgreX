import 'package:cloud_firestore/cloud_firestore.dart';

class MoodLogModel {
  final String id;
  final String userId;
  final int score; // 1 to 10
  final String emoji;
  final DateTime timestamp;

  MoodLogModel({
    required this.id,
    required this.userId,
    required this.score,
    required this.emoji,
    required this.timestamp,
  });

  factory MoodLogModel.fromJson(Map<String, dynamic> json, String documentId) {
    final stamp = json['timestamp'] as Timestamp?;
    return MoodLogModel(
      id: documentId,
      userId: json['userId'] ?? '',
      score: json['score'] ?? 5,
      emoji: json['emoji'] ?? '😐',
      timestamp: stamp?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'score': score,
      'emoji': emoji,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
