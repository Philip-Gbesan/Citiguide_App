import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    Future<void> signOut() async {
      try {
        await FirebaseAuth.instance.signOut();

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/adminLogin',
              (route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: $e')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: signOut,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            SizedBox(height: 10),

            // Welcome Message
            Text(
              'Welcome, ${user?.email ?? 'Admin'}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: 25),

            // City Management
            Text(
              'City Management',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _DashboardTile(
              icon: Icons.add_location_alt_outlined,
              title: 'Add New City',
              color: Colors.teal.shade400,
              onTap: () => Navigator.pushNamed(context, '/addCity'),
            ),
            _DashboardTile(
              icon: Icons.location_city,
              title: 'Manage Cities',
              color: Colors.blue.shade400,
              onTap: () => Navigator.pushNamed(context, '/cityList'),
            ),

            SizedBox(height: 40),

            // Category Management
            Text(
              'Category Management',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _DashboardTile(
              icon: Icons.add,
              title: 'Add Category',
              color: Colors.pink.shade400,
              onTap: () => Navigator.pushNamed(context, '/addCategory'),
            ),
            _DashboardTile(
              icon: Icons.category,
              title: 'Manage Categories',
              color: Colors.indigo.shade400,
              onTap: () => Navigator.pushNamed(context, '/manageCategories'),
            ),

            SizedBox(height: 40),

            //Attraction Management
            Text(
              'Attraction Management',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _DashboardTile(
              icon: Icons.add_business_rounded,
              title: 'Add New Attraction',
              color: Colors.purple.shade400,
              onTap: () => Navigator.pushNamed(context, '/addAttraction'),
            ),
            _DashboardTile(
              icon: Icons.map_rounded,
              title: 'Manage Attractions',
              color: Colors.orange.shade400,
              onTap: () => Navigator.pushNamed(context, '/manageAttractions'),
            ),

            SizedBox(height: 40),



            //Review Management
            Text(
              'Review Management',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _DashboardTile(
              icon: Icons.reviews_outlined,
              title: 'Manage Reviews',
              color: Colors.green.shade400,
              onTap: () => Navigator.pushNamed(context, '/manageReviews'),
            ),

            SizedBox(height: 40),

            //  Account Settings
            Text(
              'Account Settings',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _DashboardTile(
              icon: Icons.logout,
              title: 'Sign Out',
              color: Colors.red.shade400,
              onTap: signOut,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _DashboardTile({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
        onTap: onTap,
      ),
    );
  }
}
