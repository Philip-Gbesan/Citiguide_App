import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'role_selection_page.dart';
import 'pages/admin/admin_dashboard.dart';
import 'pages/users/user_dashboard.dart';
import 'services/auth_service.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(seconds: 2));
    await _controller.reverse();
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    final authService = AuthService();

    if (user == null) {
      _navigateWithFade(const RoleSelectionPage());
      return;
    }

    final userModel = await authService.getUserData(user.uid);

    if (!mounted) return;

    if (userModel == null) {
      _navigateWithFade(const RoleSelectionPage());
      return;
    }

    if (userModel.role == 'admin') {
      _navigateWithFade(const AdminDashboard());
    } else {
      _navigateWithFade(const UserDashboard());
    }
  }

  void _navigateWithFade(Widget page) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF007BFF),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with fallback
                Image.asset(
                  'assets/images/logo1.png',
                  height: screenHeight * 0.25,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: screenHeight * 0.25,
                      width: screenHeight * 0.25,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.location_city, size: 80, color: Colors.white70),
                    );
                  },
                ),
                const SizedBox(height: 15),
                const Text(
                  "Discover • Explore • Connect",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30),
                // Optional progress indicator
                const CircularProgressIndicator(
                  color: Colors.white70,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
