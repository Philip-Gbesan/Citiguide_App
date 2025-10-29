import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _hasChanges = false;

  String _originalName = '';
  String _originalImageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // Add listeners to detect field changes
    _nameController.addListener(_checkForChanges);
    _imageUrlController.addListener(_checkForChanges);
    _passwordController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ✅ Detect if any field is changed
  void _checkForChanges() {
    final newName = _nameController.text.trim();
    final newImageUrl = _imageUrlController.text.trim();
    final newPassword = _passwordController.text.trim();

    final hasChanges = newName != _originalName ||
        newImageUrl != _originalImageUrl ||
        newPassword.isNotEmpty;

    if (_hasChanges != hasChanges) {
      setState(() => _hasChanges = hasChanges);
    } else {
      setState(() {}); // Update live preview even if _hasChanges stays same
    }
  }

  bool _isValidImageUrl(String url) {
    return Uri.tryParse(url)?.hasAbsolutePath == true &&
        (url.startsWith('http://') || url.startsWith('https://'));
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc =
    await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final data = doc.data();

    if (data != null) {
      setState(() {
        _originalName = data['name'] ?? '';
        _originalImageUrl = data['profileImageUrl'] ?? '';
        _nameController.text = _originalName;
        _imageUrlController.text = _originalImageUrl;
        _hasChanges = false; // reset change state
      });
    }
  }

  Future<void> _updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final newName = _nameController.text.trim();
    final newImageUrl = _imageUrlController.text.trim();
    final newPassword = _passwordController.text.trim();

    if (!_hasChanges) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No changes to save')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Update Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': newName,
        'profileImageUrl': newImageUrl,
      });

      // Update password if entered
      if (newPassword.isNotEmpty) {
        if (newPassword.length < 6) {
          throw Exception('Password must be at least 6 characters long');
        }
        await user.updatePassword(newPassword);
      }

      // ✅ Reset originals after successful update
      setState(() {
        _originalName = newName;
        _originalImageUrl = newImageUrl;
        _passwordController.clear();
        _hasChanges = false;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColor = const Color(0xFF007BFF);
    final imageUrl = _imageUrlController.text.trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: appColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 👤 Profile Image Preview
            CircleAvatar(
              radius: 50,
              backgroundImage: _isValidImageUrl(imageUrl)
                  ? NetworkImage(imageUrl)
                  : (_isValidImageUrl(_originalImageUrl)
                  ? NetworkImage(_originalImageUrl)
                  : null),
              child: (!_isValidImageUrl(imageUrl) &&
                  !_isValidImageUrl(_originalImageUrl))
                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                  : null,
            ),
            const SizedBox(height: 16),

            // 👤 Name Field
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 20),

            // 🔒 Password Field
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'New Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() => _isPasswordVisible = !_isPasswordVisible);
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 🖼️ Profile Image URL
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'Profile Image URL',
                prefixIcon: Icon(Icons.image_outlined),
              ),
            ),
            const SizedBox(height: 30),

            // 💾 Save Changes Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _hasChanges ? appColor : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _hasChanges && !_isLoading ? _updateProfile : null,
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
