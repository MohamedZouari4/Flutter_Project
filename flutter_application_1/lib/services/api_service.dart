// File: lib/services/api_service.dart
// Simple API helpers (mocked) used by the app for demo and testing.

import '../models/course.dart';

/// Service that provides course data.
///
/// This is a lightweight mocked implementation that simulates
/// network delay and returns example `Course` instances.
class ApiService {
  /// Fetches a list of courses.
  /// Simulates a short network latency to mimic a real API call.
  Future<List<Course>> fetchCourses() async {
    // Simulated network delay
    await Future.delayed(Duration(milliseconds: 300));
    return [
      Course(
        title: 'Introduction to Computer Science',
        description: 'Foundations of computing and programming',
        instructor: 'Dr. Smith',
        imageUrl: 'https://via.placeholder.com/150',
        credits: 3,
      ),
      Course(
        title: 'Calculus I',
        description: 'Limits, derivatives and integrals',
        instructor: 'Prof. Johnson',
        imageUrl: 'https://via.placeholder.com/150',
        credits: 4,
      ),
    ];
  }
}
