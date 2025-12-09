import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f3ff),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              "Daftar Akun",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Buat akun baru untuk melanjutkan",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 40),

            // ============ INPUT NAMA =================
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person),
                labelText: "Nama",
                border: const UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // ============ INPUT EMAIL =================
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: "Email",
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // ============ INPUT PASSWORD =================
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: "Password",
                border: UnderlineInputBorder(),
              ),
            ),

            const SizedBox(height: 40),

            // ============ BUTTON REGISTER ===============
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _isLoading
                        ? null
                        : () async {
                          setState(() => _isLoading = true);

                          final auth = Provider.of<AuthProvider>(
                            context,
                            listen: false,
                          );

                          final success = await auth.register(
                            nama: _namaController.text.trim(),
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                            role: "user", // default role user
                          );

                          setState(() => _isLoading = false);

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Registrasi berhasil!"),
                              ),
                            );

                            Navigator.pop(context); // kembali ke login
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Registrasi gagal!"),
                              ),
                            );
                          }
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          "Daftar",
                          style: TextStyle(color: Colors.white),
                        ),
              ),
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text(
                "Sudah punya akun? Login",
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
