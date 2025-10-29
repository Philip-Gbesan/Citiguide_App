import 'package:citiguide_app/pages/admin/add_category_page.dart';
import 'package:citiguide_app/pages/admin/manage_category.dart';
import 'package:citiguide_app/pages/auth/admin_login_page.dart';
import 'package:citiguide_app/pages/auth/user_login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Screens
import 'loading_screen.dart';
import 'role_selection_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/auth/forgot_password_page.dart';
import 'pages/admin/admin_dashboard.dart';
import 'pages/users/user_dashboard.dart';
import 'pages/admin/add_attraction_page.dart';
import 'pages/admin/add_city_page.dart';
import 'pages/admin/manage_city_page.dart';
import 'pages/admin/manage_attraction_page.dart';
import 'pages/admin/manage_review_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CitiApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF007BFF),
      ),
      home: const LoadingScreen(),

      routes: {
        '/roleSelection': (context) => const RoleSelectionPage(),
        '/forgot': (context) => const ForgotPasswordPage(),
        '/adminDashboard': (context) => const AdminDashboard(),
        '/userDashboard': (context) => const UserDashboard(),
        '/addCity': (context) => const AddCityPage(),
        '/cityList': (context) => const ManageCityPage(),
        '/addAttraction': (context) => const AddAttractionPage(),
        '/manageAttractions': (context) => const ManageAttractionsPage(),
        '/manageReviews': (context) => const ManageReviewsPage(),
        '/userLogin': (context) => const UserLoginPage(),
        '/adminLogin': (context) => const AdminLoginPage(),
        '/addCategory': (context) => const AddCategoryPage(),
        '/manageCategories': (context) => const ManageCategoriesPage(),
      },

      // Safe dynamic route handler for RegisterPage
      onGenerateRoute: (settings) {
        if (settings.name == '/register') {
          // Safely read arguments
          final args = settings.arguments;
          String role = 'user'; // default

          if (args != null && args is Map<String, dynamic> && args['role'] != null) {
            role = args['role'] as String;
          }

          return MaterialPageRoute(
            builder: (context) => RegisterPage(role: role),
          );
        }
        return null;
      },
    );
  }
}
