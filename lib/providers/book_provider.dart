import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/book_service.dart';

class BookProvider extends ChangeNotifier {
  List<BookModel> books = [];
  bool loading = false;

  final BookService _service = BookService();

  Future<void> fetchBooks() async {
    try {
      loading = true;
      notifyListeners();

      books = await _service.getBooks();
    } catch (e) {
      books = []; // fallback kalau API error
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> addBook(BookModel book) async {
    bool ok = await _service.addBook(book);
    if (ok) fetchBooks();
    return ok;
  }

  Future<bool> updateBook(BookModel book) async {
    bool ok = await _service.updateBook(book.id as BookModel, book);
    if (ok) fetchBooks();
    return ok;
  }

  Future<bool> deleteBook(String id) async {
    bool ok = await _service.deleteBook(id);
    if (ok) fetchBooks();
    return ok;
  }
}
