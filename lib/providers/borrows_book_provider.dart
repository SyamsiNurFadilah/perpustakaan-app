import 'package:flutter/material.dart';
import '../models/borrows_book_model.dart';
import '../services/borrows_book_service.dart';
import '../services/book_service.dart';
import '../models/book_model.dart';

class BorrowProvider with ChangeNotifier {
  final BorrowService _borrowService = BorrowService();
  final BookService _bookService = BookService();

  List<BorrowModel> borrows = [];
  List<BorrowModel> myBorrows = [];
  bool loading = false;

  Future<void> fetchBorrows() async {
    loading = true;
    notifyListeners();
    borrows = await _borrowService.getBorrows();
    loading = false;
    notifyListeners();
  }

  Future<void> fetchMyBorrows(String userId) async {
    loading = true;
    notifyListeners();
    myBorrows = await _borrowService.getBorrowsByUser(userId);
    loading = false;
    notifyListeners();
  }

  Future<bool> borrowBook({
    required String userId,
    required BookModel book,
  }) async {
    if (book.stok <= 0) return false;

    final newStock = book.stok - 1;

    final stockUpdated = await _bookService.updateBookStock(book.id!, newStock);
    if (!stockUpdated) return false;

    final borrow = BorrowModel(
      userId: userId,
      bookId: book.id!,
      title: book.judul,
      cover: book.cover,
      borrowedAt: DateTime.now().toIso8601String(),
      status: 'borrowed',
    );

    final ok = await _borrowService.createBorrow(borrow);

    if (!ok) {
      await _bookService.updateBookStock(book.id!, book.stok);
      return false;
    }

    await fetchMyBorrows(userId);
    return true;
  }

  Future<bool> returnBook({
    required String borrowId,
    required String userId,
    required String bookId,
  }) async {
    final returnedAt = DateTime.now().toIso8601String();
    final okUpdateBorrow = await _borrowService.updateBorrow(borrowId, {
      "returnedAt": returnedAt,
      "status": "returned",
    });

    if (!okUpdateBorrow) {
      return false;
    }

    final book = await _bookService.getBookById(bookId);
    if (book == null) {
      await fetchMyBorrows(userId);
      return true;
    }

    final newStock = book.stok + 1;
    final okStock = await _bookService.updateBookStock(bookId, newStock);
    if (!okStock) {
      await _borrowService.updateBorrow(borrowId, {
        "returnedAt": null,
        "status": "borrowed",
      });
      return false;
    }

    await fetchMyBorrows(userId);
    return true;
  }
}
