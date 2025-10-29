import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final DateTime createdAt;

  CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.createdAt,
  });

  /// Convert CategoryModel to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt, // Firestore can store DateTime as Timestamp automatically
    };
  }

  /// Create a CategoryModel from Firestore document data
  factory CategoryModel.fromMap(Map<String, dynamic> data, String documentId) {
    final createdAtValue = data['createdAt'];
    DateTime createdAt;

    if (createdAtValue is Timestamp) {
      createdAt = createdAtValue.toDate();
    } else if (createdAtValue is String) {
      createdAt = DateTime.tryParse(createdAtValue) ?? DateTime.now();
    } else {
      createdAt = DateTime.now();
    }

    return CategoryModel(
      id: documentId,
      name: data['name'] ?? '',
      description: data['description'],
      imageUrl: data['imageUrl'],
      createdAt: createdAt,
    );
  }
}
