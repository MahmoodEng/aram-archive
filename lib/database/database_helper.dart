import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/box_model.dart';
import '../models/book_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'aram_archive.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE boxes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        box_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        page_count INTEGER DEFAULT 0,
        pdf_path TEXT,
        is_favorite INTEGER DEFAULT 0,
        created_at TEXT,
        FOREIGN KEY (box_id) REFERENCES boxes (id) ON DELETE CASCADE
      )
    ''');
  }

  // ---- Box CRUD ----

  Future<int> insertBox(BoxModel box) async {
    final db = await database;
    return db.insert('boxes', box.toMap()..remove('id'));
  }

  Future<List<BoxModel>> getAllBoxes() async {
    final db = await database;
    final maps = await db.query('boxes', orderBy: 'created_at DESC');
    return maps.map((m) => BoxModel.fromMap(m)).toList();
  }

  Future<int> updateBox(BoxModel box) async {
    final db = await database;
    return db.update(
      'boxes',
      box.toMap(),
      where: 'id = ?',
      whereArgs: [box.id],
    );
  }

  Future<int> deleteBox(int id) async {
    final db = await database;
    await db.delete('books', where: 'box_id = ?', whereArgs: [id]);
    return db.delete('boxes', where: 'id = ?', whereArgs: [id]);
  }

  // ---- Book CRUD ----

  Future<int> insertBook(BookModel book) async {
    final db = await database;
    return db.insert('books', book.toMap()..remove('id'));
  }

  Future<List<BookModel>> getBooksForBox(int boxId) async {
    final db = await database;
    final maps = await db.query(
      'books',
      where: 'box_id = ?',
      whereArgs: [boxId],
      orderBy: 'created_at DESC',
    );
    return maps.map((m) => BookModel.fromMap(m)).toList();
  }

  Future<int> updateBook(BookModel book) async {
    final db = await database;
    return db.update(
      'books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  Future<int> deleteBook(int id) async {
    final db = await database;
    return db.delete('books', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> toggleFavorite(int id, bool isFavorite) async {
    final db = await database;
    return db.update(
      'books',
      {'is_favorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ---- Favorites ----

  Future<List<BookModel>> getFavoriteBooks() async {
    final db = await database;
    final maps = await db.query(
      'books',
      where: 'is_favorite = ?',
      whereArgs: [1],
      orderBy: 'created_at DESC',
    );
    return maps.map((m) => BookModel.fromMap(m)).toList();
  }

  // ---- Search ----

  Future<Map<String, dynamic>> search(String query) async {
    final db = await database;
    final q = '%${query.toLowerCase()}%';

    final boxMaps = await db.query(
      'boxes',
      where: 'LOWER(name) LIKE ?',
      whereArgs: [q],
    );

    final bookMaps = await db.query(
      'books',
      where: 'LOWER(name) LIKE ?',
      whereArgs: [q],
    );

    return {
      'boxes': boxMaps.map((m) => BoxModel.fromMap(m)).toList(),
      'books': bookMaps.map((m) => BookModel.fromMap(m)).toList(),
    };
  }

  Future<BoxModel?> getBoxById(int id) async {
    final db = await database;
    final maps =
        await db.query('boxes', where: 'id = ?', whereArgs: [id], limit: 1);
    if (maps.isEmpty) return null;
    return BoxModel.fromMap(maps.first);
  }
}
