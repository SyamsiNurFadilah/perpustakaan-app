class UserModel {
  String id;
  String nama;
  String email;
  String password;
  String role;

  UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.password,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'].toString(),
    nama: json['nama'] ?? '',
    email: json['email'] ?? '',
    password: json['password'] ?? '',
    role: json['role'] ?? 'user',
  );

  Map<String, dynamic> toJson() => {
    'nama': nama,
    'email': email,
    'password': password,
    'role': role,
  };
}
