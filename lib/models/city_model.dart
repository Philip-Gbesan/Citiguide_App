import 'package:cloud_firestore/cloud_firestore.dart';

class CityModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String country;

  CityModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.country = '',
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'country': country,
    };
  }
}