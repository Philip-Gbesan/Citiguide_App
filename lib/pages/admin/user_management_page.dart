import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user_model.dart';
import '../../services/user_management_service.dart';

class UserManagementPage extends ConsumerStatefulWidget {
  const UserManagementPage({super.key});

  @override
  ConsumerState<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends ConsumerState<UserManagementPage> {
  final UserManagementService _userService = UserManagementService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or email...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value.trim());
              },
            ),
          ),

          // Users List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .orderBy('name')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No users found'));
                }

                var users = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return UserModel.fromMap(data);
                }).toList();

                // Filter users based on search
                if (_searchQuery.isNotEmpty) {
                  users = users.where((user) {
                    final nameLower = user.name.toLowerCase();
                    final emailLower = user.email.toLowerCase();
                    final queryLower = _searchQuery.toLowerCase();
                    return nameLower.contains(queryLower) ||
                        emailLower.contains(queryLower);
                  }).toList();
                }

                if (users.isEmpty) {
                  return Center(child: Text('No users match your search'));
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return _buildUserCard(user);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(UserModel user) {
    final isBanned = false; // You'd get this from user data

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: user.role == 'admin' ? Colors.red : Colors.blue,
          backgroundImage: user.profileImageUrl != null
              ? NetworkImage(user.profileImageUrl!)
              : null,
          child: user.profileImageUrl == null
              ? Text(user.name[0].toUpperCase())
              : null,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                user.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (user.role == 'admin')
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'ADMIN',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            if (isBanned)
              Container(
                margin: EdgeInsets.only(left: 8),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'BANNED',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            SizedBox(height: 4),
            Text(
              'UID: ${user.uid}',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Stats
                FutureBuilder<Map<String, dynamic>>(
                  future: _userService.getUserActivity(user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final stats = snapshot.data!;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatChip(
                            icon: Icons.rate_review,
                            label: 'Reviews',
                            value: '${stats['reviewCount']}',
                          ),
                          _buildStatChip(
                            icon: Icons.favorite,
                            label: 'Favorites',
                            value: '${stats['favoritesCount']}',
                          ),
                        ],
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
                SizedBox(height: 16),
                Divider(),
                SizedBox(height: 8),

                // Action Buttons
                Text(
                  'Actions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 12),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildActionButton(
                      label: 'Warn User',
                      icon: Icons.warning_amber,
                      color: Colors.orange,
                      onPressed: () => _showWarnDialog(user),
                    ),
                    _buildActionButton(
                      label: isBanned ? 'Unban' : 'Ban User',
                      icon: isBanned ? Icons.check : Icons.block,
                      color: isBanned ? Colors.green : Colors.red,
                      onPressed: () => isBanned
                          ? _unbanUser(user.uid)
                          : _showBanDialog(user),
                    ),
                    if (user.role != 'admin')
                      _buildActionButton(
                        label: 'Make Admin',
                        icon: Icons.admin_panel_settings,
                        color: Colors.blue,
                        onPressed: () => _changeRole(user.uid, 'admin'),
                      ),
                    if (user.role == 'admin')
                      _buildActionButton(
                        label: 'Remove Admin',
                        icon: Icons.person,
                        color: Colors.grey,
                        onPressed: () => _changeRole(user.uid, 'user'),
                      ),
                    _buildActionButton(
                      label: 'Delete Account',
                      icon: Icons.delete_forever,
                      color: Colors.red[900]!,
                      onPressed: () => _showDeleteDialog(user),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.indigo),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(label, style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  void _showWarnDialog(UserModel user) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Warn ${user.name}'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Warning message',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await _userService.warnUser(user.uid, controller.text.trim());
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Warning sent to ${user.name}')),
                );
              }
            },
            child: Text('Send Warning'),
          ),
        ],
      ),
    );
  }

  void _showBanDialog(UserModel user) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ban ${user.name}'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Ban reason',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await _userService.banUser(user.uid, controller.text.trim());
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${user.name} has been banned')),
                );
              }
            },
            child: Text('Ban User'),
          ),
        ],
      ),
    );
  }

  void _unbanUser(String userId) async {
    await _userService.unbanUser(userId);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('User has been unbanned')));
  }

  void _changeRole(String userId, String newRole) async {
    await _userService.updateUserRole(userId, newRole);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('User role updated to $newRole')));
  }

  void _showDeleteDialog(UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Text(
          'Are you sure you want to permanently delete ${user.name}\'s account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _userService.deleteUserAccount(user.uid);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Account deleted successfully')),
              );
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
