import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/book_model.dart';

class BookProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();
  List<BookModel> _books = [];
  List<BookModel> _favorites = [];

  List<BookModel> get books => _books;
  List<BookModel> get favorites => _favorites;

  Future<void> loadBooks(int boxId) async {
    _books = await _db.getBooksForBox(boxId);
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    _favorites = await _db.getFavoriteBooks();
    notifyListeners();
  }

  Future<void> addBook(BookModel book) async {
    await _db.insertBook(book);
    await loadBooks(book.boxId);
  }

  Future<void> updateBook(BookModel book) async {
    await _db.updateBook(book);
    await loadBooks(book.boxId);
  }

  Future<void> deleteBook(int id, int boxId) async {
    await _db.deleteBook(id);
    await loadBooks(boxId);
  }

  Future<void> toggleFavorite(BookModel book) async {
    await _db.toggleFavorite(book.id!, !book.isFavorite);
    await loadBooks(book.boxId);
    await loadFavorites();
  }
}
