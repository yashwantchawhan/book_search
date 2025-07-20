import 'package:local_db/book.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static Database? _db;

  static Future init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'books.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE books (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            author TEXT,
            coverUrl TEXT,
            key TEXT,
            description TEXT
          )
        ''');
      },
    );
  }

  static Future<void> saveBook(Book book) async {
    await _db!.insert(
      'books',
      {
        'title': book.title,
        'author': book.author,
        'coverUrl': book.coverUrl,
        'key': book.key,
        'description': book.description
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteBook(Book book) async {
    await _db!.delete(
      'books',
      where: 'title = ? AND author = ?',
      whereArgs: [book.title, book.author],
    );
  }

  static Future<bool> isBookSaved(Book book) async {
    final result = await _db!.query(
      'books',
      where: 'title = ? AND author = ?',
      whereArgs: [book.title, book.author],
    );
    return result.isNotEmpty;
  }

  static Future<List<Book>> getAllBooks() async {
    final result = await _db!.query('books');
    return result
        .map(
          (e) => Book(
            title: e['title'] as String,
            author: e['author'] as String,
            coverUrl: e['coverUrl'] as String,
            key: e['key'] as String,
            description: e['description'] as String,
          ),
        )
        .toList();
  }

  static Future<Book?> getBookByKey(String key) async {
    final result = await _db!.query(
      'books',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );

    if (result.isNotEmpty) {
      final e = result.first;
      return Book(
        title: e['title'] as String,
        author: e['author'] as String,
        coverUrl: e['coverUrl'] as String,
        key: e['key'] as String,
        description: e['description'] as String,
      );
    }

    return null; // not found
  }

}
