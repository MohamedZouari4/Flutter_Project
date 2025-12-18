import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/course.dart';
import '../models/schedule.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'superior_university.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
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
  Future<int> insertCourse(Course course) async {
    Database db = await database;
    return await db.insert('courses', course.toMap());
  }

  Future<List<Course>> getCourses() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('courses');
    return List.generate(maps.length, (i) => Course.fromMap(maps[i]));
  }

  // Schedule operations
  Future<int> insertSchedule(Schedule schedule) async {
    Database db = await database;
    return await db.insert('schedules', schedule.toMap());
  }

  Future<List<Schedule>> getSchedules() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('schedules');
    return List.generate(maps.length, (i) => Schedule.fromMap(maps[i]));
  }

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