import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_profile_page.dart';
import 'package:citiguide_app/pages/users/user_favorites_page.dart';
import '../auth/user_login_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String? _name;
  String? _profileImageUrl;
  String? _email;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = doc.data();

      if (data != null) {
        setState(() {
          _name = data['name'] ?? 'Unknown User';
          _profileImageUrl = data['profileImageUrl'] ?? '';
          _email = data['email'] ?? '';
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
      }
      setState(() => _isLoading = false);
    }
  }


  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) =>  UserLoginPage()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Image
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[300],
              backgroundImage: (_profileImageUrl != null &&
                  _profileImageUrl!.isNotEmpty)
                  ? NetworkImage(_profileImageUrl!)
                  : null,
              child: (_profileImageUrl == null || _profileImageUrl!.isEmpty)
                  ? Icon(Icons.person, size: 60)
                  : null,
            ),
            SizedBox(height: 20),

            // Name
            Text(
              _name ?? 'Unknown User',
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),

            // Email
            Text(
              _email ?? '',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            SizedBox(height: 30),

            // Edit Profile
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: Text('Edit Profile'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditProfilePage()),
                ).then((_) => _loadUserData()); // Refresh after editing
              },
            ),
            Divider(),

            // Preferences & Favorites
            ListTile(
              leading: Icon(Icons.favorite, color: Colors.pink),
              title: Text('Preferences & Favorites'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => UserFavoritesPage()),
                );
              },
            ),
            Divider(),

            // Logout
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Logout'),
              onTap: _signOut,
            ),
          ],
        ),
      ),
    );
  }
}
