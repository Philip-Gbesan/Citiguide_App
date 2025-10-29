// TODO Implement this library.
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminActionModel {
  final String id;
  final String actionType;
  final String adminId;
  final String targetId;
  final String details;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  AdminActionModel({
    required this.id,
    required this.actionType,
    required this.adminId,
    required this.targetId,
    required this.details,
    required this.timestamp,
    this.metadata,
  });

  factory AdminActionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return AdminActionModel(
      id: doc.id,
      actionType: data['actionType'] ?? '',
      adminId: data['adminId'] ?? '',
      targetId: data['targetId'] ?? '',
      details: data['details'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'actionType': actionType,
      'adminId': adminId,
      'targetId': targetId,
      'details': details,
      'timestamp': Timestamp.fromDate(timestamp),
      if (metadata != null) 'metadata': metadata,
    };
  }

  AdminActionModel copyWith({
    String? id,
    String? actionType,
    String? adminId,
    String? targetId,
    String? details,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return AdminActionModel(
      id: id ?? this.id,
      actionType: actionType ?? this.actionType,
      adminId: adminId ?? this.adminId,
      targetId: targetId ?? this.targetId,
      details: details ?? this.details,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }

  String get formattedActionType {
    switch (actionType) {
      case 'event_created':
        return 'Event Created';
      case 'event_updated':
        return 'Event Updated';
      case 'event_deleted':
        return 'Event Deleted';
      case 'city_created':
        return 'City Created';
      case 'city_updated':
        return 'City Updated';
      case 'city_deleted':
        return 'City Deleted';
      case 'attraction_created':
        return 'Attraction Created';
      case 'attraction_updated':
        return 'Attraction Updated';
      case 'attraction_deleted':
        return 'Attraction Deleted';
      case 'user_banned':
        return 'User Banned';
      case 'user_unbanned':
        return 'User Unbanned';
      case 'user_warned':
        return 'User Warned';
      case 'review_approved':
        return 'Review Approved';
      case 'review_rejected':
        return 'Review Rejected';
      case 'notification_sent':
        return 'Notification Sent';
      default:
        return actionType.replaceAll('_', ' ').toUpperCase();
    }
  }

  String get formattedTimestamp {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}

class AdminActionType {
  // Event actions
  static const String eventCreated = 'event_created';
  static const String eventUpdated = 'event_updated';
  static const String eventDeleted = 'event_deleted';

  // City actions
  static const String cityCreated = 'city_created';
  static const String cityUpdated = 'city_updated';
  static const String cityDeleted = 'city_deleted';

  // Attraction actions
  static const String attractionCreated = 'attraction_created';
  static const String attractionUpdated = 'attraction_updated';
  static const String attractionDeleted = 'attraction_deleted';

  // User management actions
  static const String userBanned = 'user_banned';
  static const String userUnbanned = 'user_unbanned';
  static const String userWarned = 'user_warned';
  static const String userDeleted = 'user_deleted';

  // Review moderation actions
  static const String reviewApproved = 'review_approved';
  static const String reviewRejected = 'review_rejected';
  static const String reviewDeleted = 'review_deleted';

  // Notification actions
  static const String notificationSent = 'notification_sent';
  static const String notificationDeleted = 'notification_deleted';
}
