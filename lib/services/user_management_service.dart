import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UserManagementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all users stream
  Stream<List<UserModel>> getUsersStream() {
    return _firestore
        .collection('users')
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // Search users
  Stream<List<UserModel>> searchUsers(String query) {
    return _firestore.collection('users').orderBy('name').snapshots().map((
      snapshot,
    ) {
      final users = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();

      return users.where((user) {
        final nameLower = user.name.toLowerCase();
        final emailLower = user.email.toLowerCase();
        final queryLower = query.toLowerCase();
        return nameLower.contains(queryLower) ||
            emailLower.contains(queryLower);
      }).toList();
    });
  }

  // Get user activity stats
  Future<Map<String, dynamic>> getUserActivity(String userId) async {
    // Get review count
    final reviewsSnapshot = await _firestore
        .collectionGroup('reviews')
        .where('userId', isEqualTo: userId)
        .get();

    // Get favorites count
    final favoritesSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .get();

    return {
      'reviewCount': reviewsSnapshot.docs.length,
      'favoritesCount': favoritesSnapshot.docs.length,
    };
  }

  // Ban user
  Future<void> banUser(String userId, String reason) async {
    await _firestore.collection('users').doc(userId).update({
      'isBanned': true,
      'banReason': reason,
      'bannedAt': FieldValue.serverTimestamp(),
    });

    // Log the action
    await _firestore.collection('admin_actions').add({
      'action': 'ban_user',
      'userId': userId,
      'reason': reason,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Unban user
  Future<void> unbanUser(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'isBanned': false,
      'banReason': FieldValue.delete(),
      'bannedAt': FieldValue.delete(),
    });

    await _firestore.collection('admin_actions').add({
      'action': 'unban_user',
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Warn user
  Future<void> warnUser(String userId, String warning) async {
    await _firestore.collection('users').doc(userId).collection('warnings').add(
      {'message': warning, 'createdAt': FieldValue.serverTimestamp()},
    );

    // Send notification to user
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .add({
          'title': 'Warning',
          'message': warning,
          'isRead': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
  }

  // Delete user account
  Future<void> deleteUserAccount(String userId) async {
    // Delete user data
    final userRef = _firestore.collection('users').doc(userId);

    // Delete subcollections
    final collections = ['favorites', 'warnings', 'notifications'];
    for (var collection in collections) {
      final snapshot = await userRef.collection(collection).get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }

    // Delete user document
    await userRef.delete();

    // Log action
    await _firestore.collection('admin_actions').add({
      'action': 'delete_user',
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Update user role
  Future<void> updateUserRole(String userId, String newRole) async {
    await _firestore.collection('users').doc(userId).update({'role': newRole});
  }
}
