import 'package:citiguide_app/pages/users/profile_settings_page.dart';
import 'package:citiguide_app/pages/users/user_favorites_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import '../auth/user_login_page.dart';
import 'edit_profile_page.dart';
import 'users_city_attractions_page.dart';
import 'user_profile_page.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final AuthService _authService = AuthService();
  int _selectedIndex = 2; // Default center "CitiApp"
  final Color appColor = Color(0xFF007BFF); // App theme color

  // Controllers for search
  String _searchQuery = '';

  Future<void> _handleSignOut(BuildContext context) async {
    try {
      await _authService.signOut();
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => UserLoginPage()),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: $e')),
        );
      }
    }
  }

  void _onNavItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  // Bottom nav item widget
  Widget _buildNavItem({
    required String label,
    required IconData icon,
    required int index,
    String? assetPath,
  }) {
    bool isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onNavItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          assetPath != null
              ? Image.asset(
            assetPath,
            height: isActive ? 28 : 24,
            width: isActive ? 28 : 24,
            color: appColor,
            errorBuilder: (context, error, stackTrace) =>
                Icon(icon, size: isActive ? 28 : 24, color: appColor),
          )
              : Icon(icon, size: isActive ? 28 : 24, color: appColor),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: appColor,
              fontSize: isActive ? 14 : 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Main content per tab
  Widget _buildPage() {
    switch (_selectedIndex) {
      case 0: // Search
        return _buildCitiAppPage();
      case 1: // Favorites
        return UserFavoritesPage();
      case 2: // CitiApp (Home)
        return _buildCitiAppPage();
      case 3: // Settings
        return SettingsPage();
      case 4: // Profile
        return UserProfilePage();
      default:
        return _buildCitiAppPage();
    }
  }

  // Search page (you can customize)
  Widget _buildSearchPage() {
    return Center(child: Text('Search Page'));
  }

  // CitiApp / main home page
  Widget _buildCitiAppPage() {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: EdgeInsets.all(12.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search up cities to explore',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value.trim().toLowerCase());
            },
          ),
        ),
        // City grid
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('cities')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return  Center(child: Text('No cities available yet.'));
              }

              final allCities = snapshot.data!.docs;
              final filteredCities = allCities.where((doc) {
                final city = doc.data() as Map<String, dynamic>;
                final name = (city['name'] ?? '').toString().toLowerCase();
                return name.contains(_searchQuery);
              }).toList();

              if (filteredCities.isEmpty) {
                return Center(child: Text('No cities match your search.'));
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 2;
                  double width = constraints.maxWidth;
                  if (width > 600 && width <= 900) crossAxisCount = 3;
                  if (width > 900) crossAxisCount = 4;

                  return GridView.builder(
                    padding: EdgeInsets.all(12),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: filteredCities.length,
                    itemBuilder: (context, index) {
                      final cityDoc = filteredCities[index];
                      final city = cityDoc.data() as Map<String, dynamic>;
                      final cityId = cityDoc.id;
                      final imageUrl = city['imageUrl'] ?? '';
                      final cityName = city['name'] ?? 'Unnamed City';

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UsersCityAttractionsPage(
                                cityId: cityId,
                                cityName: cityName,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: imageUrl.isNotEmpty
                                    ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                  Icon(Icons.broken_image, size: 60),
                                )
                                    : Container(
                                  color: Colors.grey[300],
                                  child: Icon(Icons.location_city, size: 60),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                color: Colors.grey[100],
                                child: Text(
                                  cityName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        leading: IconButton(
          icon: Icon(Icons.person_outline),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UserProfilePage()),
            );
          },
        ),
        title: Text('Beautiful Cities to Explore', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () => _onNavItemTapped(1),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _onNavItemTapped(3),
          ),
        ],
      ),
      body: _buildPage(),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(icon: Icons.search, label: 'Search', index: 0),
              _buildNavItem(icon: Icons.favorite_border, label: 'Favorites', index: 1),
              _buildNavItem(
                label: 'CitiApp',
                index: 2,
                assetPath: 'assets/images/icon.png',
                icon: Icons.home,
              ),
              _buildNavItem(icon: Icons.settings, label: 'Settings', index: 3),
              _buildNavItem(icon: Icons.person_outline, label: 'Profile', index: 4),
            ],
          ),
        ),
      ),
    );
  }
}
