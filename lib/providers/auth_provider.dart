import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _service = AuthService();

  UserModel? _user;
  bool _loading = false;

  UserModel? get user => _user;
  bool get loading => _loading;
  bool get isAuthenticated => _user != null;

  Future<bool> login(String email, String password) async {
    _loading = true;
    notifyListeners();
    try {
      final u = await _service.login(email.trim(), password.trim());
      _loading = false;
      if (u != null) {
        _user = u;
        notifyListeners();
        return true;
      } else {
        notifyListeners();
        return false;
      }
    } catch (e) {
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
