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

  Future<bool> updateBook(BookModel oldBook, BookModel newBook) async {
    final res = await http.put(
      Uri.parse('$baseUrl/${oldBook.id}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(newBook.toJson()),
    );

    if (res.statusCode == 200) {
      return true;
    } else {
      print("ERROR UPDATE: ${res.statusCode} | ${res.body}");
      return false;
    }
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
