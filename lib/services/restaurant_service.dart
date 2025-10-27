import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/restaurant_model.dart';

class RestaurantService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'restaurants';

  /// Get all restaurants as a stream
  Stream<List<RestaurantModel>> getRestaurantsStream() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => RestaurantModel.fromFirestore(doc))
              .toList();
        });
  }

  /// Get restaurants by city
  Stream<List<RestaurantModel>> getRestaurantsByCityStream(String cityId) {
    return _firestore
        .collection(_collection)
        .where('cityId', isEqualTo: cityId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => RestaurantModel.fromFirestore(doc))
              .toList();
        });
  }

  /// Get restaurants by cuisine type
  Stream<List<RestaurantModel>> getRestaurantsByCuisineStream(String cuisine) {
    return _firestore
        .collection(_collection)
        .where('cuisine', isEqualTo: cuisine)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => RestaurantModel.fromFirestore(doc))
              .toList();
        });
  }

  /// Get a single restaurant
  Future<RestaurantModel?> getRestaurant(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return RestaurantModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting restaurant: $e');
      return null;
    }
  }

  /// Add a new restaurant
  Future<String> addRestaurant({
    required String name,
    required String description,
    required String imageUrl,
    required String cityId,
    required String cityName,
    required String address,
    required String cuisine,
    String priceRange = '\$\$',
    List<String> specialties = const [],
    Map<String, dynamic> contactInfo = const {},
  }) async {
    try {
      final restaurant = RestaurantModel(
        id: '',
        name: name,
        description: description,
        imageUrl: imageUrl,
        cityId: cityId,
        cityName: cityName,
        address: address,
        cuisine: cuisine,
        priceRange: priceRange,
        specialties: specialties,
        contactInfo: contactInfo,
      );

      final docRef = await _firestore
          .collection(_collection)
          .add(restaurant.toMap());
      return docRef.id;
    } catch (e) {
      print('Error adding restaurant: $e');
      rethrow;
    }
  }

  /// Update a restaurant
  Future<void> updateRestaurant(RestaurantModel restaurant) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(restaurant.id)
          .update(restaurant.toMap());
    } catch (e) {
      print('Error updating restaurant: $e');
      rethrow;
    }
  }

  /// Delete a restaurant
  Future<void> deleteRestaurant(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      print('Error deleting restaurant: $e');
      rethrow;
    }
  }

  /// Update restaurant rating
  Future<void> updateRating(String id, double rating) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'rating': rating,
      });
    } catch (e) {
      print('Error updating rating: $e');
      rethrow;
    }
  }

  /// Search restaurants
  Future<List<RestaurantModel>> searchRestaurants(String query) async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      final allRestaurants = snapshot.docs
          .map((doc) => RestaurantModel.fromFirestore(doc))
          .toList();

      return allRestaurants.where((restaurant) {
        final nameLower = restaurant.name.toLowerCase();
        final cuisineLower = restaurant.cuisine.toLowerCase();
        final queryLower = query.toLowerCase();
        return nameLower.contains(queryLower) ||
            cuisineLower.contains(queryLower);
      }).toList();
    } catch (e) {
      print('Error searching restaurants: $e');
      return [];
    }
  }
}
