import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/analytics_model.dart';
import '../../services/analytics_service.dart';

class EnhancedAdminDashboard extends StatefulWidget {
  const EnhancedAdminDashboard({super.key});

  @override
  State<EnhancedAdminDashboard> createState() => _EnhancedAdminDashboardState();
}

class _EnhancedAdminDashboardState extends State<EnhancedAdminDashboard> {
  final AnalyticsService _analyticsService = AnalyticsService();
  final User? user = FirebaseAuth.instance.currentUser;

  int _selectedIndex = 0;

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: Icon(Icons.logout),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _getSelectedPage(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            accountName: Text('Admin'),
            accountEmail: Text(user?.email ?? 'admin@cityguide.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.admin_panel_settings,
                size: 40,
                color: Colors.indigo,
              ),
            ),
          ),

          _buildDrawerItem(icon: Icons.dashboard, title: 'Dashboard', index: 0),

          Divider(),

          _buildDrawerHeader('Content Management'),
          _buildDrawerItem(
            icon: Icons.location_city,
            title: 'Manage Cities',
            index: 1,
          ),
          _buildDrawerItem(
            icon: Icons.place,
            title: 'Manage Attractions',
            index: 2,
          ),
          _buildDrawerItem(icon: Icons.event, title: 'Manage Events', index: 3),

          Divider(),

          _buildDrawerHeader('User & Content'),
          _buildDrawerItem(
            icon: Icons.people,
            title: 'User Management',
            index: 4,
          ),
          _buildDrawerItem(
            icon: Icons.rate_review,
            title: 'Review Moderation',
            index: 5,
          ),

          Divider(),

          _buildDrawerHeader('Communication'),
          _buildDrawerItem(
            icon: Icons.notifications,
            title: 'Notifications',
            index: 6,
          ),

          Divider(),

          _buildDrawerHeader('Reports'),
          _buildDrawerItem(icon: Icons.analytics, title: 'Analytics', index: 7),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.indigo : Colors.grey[700]),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.indigo : Colors.black87,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.indigo.withOpacity(0.1),
      onTap: () {
        setState(() => _selectedIndex = index);
        Navigator.pop(context);
      },
    );
  }

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardHome();
      case 1:
        return Center(child: Text('Cities - Navigate via routes'));
      case 2:
        return Center(child: Text('Attractions - Navigate via routes'));
      case 3:
        return Center(child: Text('Events - Coming Soon'));
      case 4:
        return Center(child: Text('User Management - Coming Soon'));
      case 5:
        return Center(child: Text('Reviews - Navigate via routes'));
      case 6:
        return Center(child: Text('Notifications - Coming Soon'));
      case 7:
        return Center(child: Text('Analytics - Coming Soon'));
      default:
        return _buildDashboardHome();
    }
  }

  Widget _buildDashboardHome() {
    return FutureBuilder<AnalyticsModel>(
      future: _analyticsService.getDashboardAnalytics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final analytics = snapshot.data ?? AnalyticsModel.empty();

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                _buildWelcomeCard(),
                SizedBox(height: 24),

                // Statistics Cards
                Text(
                  'Overview Statistics',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                _buildStatisticsGrid(analytics),
                SizedBox(height: 24),

                // Quick Actions
                Text(
                  'Quick Actions',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                _buildQuickActions(),
                SizedBox(height: 24),

                // Pending Items
                if (analytics.pendingReviews > 0) ...[
                  Text(
                    'Pending Actions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _buildPendingActions(analytics),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 0,
      color: Colors.indigo.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.wb_sunny, color: Colors.orange, size: 40),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good ${_getGreeting()}!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Welcome back to your admin dashboard',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  Widget _buildStatisticsGrid(AnalyticsModel analytics) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          icon: Icons.people,
          title: 'Total Users',
          value: '${analytics.totalUsers}',
          subtitle: '${analytics.activeUsers} active',
          color: Colors.blue,
        ),
        _buildStatCard(
          icon: Icons.location_city,
          title: 'Cities',
          value: '${analytics.totalCities}',
          subtitle: 'Available',
          color: Colors.green,
        ),
        _buildStatCard(
          icon: Icons.place,
          title: 'Attractions',
          value: '${analytics.totalAttractions}',
          subtitle: 'Listed',
          color: Colors.orange,
        ),
        _buildStatCard(
          icon: Icons.star,
          title: 'Avg Rating',
          value: analytics.averageRating.toStringAsFixed(1),
          subtitle: '${analytics.totalReviews} reviews',
          color: Colors.amber,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 32),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      children: [
        _buildActionTile(
          icon: Icons.add_location_alt,
          title: 'Add New City',
          subtitle: 'Create a new city listing',
          color: Colors.teal,
          onTap: () => Navigator.pushNamed(context, '/addCity'),
        ),
        SizedBox(height: 12),
        _buildActionTile(
          icon: Icons.add_business,
          title: 'Add New Attraction',
          subtitle: 'Add attraction to existing city',
          color: Colors.purple,
          onTap: () => Navigator.pushNamed(context, '/addAttraction'),
        ),
        SizedBox(height: 12),
        _buildActionTile(
          icon: Icons.reviews,
          title: 'Moderate Reviews',
          subtitle: 'Review pending submissions',
          color: Colors.orange,
          onTap: () => Navigator.pushNamed(context, '/manageReviews'),
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildPendingActions(AnalyticsModel analytics) {
    return Card(
      color: Colors.orange.withOpacity(0.1),
      child: ListTile(
        leading: Icon(Icons.pending_actions, color: Colors.orange, size: 32),
        title: Text(
          '${analytics.pendingReviews} Pending Reviews',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Requires your attention'),
        trailing: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/manageReviews'),
          child: Text('Review Now'),
        ),
      ),
    );
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import 'add_city_page.dart';
// // import 'admin_restaurants_screen.dart';
// import 'event_management_page.dart';
//
// class EnhancedAdminDashboard extends StatefulWidget {
//   const EnhancedAdminDashboard({super.key});
//
//   @override
//   State<EnhancedAdminDashboard> createState() => _EnhancedAdminDashboardState();
// }
//
// class _EnhancedAdminDashboardState extends State<EnhancedAdminDashboard> {
//   int _selectedIndex = 0;
//
//   final List<Widget> _screens = [
//     AdminCitiesScreen(),
//     // CityAttractionsPage(),
//     // AdminRestaurantsScreen(),
//     EventManagementPage(),
//   ];
//
//   void _signOut() async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Sign Out'),
//         content: Text('Are you sure you want to sign out?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: Text('Sign Out'),
//           ),
//         ],
//       ),
//     );
//
//     if (confirmed == true) {
//       await FirebaseAuth.instance.signOut();
//       if (mounted) {
//         Navigator.pushReplacementNamed(context, '/login');
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF1976D2), // Blue color from Figma
//         elevation: 0,
//         leading: Builder(
//           builder: (context) => IconButton(
//             icon: Icon(Icons.menu, color: Colors.white),
//             onPressed: () => Scaffold.of(context).openDrawer(),
//           ),
//         ),
//         title: Text(
//           'ADMIN DASHBOARD',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             letterSpacing: 0.5,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.notifications_outlined, color: Colors.white),
//             onPressed: () {
//               // Navigate to notifications
//             },
//           ),
//           Container(
//             margin: EdgeInsets.only(right: 12),
//             child: CircleAvatar(
//               radius: 18,
//               backgroundColor: Colors.white,
//               child: Icon(Icons.person, color: Color(0xFF1976D2), size: 20),
//             ),
//           ),
//         ],
//       ),
//       drawer: _buildDrawer(),
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 4,
//               offset: Offset(0, -2),
//             ),
//           ],
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildNavItem(Icons.location_city, 'Cities', 0),
//                 _buildNavItem(Icons.place, 'Attractions', 1),
//                 _buildNavItem(Icons.restaurant, 'Restaurants', 2),
//                 _buildNavItem(Icons.event, 'Events', 3),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNavItem(IconData icon, String label, int index) {
//     final isSelected = _selectedIndex == index;
//     return GestureDetector(
//       onTap: () => setState(() => _selectedIndex = index),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected
//               ? Color(0xFF1976D2).withOpacity(0.1)
//               : Colors.transparent,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               icon,
//               color: isSelected ? Color(0xFF1976D2) : Colors.grey[600],
//               size: 24,
//             ),
//             SizedBox(height: 4),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 11,
//                 color: isSelected ? Color(0xFF1976D2) : Colors.grey[600],
//                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDrawer() {
//     final user = FirebaseAuth.instance.currentUser;
//
//     return Drawer(
//       child: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.fromLTRB(24, 60, 24, 24),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CircleAvatar(
//                   radius: 40,
//                   backgroundColor: Colors.white,
//                   child: Icon(
//                     Icons.admin_panel_settings,
//                     size: 40,
//                     color: Color(0xFF1976D2),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'Admin Panel',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   user?.email ?? 'admin@cityguide.com',
//                   style: TextStyle(color: Colors.white70, fontSize: 14),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.symmetric(vertical: 16),
//               children: [
//                 _buildDrawerItem(
//                   icon: Icons.dashboard,
//                   title: 'Dashboard',
//                   onTap: () => Navigator.pop(context),
//                 ),
//                 _buildDrawerItem(
//                   icon: Icons.people,
//                   title: 'User Management',
//                   onTap: () {
//                     Navigator.pop(context);
//                     // Navigate to user management
//                   },
//                 ),
//                 _buildDrawerItem(
//                   icon: Icons.rate_review,
//                   title: 'Review Moderation',
//                   onTap: () {
//                     Navigator.pop(context);
//                     Navigator.pushNamed(context, '/manageReviews');
//                   },
//                 ),
//                 _buildDrawerItem(
//                   icon: Icons.analytics,
//                   title: 'Analytics',
//                   onTap: () {
//                     Navigator.pop(context);
//                     // Navigate to analytics
//                   },
//                 ),
//                 Divider(),
//                 _buildDrawerItem(
//                   icon: Icons.settings,
//                   title: 'Settings',
//                   onTap: () {
//                     Navigator.pop(context);
//                     // Navigate to settings
//                   },
//                 ),
//                 _buildDrawerItem(
//                   icon: Icons.help_outline,
//                   title: 'Help & Support',
//                   onTap: () {
//                     Navigator.pop(context);
//                     // Navigate to help
//                   },
//                 ),
//               ],
//             ),
//           ),
//           Divider(height: 1),
//           _buildDrawerItem(
//             icon: Icons.logout,
//             title: 'Sign Out',
//             onTap: () {
//               Navigator.pop(context);
//               _signOut();
//             },
//             textColor: Colors.red,
//           ),
//           SizedBox(height: 16),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDrawerItem({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     Color? textColor,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: textColor ?? Colors.grey[700]),
//       title: Text(
//         title,
//         style: TextStyle(color: textColor ?? Colors.black87, fontSize: 15),
//       ),
//       onTap: onTap,
//     );
//   }
// }
