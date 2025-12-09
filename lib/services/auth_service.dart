import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/user_model.dart';

class AuthService {
  final String base = ApiConfig.baseUrlA;

  Future<UserModel?> login(String email, String password) async {
    final uri = Uri.parse('$base/users?email=$email&password=$password');
    final res = await http.get(uri);

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      if (data.isNotEmpty) return UserModel.fromJson(data[0]);
      return null;
    } else {
      throw Exception('Gagal terhubung ke server (status: ${res.statusCode})');
    }
  }

  Future<bool> register({
    required String nama,
    required String email,
    required String password,
    required String role,
  }) async {
    final url = Uri.parse('$base/users?email=$email&password=$password');

    final res = await http.post(
      url,
      body: {"nama": nama, "email": email, "password": password, "role": role},
    );

    return res.statusCode == 201;
  }
}
