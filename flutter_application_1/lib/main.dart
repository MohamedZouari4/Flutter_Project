// Main entry point and app configuration for the Superior University Flutter app.
// Contains theme setup and initial route (SplashScreen).
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Screens/splash_screen.dart';
import 'services/hive_service.dart';

// Launches the Superior University application.
// Initialize local services (Hive) before running the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService().init();
  // Attempt automatic migration from existing sqflite DB if present
  await HiveService().migrateFromSqflite();
  runApp(SuperiorUniversityApp());
}

// Root widget that configures the MaterialApp theme and home screen.
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
