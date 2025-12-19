// File: lib/services/database_service.dart
// Simple local database helpers using `sqflite` to store courses and schedules.

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/course.dart';
import '../models/schedule.dart';

/// Service that provides access to a local SQLite database.
///
/// Uses a singleton pattern. Exposes simple CRUD operations
/// for `Course` and `Schedule` models used in the app.
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  /// Returns the open [Database], initializing it if necessary.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize the database and create tables when first opened.
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'superior_university.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  /// Creates the required tables on first run.
  Future<void> _onCreate(Database db, int version) async {
    // Courses table: stores basic course metadata
    await db.execute('''
      CREATE TABLE courses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        instructor TEXT,
        imageUrl TEXT,
        credits INTEGER
      )
    ''');

    // Schedules table: stores course schedules, times and room
    await db.execute('''
      CREATE TABLE schedules(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        courseName TEXT,
        day TEXT,
        startTime TEXT,
        endTime TEXT,
        room TEXT,
        color TEXT
      )
    ''');
  }

  // Course operations

  /// Inserts a [course] into the database and returns the inserted row id.
  Future<int> insertCourse(Course course) async {
    Database db = await database;
    return await db.insert('courses', course.toMap());
  }

  /// Retrieves all courses from the database.
  Future<List<Course>> getCourses() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('courses');
    return List.generate(maps.length, (i) => Course.fromMap(maps[i]));
  }

  // Schedule operations

  /// Inserts a [schedule] row and returns the inserted id.
  Future<int> insertSchedule(Schedule schedule) async {
    Database db = await database;
    return await db.insert('schedules', schedule.toMap());
  }

  /// Retrieves all schedules.
  Future<List<Schedule>> getSchedules() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('schedules');
    return List.generate(maps.length, (i) => Schedule.fromMap(maps[i]));
  }

  /// Retrieves schedules for a specific [day].
  Future<List<Schedule>> getSchedulesByDay(String day) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'schedules',
      where: 'day = ?',
      whereArgs: [day],
    );
    return List.generate(maps.length, (i) => Schedule.fromMap(maps[i]));
  }
}
