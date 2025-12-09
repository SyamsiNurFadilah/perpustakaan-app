import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/borrows_book_model.dart';

class BorrowService {
  static const String BORROWS_BASE_URL =
      'https://69315d8511a8738467ce7408.mockapi.io/borrows';

  Future<List<BorrowModel>> getBorrows() async {
    final res = await http.get(Uri.parse(BORROWS_BASE_URL));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => BorrowModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<bool> createBorrow(BorrowModel b) async {
    final res = await http.post(
      Uri.parse(BORROWS_BASE_URL),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(b.toJson()),
    );
    return res.statusCode == 201;
  }

  Future<bool> updateBorrow(String id, Map<String, dynamic> patch) async {
    final res = await http.put(
      Uri.parse('$BORROWS_BASE_URL/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(patch),
    );
    return res.statusCode == 200;
  }

  Future<List<BorrowModel>> getBorrowsByUser(String userId) async {
    final res = await http.get(Uri.parse('$BORROWS_BASE_URL?userId=$userId'));
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List)
          .map((e) => BorrowModel.fromJson(e))
          .toList();
    }
    return [];
  }
}
