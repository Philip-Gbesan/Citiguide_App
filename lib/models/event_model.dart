import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String cityId;
  final String name;
  final String description;
  final String? imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String? ticketInfo;
  final bool isActive;
  final Timestamp createdAt;

  EventModel({
    required this.id,
    required this.cityId,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.location,
    this.ticketInfo,
    this.isActive = true,
    required this.createdAt,
  });

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      cityId: data['cityId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      location: data['location'] ?? '',
      ticketInfo: data['ticketInfo'],
      isActive: data['isActive'] ?? true,
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cityId': cityId,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'location': location,
      'ticketInfo': ticketInfo,
      'isActive': isActive,
      'createdAt': createdAt,
    };
  }
}
