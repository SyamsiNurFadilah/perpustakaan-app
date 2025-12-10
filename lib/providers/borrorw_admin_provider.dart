import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BorrowAdminProvider with ChangeNotifier {
  final String borrowUrl = "https://69315d8511a8738467ce7408.mockapi.io/";
  final String userUrl = "https://691ee2fbbb52a1db22bf8e41.mockapi.io/";

  List<dynamic> allBorrows = [];
  List<dynamic> allUsers = [];

  bool loading = false;

  Future<void> fetchBorrowData() async {
    loading = true;
    notifyListeners();

    try {
      final b = await http.get(Uri.parse("${borrowUrl}borrows"));
      final u = await http.get(Uri.parse("${userUrl}users"));

      allBorrows = jsonDecode(b.body);
      allUsers = jsonDecode(u.body);

      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      notifyListeners();
    }
  }

  String getUserName(String id) {
    final user = allUsers.firstWhere(
      (u) => u['id'].toString() == id,
      orElse: () => null,
    );
    return user == null ? "Unknown User" : user["nama"];
  }
}
