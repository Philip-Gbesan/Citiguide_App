import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String? imageUrl;
  final String targetAudience; // 'all', 'city', 'custom'
  final String? cityId; // if targetAudience is 'city'
  final DateTime? scheduledFor;
  final bool isSent;
  final int? recipientCount;
  final Timestamp createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    this.imageUrl,
    required this.targetAudience,
    this.cityId,
    this.scheduledFor,
    this.isSent = false,
    this.recipientCount,
    required this.createdAt,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      imageUrl: data['imageUrl'],
      targetAudience: data['targetAudience'] ?? 'all',
      cityId: data['cityId'],
      scheduledFor: data['scheduledFor'] != null
          ? (data['scheduledFor'] as Timestamp).toDate()
          : null,
      isSent: data['isSent'] ?? false,
      recipientCount: data['recipientCount'],
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'imageUrl': imageUrl,
      'targetAudience': targetAudience,
      'cityId': cityId,
      'scheduledFor': scheduledFor != null
          ? Timestamp.fromDate(scheduledFor!)
          : null,
      'isSent': isSent,
      'recipientCount': recipientCount,
      'createdAt': createdAt,
    };
  }
}
