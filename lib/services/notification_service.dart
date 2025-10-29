import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all notifications stream
  Stream<List<NotificationModel>> getNotificationsStream() {
    return _firestore
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NotificationModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Create notification
  Future<void> createNotification({
    required String title,
    required String message,
    String? imageUrl,
    required String targetAudience,
    String? cityId,
    DateTime? scheduledFor,
  }) async {
    // Count recipients based on target audience
    int recipientCount = 0;

    if (targetAudience == 'all') {
      final usersSnapshot = await _firestore.collection('users').get();
      recipientCount = usersSnapshot.docs.length;
    } else if (targetAudience == 'city' && cityId != null) {
      // Count users who favorited attractions in this city
      final favSnapshot = await _firestore
          .collectionGroup('favorites')
          .where('cityId', isEqualTo: cityId)
          .get();
      recipientCount = favSnapshot.docs.length;
    }

    await _firestore.collection('notifications').add({
      'title': title,
      'message': message,
      'imageUrl': imageUrl,
      'targetAudience': targetAudience,
      'cityId': cityId,
      'scheduledFor': scheduledFor != null
          ? Timestamp.fromDate(scheduledFor)
          : null,
      'isSent': scheduledFor == null, // Send immediately if not scheduled
      'recipientCount': recipientCount,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // If sending immediately, create user notifications
    if (scheduledFor == null) {
      await _sendToUsers(title, message, imageUrl, targetAudience, cityId);
    }
  }

  // Send notification to users
  Future<void> _sendToUsers(
    String title,
    String message,
    String? imageUrl,
    String targetAudience,
    String? cityId,
  ) async {
    Query usersQuery = _firestore.collection('users');

    if (targetAudience == 'city' && cityId != null) {
      // Get users who have favorited attractions in this city
      final favSnapshot = await _firestore
          .collectionGroup('favorites')
          .where('cityId', isEqualTo: cityId)
          .get();

      final userIds = favSnapshot.docs
          .map((doc) => doc.reference.parent.parent!.id)
          .toSet()
          .toList();

      // Send to these users
      for (var userId in userIds) {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('notifications')
            .add({
              'title': title,
              'message': message,
              'imageUrl': imageUrl,
              'isRead': false,
              'createdAt': FieldValue.serverTimestamp(),
            });
      }
    } else {
      // Send to all users
      final usersSnapshot = await usersQuery.get();
      for (var userDoc in usersSnapshot.docs) {
        await userDoc.reference.collection('notifications').add({
          'title': title,
          'message': message,
          'imageUrl': imageUrl,
          'isRead': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).delete();
  }

  // Send scheduled notifications (would be called by a background job)
  Future<void> sendScheduledNotifications() async {
    final now = Timestamp.now();
    final snapshot = await _firestore
        .collection('notifications')
        .where('isSent', isEqualTo: false)
        .where('scheduledFor', isLessThanOrEqualTo: now)
        .get();

    for (var doc in snapshot.docs) {
      final notification = NotificationModel.fromFirestore(doc);
      await _sendToUsers(
        notification.title,
        notification.message,
        notification.imageUrl,
        notification.targetAudience,
        notification.cityId,
      );

      await doc.reference.update({'isSent': true});
    }
  }
}
