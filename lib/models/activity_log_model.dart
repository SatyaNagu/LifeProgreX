import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityLogModel {
  final String id;
  final String habitId;
  final String userId;
  final DateTime timestamp;
  final String? note;

  ActivityLogModel({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.timestamp,
    this.note,
  });

  factory ActivityLogModel.fromJson(Map<String, dynamic> json, String documentId) {
    final stamp = json['timestamp'] as Timestamp?;
    return ActivityLogModel(
      id: documentId,
      habitId: json['habitId'] ?? '',
      userId: json['userId'] ?? '',
      timestamp: stamp?.toDate() ?? DateTime.now(),
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'habitId': habitId,
      'userId': userId,
      'timestamp': Timestamp.fromDate(timestamp),
      'note': note,
    };
  }
}
