import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String cityId;
  final String cityName;
  final String address;
  final String cuisine;
  final double rating;
  final String priceRange; // $, $$, $$$, $$$$
  final List<String> specialties;
  final Map<String, dynamic> contactInfo;
  final DateTime createdAt;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.cityId,
    required this.cityName,
    required this.address,
    required this.cuisine,
    this.rating = 0.0,
    this.priceRange = '\$\$',
    this.specialties = const [],
    this.contactInfo = const {},
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory RestaurantModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return RestaurantModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      cityId: data['cityId'] ?? '',
      cityName: data['cityName'] ?? '',
      address: data['address'] ?? '',
      cuisine: data['cuisine'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      priceRange: data['priceRange'] ?? '\$\$',
      specialties: List<String>.from(data['specialties'] ?? []),
      contactInfo: Map<String, dynamic>.from(data['contactInfo'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'cityId': cityId,
      'cityName': cityName,
      'address': address,
      'cuisine': cuisine,
      'rating': rating,
      'priceRange': priceRange,
      'specialties': specialties,
      'contactInfo': contactInfo,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  RestaurantModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? cityId,
    String? cityName,
    String? address,
    String? cuisine,
    double? rating,
    String? priceRange,
    List<String>? specialties,
    Map<String, dynamic>? contactInfo,
    DateTime? createdAt,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      cityId: cityId ?? this.cityId,
      cityName: cityName ?? this.cityName,
      address: address ?? this.address,
      cuisine: cuisine ?? this.cuisine,
      rating: rating ?? this.rating,
      priceRange: priceRange ?? this.priceRange,
      specialties: specialties ?? this.specialties,
      contactInfo: contactInfo ?? this.contactInfo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
