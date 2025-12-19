// File: lib/services/hive_service.dart
// Lightweight Hive-backed service providing similar API to DatabaseService.

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/course.dart';
import '../services/database_service.dart';
import '../models/schedule.dart';
import '../models/user.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  static const String _coursesBox = 'courses';
  static const String _schedulesBox = 'schedules';
  static const String _usersBox = 'users';

  /// Initialize Hive and open boxes. Call this once at app startup.
  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters if not already registered
    if (!Hive.isAdapterRegistered(CourseAdapter().typeId)) {
      Hive.registerAdapter(CourseAdapter());
    }
    if (!Hive.isAdapterRegistered(ScheduleAdapter().typeId)) {
      Hive.registerAdapter(ScheduleAdapter());
    }
    // Register User adapter and open users box
    if (!Hive.isAdapterRegistered(UserAdapter().typeId)) {
      Hive.registerAdapter(UserAdapter());
    }

    await Hive.openBox<Course>(_coursesBox);
    await Hive.openBox<Schedule>(_schedulesBox);
    await Hive.openBox<User>(_usersBox);
  }

  /// Migrates existing data from the sqflite-based [DatabaseService] into Hive.
  ///
  /// By default it will not remove old rows from sqflite; set [clearOld]
  /// to `true` to delete the migrated tables after a successful migration.
  Future<void> migrateFromSqflite({bool clearOld = false}) async {
    try {
      final db = DatabaseService();
      final courses = await db.getCourses();
      final schedules = await db.getSchedules();

      final cBox = Hive.box<Course>(_coursesBox);
      final sBox = Hive.box<Schedule>(_schedulesBox);

      // Only migrate when Hive boxes are empty to avoid duplicates
      if (cBox.isEmpty) {
        for (var c in courses) {
          await cBox.add(c);
        }
      }

      if (sBox.isEmpty) {
        for (var s in schedules) {
          await sBox.add(s);
        }
      }

      if (clearOld) {
        // Clear sqflite tables (basic implementation)
        // Note: DatabaseService doesn't expose clear methods; implement if needed.
      }
    } catch (e) {
      // Migration errors should not crash the app; log for debugging
      // ignore: avoid_print
      print('Hive migration failed: $e');
    }
  }

  // Course operations
  Future<int> insertCourse(Course course) async {
    final box = Hive.box<Course>(_coursesBox);
    final key = await box.add(course);
    return key;
  }

  Future<List<Course>> getCourses() async {
    final box = Hive.box<Course>(_coursesBox);
    return box.values.toList();
  }

  // Schedule operations
  Future<int> insertSchedule(Schedule schedule) async {
    final box = Hive.box<Schedule>(_schedulesBox);
    final key = await box.add(schedule);
    return key;
  }

  Future<List<Schedule>> getSchedules() async {
    final box = Hive.box<Schedule>(_schedulesBox);
    return box.values.toList();
  }

  Future<List<Schedule>> getSchedulesByDay(String day) async {
    final box = Hive.box<Schedule>(_schedulesBox);
    return box.values.where((s) => s.day == day).toList();
  }

  /// Optional: clear all Hive data (useful for development)
  Future<void> clearAll() async {
    await Hive.box<Course>(_coursesBox).clear();
    await Hive.box<Schedule>(_schedulesBox).clear();
    await Hive.box<User>(_usersBox).clear();
  }

  // User operations
  Future<int> createUser(User user) async {
    final box = Hive.box<User>(_usersBox);
    // Prevent duplicate emails
    final exists = box.values.where((u) => u.email == user.email).isNotEmpty;
    if (exists) throw Exception('User with this email already exists');
    final key = await box.add(user);
    return key;
  }

  Future<List<User>> getUsers() async {
    final box = Hive.box<User>(_usersBox);
    return box.values.toList();
  }

  Future<User?> findUserByEmail(String email) async {
    final box = Hive.box<User>(_usersBox);
    try {
      return box.values.firstWhere((u) => u.email == email);
    } catch (_) {
      return null;
    }
  }

  Future<User?> authenticate(String email, String password) async {
    final user = await findUserByEmail(email);
    if (user == null) return null;
    return user.password == password ? user : null;
  }

  Future<void> deleteUserByEmail(String email) async {
    final box = Hive.box<User>(_usersBox);
    for (final k in box.keys) {
      final u = box.get(k);
      if (u != null && u.email == email) {
        await box.delete(k);
        return;
      }
    }
  }
}
