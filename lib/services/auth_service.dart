import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register new user
  Future<UserModel?> registerUser({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final newUser = UserModel(
        uid: cred.user!.uid,
        name: name,
        email: email,
        role: role,
      );

      await _firestore.collection('users').doc(cred.user!.uid).set(newUser.toMap());
      return newUser;
    } on FirebaseAuthException catch (e) {
      print('Registration error: ${e.message}');
      return null;
    }
  }

  // Login existing user
  Future<UserModel?> loginUser(String email, String password) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final doc = await _firestore.collection('users').doc(cred.user!.uid).get();
      if (!doc.exists) return null;

      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    } on FirebaseAuthException catch (e) {
      print('Login error: ${e.message}');
      return null;
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Get user data
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Update name
  Future<void> updateName(String uid, String name) async {
    await _firestore.collection('users').doc(uid).update({'name': name});
  }

  // Update profile image (URL only)
  Future<void> updateImage(String uid, String imageUrl) async {
    await _firestore.collection('users').doc(uid).update({'profileImageUrl': imageUrl});
  }

  // Update email
  // Future<void> updateEmail(String uid, String newEmail) async {
  //   final user = _auth.currentUser;
  //   if (user == null) throw Exception('No user logged in');
  //
  //   try {
  //     // This works for mobile & web
  //     await user.updateEmail(newEmail);
  //
  //     // Update Firestore after successful email change
  //     await _firestore.collection('users').doc(uid).update({'email': newEmail});
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'requires-recent-login') {
  //       throw Exception('Please re-login before updating email.');
  //     } else {
  //       throw Exception('Error updating email: ${e.message}');
  //     }
  //   }
  // }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    try {
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw Exception('Please re-login before updating password.');
      } else {
        throw Exception('Error updating password: ${e.message}');
      }
    }
  }

}
