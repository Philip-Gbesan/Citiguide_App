import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'pages/admin/add_attraction_page.dart';
import 'pages/admin/add_city_page.dart';
import 'pages/admin/add_restaurant_page.dart';
import 'pages/admin/city_list_page.dart';
import 'pages/admin/enhanced_admin_dashboard.dart';
import 'pages/admin/manage_attraction_page.dart';
import 'pages/admin/manage_review_page.dart';
import 'pages/admin/user_management_page.dart';
import 'pages/auth/forgot_password_page.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/users/user_dashboard.dart';
import 'services/auth_service.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialPage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const LoginPage();

    final authService = AuthService();
    final userModel = await authService.getUserData(user.uid);
    if (userModel == null) return const LoginPage();

    return userModel.role == 'admin'
        ? const EnhancedAdminDashboard()
        : const UserDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: FutureBuilder<Widget>(
        future: _getInitialPage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            );
          } else {
            return snapshot.data ?? const LoginPage();
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/forgot': (context) => const ForgotPasswordPage(),
        '/adminDashboard': (context) => const EnhancedAdminDashboard(),
        '/userDashboard': (context) => const UserDashboard(),
        '/addCity': (context) => AdminCitiesScreen(),
        '/cityList': (context) => const CityListPage(),
        '/addAttraction': (context) => const AddAttractionPage(),
        '/manageAttractions': (context) => const ManageAttractionsPage(),
        '/manageReviews': (context) => const ManageReviewsPage(),
        '/userManagement': (context) => const UserManagementPage(),
        '/addRestaurant': (context) => AddRestaurantPage(),
      },
    );
  }
}
