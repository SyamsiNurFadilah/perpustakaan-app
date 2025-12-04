import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

class BookService {
  static const String baseUrl =
      'https://691ee2fbbb52a1db22bf8e41.mockapi.io/books';

  Future<List<BookModel>> getBooks() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      List data = json.decode(res.body);
      return data.map((e) => BookModel.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data buku (${res.statusCode})");
    }
  }

  Future<bool> addBook(BookModel book) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(book.toJson()),
    );

    if (res.statusCode == 201) {
      return true;
    } else {
      print("ERROR ADD: ${res.statusCode} | ${res.body}");
      return false;
    }
  }

  Future<bool> updateBook(String id, BookModel book) async {
    final res = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(book.toJson()),
    );

    if (res.statusCode == 200) {
      return true;
    } else {
      print("ERROR UPDATE: ${res.statusCode} | ${res.body}");
      return false;
    }
  }

  Future<BookModel?> getBookById(String id) async {
    final res = await http.get(Uri.parse('$baseUrl/$id'));
    if (res.statusCode == 200) {
      return BookModel.fromJson(json.decode(res.body));
    }
    return null;
  }

  Future<bool> updateBookStock(String id, int newStock) async {
    final book = await getBookById(id);
    if (book == null) return false;

    final updated = BookModel(
      id: book.id,
      judul: book.judul,
      penulis: book.penulis,
      kategori: book.kategori,
      stok: newStock,
      cover: book.cover,
      penerbit: '${book.penulis}',
      bahasa: '${book.bahasa}',
      deskripsi: '${book.deskripsi}',
    );

    return await updateBook(id, updated);
  }

  Future<bool> deleteBook(String id) async {
    final res = await http.delete(Uri.parse('$baseUrl/$id'));

    if (res.statusCode == 200) {
      return true;
    } else {
      print("ERROR DELETE: ${res.statusCode} | ${res.body}");
      return false;
    }
  }
}
