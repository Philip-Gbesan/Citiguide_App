import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/event_model.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all events stream
  Stream<List<EventModel>> getEventsStream() {
    return _firestore
        .collection('events')
        .orderBy('startDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => EventModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Get events for a specific city
  Stream<List<EventModel>> getCityEventsStream(String cityId) {
    return _firestore
        .collection('events')
        .where('cityId', isEqualTo: cityId)
        .where('isActive', isEqualTo: true)
        .orderBy('startDate')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => EventModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Add new event
  Future<void> addEvent({
    required String cityId,
    required String name,
    required String description,
    String? imageUrl,
    required DateTime startDate,
    required DateTime endDate,
    required String location,
    String? ticketInfo,
  }) async {
    await _firestore.collection('events').add({
      'cityId': cityId,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'location': location,
      'ticketInfo': ticketInfo,
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Update event
  Future<void> updateEvent({
    required String eventId,
    required String name,
    required String description,
    String? imageUrl,
    required DateTime startDate,
    required DateTime endDate,
    required String location,
    String? ticketInfo,
    required bool isActive,
  }) async {
    await _firestore.collection('events').doc(eventId).update({
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'location': location,
      'ticketInfo': ticketInfo,
      'isActive': isActive,
    });
  }

  // Delete event
  Future<void> deleteEvent(String eventId) async {
    await _firestore.collection('events').doc(eventId).delete();
  }

  // Toggle event active status
  Future<void> toggleEventStatus(String eventId, bool isActive) async {
    await _firestore.collection('events').doc(eventId).update({
      'isActive': isActive,
    });
  }
}
