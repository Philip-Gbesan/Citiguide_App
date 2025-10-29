import 'package:cloud_firestore/cloud_firestore.dart';

class AttractionModel {
  final String id;
  final String cityId;
  final String categoryId;
  final String name;
  final String description;
  final String? phone;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? openingHours;
  final String? websiteLink;
  final String? imageUrl;
  final DateTime createdAt;

  AttractionModel({
    required this.id,
    required this.cityId,
    required this.categoryId,
    required this.name,
    required this.description,
    this.phone,
    this.address,
    this.latitude,
    this.longitude,
    this.openingHours,
    this.websiteLink,
    this.imageUrl,
    required this.createdAt,
  });

  /// Creates a copy with optional updated fields
  AttractionModel copyWith({
    String? id,
    String? cityId,
    String? categoryId,
    String? name,
    String? description,
    String? phone,
    String? address,
    double? latitude,
    double? longitude,
    String? openingHours,
    String? websiteLink,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return AttractionModel(
      id: id ?? this.id,
      cityId: cityId ?? this.cityId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      openingHours: openingHours ?? this.openingHours,
      websiteLink: websiteLink ?? this.websiteLink,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convert Firestore document to AttractionModel
  factory AttractionModel.fromMap(Map<String, dynamic> map, {required String id, required String cityId}) {
    return AttractionModel(
      id: id,
      cityId: cityId,
      categoryId: map['categoryId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      phone: map['phone'],
      address: map['address'],
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      openingHours: map['openingHours'],
      websiteLink: map['websiteLink'],
      imageUrl: map['imageUrl'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Convert AttractionModel to Firestore document map
  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'phone': phone,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'openingHours': openingHours,
      'websiteLink': websiteLink,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
    };
  }
}
