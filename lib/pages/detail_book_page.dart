import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/borrows_book_provider.dart';
import '../models/book_model.dart';

class DetailBookPage extends StatelessWidget {
  final BookModel book;

  const DetailBookPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    // ➜ tambahkan ini
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(book.judul), elevation: 0),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                book.cover,
                height: 260,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),
            Text(
              book.judul,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Text(
              "Penulis: ${book.penulis}",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),

            Text(
              "Kategori: ${book.kategori}",
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),

            Text(
              "Penerbit: ${book.penerbit}",
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),

            Text(
              "Bahasa: ${book.bahasa}",
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Stok tersedia: ${book.stok}",
                style: const TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Deskripsi Buku",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            Text(
              book.deskripsi,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Colors.grey[800],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Pinjam Buku",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),

          onPressed: () async {
            final borrowProv = Provider.of<BorrowProvider>(
              context,
              listen: false,
            );

            final userId = auth.user?.id.toString();
            if (userId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User tidak ditemukan")),
              );
              return;
            }

            final ok = await borrowProv.borrowBook(userId: userId, book: book);

            if (ok) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Buku berhasil dipinjam")),
              );
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Gagal meminjam buku, stok habis / error"),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
