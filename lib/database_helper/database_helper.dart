import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'books.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }
Future<void> _onCreate(Database db, int version) async {
  await db.execute('''
    CREATE TABLE books (
      id INTEGER PRIMARY KEY,
      title TEXT,
      subtitle TEXT,
      author TEXT,
      programming_language TEXT,
      image_path TEXT,
      copies INTEGER
    )
  ''');

  await db.execute('''
    CREATE TABLE borrowing (
      id INTEGER PRIMARY KEY,
      book_id INTEGER,
      user_id INTEGER,
      borrowed_at TEXT,
      FOREIGN KEY (book_id) REFERENCES books(id)
    )
  ''');

  await db.insert('books', {
    'title': 'Clean Code',
    'subtitle': 'A Handbook of Agile Software Craftsmanship',
    'author': 'Robert C. Martin',
    'programming_language': 'General',
    'image_path': "assets/images/codepen.jpg",
    'copies': 5
  });

  await db.insert('books', {
    'title': 'The Pragmatic',
    'subtitle': 'Your Journey to Mastery',
    'author': 'Andrew Hunt, David Thomas',
    'programming_language': 'General',
    'image_path': "assets/images/codepen.jpg",
    'copies': 4
  });

  await db.insert('books', {
    'title': 'Flutter Books',
    'subtitle': 'An introductory guide to building cross-platform mobile applications with Flutter and Dart 2',
    'author': 'Alessandro Biessek',
    'programming_language': 'Dart',
    'image_path': "assets/images/codepen.jpg",
    'copies': 0
  });
}

}
