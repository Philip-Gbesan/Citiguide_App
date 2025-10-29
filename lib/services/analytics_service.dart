import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/analytics_model.dart';

class AnalyticsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get dashboard analytics
  Future<AnalyticsModel> getDashboardAnalytics() async {
    try {
      // Get total users
      final usersSnapshot = await _firestore.collection('users').get();
      final totalUsers = usersSnapshot.docs.length;

      // Get active users (users with activity in last 30 days)
      final thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));
      final activeUsersSnapshot = await _firestore
          .collectionGroup('favorites')
          .where('createdAt', isGreaterThan: Timestamp.fromDate(thirtyDaysAgo))
          .get();

      final activeUserIds = activeUsersSnapshot.docs
          .map((doc) => doc.reference.parent.parent!.id)
          .toSet();
      final activeUsers = activeUserIds.length;

      // Get total cities
      final citiesSnapshot = await _firestore.collection('cities').get();
      final totalCities = citiesSnapshot.docs.length;

      // Get total attractions across all cities
      int totalAttractions = 0;
      for (var cityDoc in citiesSnapshot.docs) {
        final attractionsSnapshot = await cityDoc.reference
            .collection('attractions')
            .get();
        totalAttractions += attractionsSnapshot.docs.length;
      }

      // Get total reviews and calculate average rating
      final reviewsSnapshot = await _firestore.collectionGroup('reviews').get();
      final totalReviews = reviewsSnapshot.docs.length;

      double totalRating = 0;
      int pendingReviews = 0;

      for (var doc in reviewsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        totalRating += (data['rating'] ?? 0).toDouble();
        if (!(data['approved'] ?? false)) {
          pendingReviews++;
        }
      }

      final averageRating = totalReviews > 0 ? totalRating / totalReviews : 0.0;

      // Get user growth (last 7 days)
      final userGrowth = <String, int>{};
      for (int i = 6; i >= 0; i--) {
        final date = DateTime.now().subtract(Duration(days: i));
        final dateStr = '${date.month}/${date.day}';
        // This is simplified - in production you'd query by createdAt
        userGrowth[dateStr] = 0;
      }

      // Get popular cities (simplified)
      final popularCities = <String, int>{};
      for (var cityDoc in citiesSnapshot.docs) {
        // In production, track actual view counts
        popularCities[cityDoc.id] = 0;
      }

      return AnalyticsModel(
        totalUsers: totalUsers,
        activeUsers: activeUsers,
        totalCities: totalCities,
        totalAttractions: totalAttractions,
        totalReviews: totalReviews,
        pendingReviews: pendingReviews,
        averageRating: averageRating,
        userGrowth: userGrowth,
        popularCities: popularCities,
      );
    } catch (e) {
      print('Error getting analytics: $e');
      return AnalyticsModel.empty();
    }
  }

  // Get city-specific analytics
  Future<Map<String, dynamic>> getCityAnalytics(String cityId) async {
    try {
      final cityRef = _firestore.collection('cities').doc(cityId);

      // Get attractions count
      final attractionsSnapshot = await cityRef.collection('attractions').get();

      // Get reviews for this city's attractions
      int totalReviews = 0;
      double totalRating = 0;

      for (var attractionDoc in attractionsSnapshot.docs) {
        final reviewsSnapshot = await attractionDoc.reference
            .collection('reviews')
            .get();
        totalReviews += reviewsSnapshot.docs.length;

        for (var reviewDoc in reviewsSnapshot.docs) {
          final data = reviewDoc.data() as Map<String, dynamic>;
          totalRating += (data['rating'] ?? 0).toDouble();
        }
      }

      final averageRating = totalReviews > 0 ? totalRating / totalReviews : 0.0;

      return {
        'attractionsCount': attractionsSnapshot.docs.length,
        'reviewsCount': totalReviews,
        'averageRating': averageRating,
      };
    } catch (e) {
      print('Error getting city analytics: $e');
      return {'attractionsCount': 0, 'reviewsCount': 0, 'averageRating': 0.0};
    }
  }
}
