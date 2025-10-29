import 'package:citiguide_app/models/admin_actions_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service for logging and retrieving admin actions
class AdminActionsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Log an admin action
  ///
  /// Example usage:
  /// ```dart
  /// await adminActionsService.logAction(
  ///   actionType: AdminActionType.eventCreated,
  ///   targetId: eventId,
  ///   details: 'Created new event: $eventTitle',
  /// );
  /// ```
  Future<void> logAction({
    required String actionType,
    required String targetId,
    required String details,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user');
      }

      final action = AdminActionModel(
        id: '', // Will be set by Firestore
        actionType: actionType,
        adminId: currentUser.uid,
        targetId: targetId,
        details: details,
        timestamp: DateTime.now(),
        metadata: metadata,
      );

      await _firestore.collection('admin_actions').add(action.toMap());
    } catch (e) {
      print('Error logging admin action: $e');
      rethrow;
    }
  }

  /// Get all admin actions (paginated)
  Stream<List<AdminActionModel>> getAdminActions({
    int limit = 50,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    Query query = _firestore
        .collection('admin_actions')
        .orderBy('timestamp', descending: true)
        .limit(limit);

    if (startDate != null) {
      query = query.where('timestamp', isGreaterThanOrEqualTo: startDate);
    }

    if (endDate != null) {
      query = query.where('timestamp', isLessThanOrEqualTo: endDate);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => AdminActionModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Get admin actions by admin ID
  Stream<List<AdminActionModel>> getActionsByAdmin(String adminId) {
    return _firestore
        .collection('admin_actions')
        .where('adminId', isEqualTo: adminId)
        .orderBy('timestamp', descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => AdminActionModel.fromFirestore(doc))
              .toList();
        });
  }

  /// Get admin actions by action type
  Stream<List<AdminActionModel>> getActionsByType(String actionType) {
    return _firestore
        .collection('admin_actions')
        .where('actionType', isEqualTo: actionType)
        .orderBy('timestamp', descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => AdminActionModel.fromFirestore(doc))
              .toList();
        });
  }

  /// Get admin actions for a specific target
  Stream<List<AdminActionModel>> getActionsByTarget(String targetId) {
    return _firestore
        .collection('admin_actions')
        .where('targetId', isEqualTo: targetId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => AdminActionModel.fromFirestore(doc))
              .toList();
        });
  }

  /// Get recent actions (last 24 hours)
  Stream<List<AdminActionModel>> getRecentActions() {
    final yesterday = DateTime.now().subtract(Duration(days: 1));

    return _firestore
        .collection('admin_actions')
        .where('timestamp', isGreaterThan: yesterday)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => AdminActionModel.fromFirestore(doc))
              .toList();
        });
  }

  /// Delete old admin actions (older than specified days)
  Future<void> cleanupOldActions(int daysToKeep) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));

      final snapshot = await _firestore
          .collection('admin_actions')
          .where('timestamp', isLessThan: cutoffDate)
          .get();

      final batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      print('Cleaned up ${snapshot.docs.length} old admin actions');
    } catch (e) {
      print('Error cleaning up admin actions: $e');
      rethrow;
    }
  }

  /// Get statistics about admin actions
  Future<Map<String, int>> getActionStatistics() async {
    try {
      final snapshot = await _firestore.collection('admin_actions').get();

      final stats = <String, int>{};
      for (var doc in snapshot.docs) {
        final action = AdminActionModel.fromFirestore(doc);
        stats[action.actionType] = (stats[action.actionType] ?? 0) + 1;
      }

      return stats;
    } catch (e) {
      print('Error getting action statistics: $e');
      return {};
    }
  }
}
