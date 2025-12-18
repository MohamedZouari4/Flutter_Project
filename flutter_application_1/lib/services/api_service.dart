import '../models/course.dart';

class ApiService {
  // Simple mock fetcher for demo purposes
  Future<List<Course>> fetchCourses() async {
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
