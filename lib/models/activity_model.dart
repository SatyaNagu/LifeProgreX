import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityLog {
  final String id;
  final String userId;
  final String type; // e.g., 'workout', 'mood', 'reading'
  final String? value; // e.g., 'Bad', 'Good', 'Cardio'
  final int? duration; // e.g., 45 (minutes)
  final String? notes;
  final Map<String, dynamic> data; // Type-specific extra data
  final DateTime createdAt;

  ActivityLog({
    required this.id,
    required this.userId,
    required this.type,
    this.value,
    this.duration,
    this.notes,
    this.data = const {},
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'value': value,
      'duration': duration,
      'notes': notes,
      'data': data,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory ActivityLog.fromMap(Map<String, dynamic> map, String id) {
    return ActivityLog(
      id: id,
      userId: map['userId'] ?? '',
      type: map['type'] ?? '',
      value: map['value'],
      duration: map['duration'],
      notes: map['notes'],
      data: map['data'] ?? {},
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
