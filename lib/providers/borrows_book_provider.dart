import 'package:flutter/material.dart';
import '../models/borrows_book_model.dart';
import '../services/borrows_book_service.dart';
import '../services/book_service.dart';
import '../models/book_model.dart';

class BorrowProvider with ChangeNotifier {
  final BorrowService _borrowService = BorrowService();
  final BookService _bookService = BookService();

  List<BorrowModel> borrows = []; // all borrows cached or fetched
  List<BorrowModel> myBorrows = []; // cached per user
  bool loading = false;

  // panggil untuk ambil semua borrows (opsional)
  Future<void> fetchBorrows() async {
    loading = true;
    notifyListeners();
    borrows = await _borrowService.getBorrows();
    loading = false;
    notifyListeners();
  }

  // ambil borrows milik user
  Future<void> fetchMyBorrows(String userId) async {
    loading = true;
    notifyListeners();
    myBorrows = await _borrowService.getBorrowsByUser(userId);
    loading = false;
    notifyListeners();
  }

  /// Proses meminjam buku:
  /// 1) cek stok (via getBookById)
  /// 2) kurangi stok (updateBookStock)
  /// 3) buat record borrow
  /// jika step 3 gagal -> rollback stok (tambah lagi)
  Future<bool> borrowBook({
    required String userId,
    required BookModel book,
  }) async {
    // 1) check stock
    if (book.stok <= 0) return false;

    final newStock = book.stok - 1;

    // 2) reduce stok
    final stockUpdated = await _bookService.updateBookStock(book.id!, newStock);
    if (!stockUpdated) return false;

    // 3) create borrow record
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
      // rollback stok
      await _bookService.updateBookStock(book.id!, book.stok);
      return false;
    }

    // success: refresh myBorrows (caller should pass userId)
    await fetchMyBorrows(userId);
    return true;
  }

  /// Proses mengembalikan:
  /// 1) update borrow record (status + returnedAt)
  /// 2) increment stok buku
  /// if any fail, try to rollback
  Future<bool> returnBook({
    required String borrowId,
    required String userId,
    required String bookId,
  }) async {
    // 1) mark returned
    final returnedAt = DateTime.now().toIso8601String();
    final okUpdateBorrow = await _borrowService.updateBorrow(borrowId, {
      "returnedAt": returnedAt,
      "status": "returned",
    });

    if (!okUpdateBorrow) {
      return false;
    }

    // 2) increment stok: get book then increment
    final book = await _bookService.getBookById(bookId);
    if (book == null) {
      // we updated borrow but can't find book — still consider done but warn
      await fetchMyBorrows(userId);
      return true;
    }

    final newStock = book.stok + 1;
    final okStock = await _bookService.updateBookStock(bookId, newStock);
    if (!okStock) {
      // rollback borrow status if we want consistency
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
