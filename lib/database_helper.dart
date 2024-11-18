import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Kullanıcı tablosu oluştur
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            password TEXT
          );
        ''');
        // Dersler tablosu oluştur
        await db.execute('''
          CREATE TABLE dersler (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            dersAd TEXT,
            DersKod TEXT,
            Sinif TEXT
          );
        ''');
        // Başlangıç verilerini ekle
        await db.insert('users', {'username': 'admin', 'password': '12345'});
      },
    );
  }

  // Kullanıcı giriş kontrolü
  Future<bool> login(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty;
  }

  // Ders ekleme
  Future<void> addCourse(String dersAd, String DersKod, String Sinif) async {
    final db = await database;
    await db.insert('dersler', {
      'dersAd': dersAd,
      'DersKod': DersKod,
      'Sinif': Sinif,
    });
  }

  // Ders silme
  Future<void> deleteCourse(int id) async {
    final db = await database;
    await db.delete('dersler', where: 'id = ?', whereArgs: [id]);
  }

  // Ders güncelleme
  Future<void> updateCourse(int id, String dersAd, String DersKod) async {
    final db = await database;
    await db.update(
      'dersler',
      {'dersAd': dersAd, 'DersKod': DersKod},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Dersleri listeleme
  Future<List<Map<String, dynamic>>> getCourses() async {
    final db = await database;
    return await db.query('dersler');
  }

  // Veritabanındaki tabloları yazdırma
  Future<void> printTables() async {
    final db = await database;
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table';"
    );
    print('Tables: $tables');
  }
}
