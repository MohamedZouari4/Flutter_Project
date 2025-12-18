import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Screens/splash_screen.dart';

void main() {
  runApp(SuperiorUniversityApp());
}

class SuperiorUniversityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Superior University',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF1E3A8A),
          primary: Color(0xFF1E3A8A),
          secondary: Color(0xFF42A5F5),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[50],
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1E3A8A),
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
