import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  // Getter for the database, initializes if null
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize or reset the SQLite database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create 'users' table
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            password TEXT
          );
        ''');

        // Create 'courses' table
        await db.execute('''
          CREATE TABLE courses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            courseName TEXT,
            courseCode TEXT,
            courseClass TEXT
          );
        ''');

        // Insert default admin user
        await db.insert('users', {'username': 'admin', 'password': '12345'});
      },
    );
  }

  // Fetch all courses from the 'courses' table
  Future<List<Map<String, dynamic>>> getCourses() async {
    final db = await database;
    return await db.query('courses'); // Get all rows from the 'courses' table
  }

  // Add a new course
  Future<void> addCourse(String courseName, String courseCode, String courseClass) async {
    try {
      final db = await database;
      await db.insert('courses', {
        'courseName': courseName,
        'courseCode': courseCode,
        'courseClass': courseClass,
      });
      print("Course added successfully: $courseName");
    } catch (e) {
      print("Error adding course: $e");
    }
  }


  // Delete a course by ID
  Future<void> deleteCourse(int id) async {
    final db = await database;
    await db.delete('courses', where: 'id = ?', whereArgs: [id]);
  }

  // Login method
  Future<bool> login(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty;
  }
}
