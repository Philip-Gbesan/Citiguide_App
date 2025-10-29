import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthService _authService = AuthService();

  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _imageUrlController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  bool _hasChanges = false;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _nameController.addListener(_checkForChanges);
    _passwordController.addListener(_checkForChanges);
    _imageUrlController.addListener(() {
      _checkForChanges();
      _updateImagePreview();
    });
  }

  void _updateImagePreview() {
    setState(() {});
  }

  void _checkForChanges() {
    if (_user == null) return;

    final nameChanged = _nameController.text.trim() != _user!.name;
    final passwordEntered = _passwordController.text.trim().isNotEmpty;
    final imageChanged =
        _imageUrlController.text.trim() != (_user!.profileImageUrl ?? '');

    final hasChanges = nameChanged || passwordEntered || imageChanged;

    if (_hasChanges != hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  bool _isValidImageUrl(String url) {
    return Uri.tryParse(url)?.hasAbsolutePath == true &&
        (url.startsWith('http://') || url.startsWith('https://'));
  }

  Future<void> _loadUser() async {
    setState(() => _isLoading = true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final userData = await _authService.getUserData(uid);
        if (userData != null) {
          _user = userData;
          _nameController.text = _user!.name;
          _imageUrlController.text = _user!.profileImageUrl ?? '';
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveChanges() async {
    if (_user == null) return;

    final name = _nameController.text.trim();
    final password = _passwordController.text.trim();
    final imageUrl = _imageUrlController.text.trim();

    if (!_hasChanges) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No changes made')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Update name
      if (name.isNotEmpty && name != _user!.name) {
        await _authService.updateName(_user!.uid, name);
      }

      // Update password
      if (password.isNotEmpty) {
        if (password.length < 6) {
          throw Exception('Password must be at least 6 characters long');
        }
        await _authService.updatePassword(password);
      }

      // Update image
      if (imageUrl.isNotEmpty &&
          _isValidImageUrl(imageUrl) &&
          imageUrl != _user!.profileImageUrl) {
        await _authService.updateImage(_user!.uid, imageUrl);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved successfully')),
      );

      _passwordController.clear();
      await _loadUser();
      setState(() => _hasChanges = false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving changes: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColor = Color(0xFF007BFF);

    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: appColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Image Preview
            CircleAvatar(
              radius: 50,
              backgroundImage: _isValidImageUrl(_imageUrlController.text)
                  ? NetworkImage(_imageUrlController.text)
                  : (_user?.profileImageUrl != null &&
                  _isValidImageUrl(_user!.profileImageUrl!)
                  ? NetworkImage(_user!.profileImageUrl!)
                  : null),
              child: (!_isValidImageUrl(_imageUrlController.text) &&
                  (_user?.profileImageUrl == null ||
                      !_isValidImageUrl(_user!.profileImageUrl!)))
                  ? Icon(Icons.person, size: 50)
                  : null,
            ),
            SizedBox(height: 16),

            // Full Name
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),

            SizedBox(height: 10),


            // Password
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            SizedBox(height: 10),

            // Profile Image URL
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(
                labelText: 'Profile Image URL',
                prefixIcon: Icon(Icons.image),
              ),
            ),

            SizedBox(height: 15),




            // Save Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _hasChanges ? appColor : Colors.grey,
                minimumSize: Size(double.infinity, 48),
              ),
              onPressed:
              (!_hasChanges || _isSaving) ? null : _saveChanges, // disable if no change
              icon: Icon(Icons.save),
              label: _isSaving
                  ? Text('Saving...')
                  : Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
