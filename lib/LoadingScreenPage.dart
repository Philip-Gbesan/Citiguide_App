import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'PreviousFile/RoleSelectionPage.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller for the logo rotation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Define the back-and-forth rotation animation
    _rotationAnimation = Tween<double>(begin: -0.2, end: 0.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Start the animation after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });

    // Navigate to LoginPage after 6 seconds total
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RoleSelectionPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF007BFF), // Blue background
      body: Center(
        child: AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value * math.pi, // Rotate left ↔ right
              child: child,
            );
          },
          child: Image.asset(
            'assets/logo1.png',
            width: screenWidth * 0.4, // Responsive scaling
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
