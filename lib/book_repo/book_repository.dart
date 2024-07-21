import 'package:ebook/database_helper/database_helper.dart';
import 'package:ebook/models/book_model.dart';
import 'package:ebook/models/borrowing_model.dart';
class BookRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
    Future<List<BorrowingModel>> getBorrowingsByUser(int userId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'borrowing',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return BorrowingModel(
        id: maps[i]['id'],
        bookId: maps[i]['book_id'],
        userId: maps[i]['user_id'],
        borrowedAt: maps[i]['borrowed_at'],
      );
    });
  }

  Future<Book> getBookById(int bookId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where: 'id = ?',
      whereArgs: [bookId],
    );

    if (maps.isNotEmpty) {
      return Book(
        id: maps[0]['id'],
        title: maps[0]['title'],
        subtitle: maps[0]['subtitle'],
        author: maps[0]['author'],
        programmingLanguage: maps[0]['programming_language'],
        imagePath: maps[0]['image_path'],
        copies: maps[0]['copies'],
      );
    } else {
      throw Exception('Book not found');
    }
  }


  Future<List<Book>> getAllBooks() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('books');

    return List.generate(maps.length, (i) {
      return Book(
        id: maps[i]['id'],
        title: maps[i]['title'],
        subtitle: maps[i]['subtitle'],
        author: maps[i]['author'],
        programmingLanguage: maps[i]['programming_language'],
        imagePath: maps[i]['image_path'],
        copies: maps[i]['copies'],
      );
    });
  }

  Future<void> insertBook(Book book) async {
    final db = await _databaseHelper.database;
    await db.insert('books', book.toMap());
  }

  Future<void> updateBook(Book book) async {
    final db = await _databaseHelper.database;
    await db.update('books', book.toMap(), where: 'id = ?', whereArgs: [book.id]);
  }

  Future<void> deleteBook(int id) async {
    final db = await _databaseHelper.database;
    await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> borrowBook(int bookId, int userId) async {
    final db = await _databaseHelper.database;

    List<Map<String, dynamic>> bookList = await db.query('books', where: 'id = ?', whereArgs: [bookId]);
    if (bookList.isNotEmpty && bookList[0]['copies'] > 0) {
      await db.update('books', {'copies': bookList[0]['copies'] - 1}, where: 'id = ?', whereArgs: [bookId]);

      await db.insert('borrowing', {
        'book_id': bookId,
        'user_id': userId,
        'borrowed_at': DateTime.now().toIso8601String(),
      });
    } else {
      throw Exception('Book is not available');
    }
  }

  Future<void> returnBook(int bookId, int userId) async {
    final db = await _databaseHelper.database;

    List<Map<String, dynamic>> bookList = await db.query('books', where: 'id = ?', whereArgs: [bookId]);
    if (bookList.isNotEmpty) {
      await db.update('books', {'copies': bookList[0]['copies'] + 1}, where: 'id = ?', whereArgs: [bookId]);

      await db.delete('borrowing', where: 'book_id = ? AND user_id = ?', whereArgs: [bookId, userId]);
    }
  }
}
