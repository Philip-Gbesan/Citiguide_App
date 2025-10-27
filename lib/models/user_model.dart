import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? profileImageUrl;
  final String role;
  final bool isBanned;
  final String? banReason;
  final DateTime? bannedAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.role = "user",
    this.isBanned = false,
    this.banReason,
    this.bannedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      role: data['role'] ?? 'user',
      isBanned: data['isBanned'] ?? false,
      banReason: data['banReason'],
      bannedAt: data['bannedAt'] != null
          ? (data['bannedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'role': role,
      'isBanned': isBanned,
      'banReason': banReason,
      'bannedAt': bannedAt != null ? Timestamp.fromDate(bannedAt!) : null,
    };
  }
}
