// File: lib/Screens/splash_screen.dart
// Simple splash screen shown on app startup.

import 'package:flutter/material.dart';
import 'dart:async';
import 'onboarding_screen.dart';

/// Displays a brief splash screen and navigates to onboarding after a delay.
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // After a short delay, navigate to the onboarding flow.
    // The Timer avoids blocking init and allows the UI to build once.
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E3A8A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Superior University',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Student Learning Platform',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
