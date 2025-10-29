import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:async/async.dart'; // <<--- this is required for StreamZip
import '../models/attraction_model.dart';

class AttractionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new attraction under a specific city
  Future<void> addAttraction(AttractionModel attraction, String cityId) async {
    final ref = _firestore
        .collection('cities')
        .doc(cityId)
        .collection('attractions')
        .doc(attraction.id);

    await ref.set(attraction.toMap());
  }

  // Stream all attractions for a specific city
  Stream<List<AttractionModel>> getAllAttractions(String cityId) {
    return _firestore
        .collection('cities')
        .doc(cityId)
        .collection('attractions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => AttractionModel.fromMap(
      doc.data(),
      id: doc.id,
      cityId: cityId,
    ))
        .toList());
  }

  // Stream attractions by category across all cities (real-time)
  Stream<List<AttractionModel>> getAttractionsByCategory(String categoryId) async* {
    // Listen to all cities
    await for (var citiesSnapshot in _firestore.collection('cities').snapshots()) {
      // For each city, listen to attractions matching the category
      List<Stream<List<AttractionModel>>> cityStreams = citiesSnapshot.docs.map((cityDoc) {
        return cityDoc.reference
            .collection('attractions')
            .where('categoryId', isEqualTo: categoryId)
            .snapshots()
            .map((snapshot) => snapshot.docs
            .map((doc) => AttractionModel.fromMap(
          doc.data(),
          id: doc.id,
          cityId: cityDoc.id,
        ))
            .toList());
      }).toList();

      if (cityStreams.isEmpty) {
        yield [];
        continue;
      }

      // Combine streams for all cities into one list
      yield* StreamZip(cityStreams).map((lists) => lists.expand((l) => l).toList());
    }
  }

  // Update an attraction
  Future<void> updateAttraction(AttractionModel attraction) async {
    final ref = _firestore
        .collection('cities')
        .doc(attraction.cityId)
        .collection('attractions')
        .doc(attraction.id);

    await ref.update(attraction.toMap()..['updatedAt'] = FieldValue.serverTimestamp());
  }

  // Delete attraction by city and attraction ID
  Future<void> deleteAttraction(String cityId, String attractionId) async {
    final ref = _firestore
        .collection('cities')
        .doc(cityId)
        .collection('attractions')
        .doc(attractionId);

    await ref.delete();
  }
}
