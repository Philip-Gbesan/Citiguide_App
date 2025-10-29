import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Get all approved reviews for an attraction
  Stream<List<ReviewModel>> getApprovedReviews(String cityId, String attractionId) {
    return _firestore
        .collection('cities')
        .doc(cityId)
        .collection('attractions')
        .doc(attractionId)
        .collection('reviews')
        .where('approved', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => ReviewModel.fromFirestore(doc))
          .toList(),
    );
  }

  /// ✅ Add a new review
  Future<void> addReview(
      String cityId,
      String attractionId,
      ReviewModel review,
      ) async {
    await _firestore
        .collection('cities')
        .doc(cityId)
        .collection('attractions')
        .doc(attractionId)
        .collection('reviews')
        .add(review.toMap());
  }

  //Toggle like on a review
  Future<void> toggleLike({
    required String cityId,
    required String attractionId,
    required String reviewId,
    required String userId,
  }) async {
    final reviewRef = FirebaseFirestore.instance
        .collection('cities')
        .doc(cityId)
        .collection('attractions')
        .doc(attractionId)
        .collection('reviews')
        .doc(reviewId);

    final snapshot = await reviewRef.get();
    if (!snapshot.exists) return;

    final data = snapshot.data()!;
    final likes = Map<String, dynamic>.from(data['likes'] ?? {});

    if (likes.containsKey(userId)) {
      //  Unlike → only remove this user’s key
      await reviewRef.update({'likes.$userId': FieldValue.delete()});
    } else {
      //  Like → only add this user’s key
      await reviewRef.update({'likes.$userId': true});
    }
  }


  //Approve a review (admin only)
  Future<void> approveReview(
      String cityId,
      String attractionId,
      String reviewId,
      ) async {
    try {
      await _firestore
          .collection('cities')
          .doc(cityId)
          .collection('attractions')
          .doc(attractionId)
          .collection('reviews')
          .doc(reviewId)
          .update({'approved': true});
    } catch (e) {
      throw Exception('Failed to approve review: $e');
    }
  }

  /// 🗑️ Delete a review (admin only)
  Future<void> deleteReview(
      String cityId,
      String attractionId,
      String reviewId,
      ) async {
    try {
      await _firestore
          .collection('cities')
          .doc(cityId)
          .collection('attractions')
          .doc(attractionId)
          .collection('reviews')
          .doc(reviewId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete review: $e');
    }
  }
}
