import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/borrows_book_model.dart';
import '../providers/borrows_book_provider.dart';
import '../providers/auth_provider.dart';

class BorrowDetailPage extends StatelessWidget {
  final BorrowModel borrow;

  const BorrowDetailPage({super.key, required this.borrow});

  @override
  Widget build(BuildContext context) {
    final borrowProv = Provider.of<BorrowProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userId = auth.user?.id?.toString() ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pinjaman')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // cover (jika ada)
            if (borrow.cover.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  borrow.cover,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              borrow.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Dipinjam pada: ${borrow.borrowedAt}'),
            const SizedBox(height: 20),
            if (borrow.status == 'borrowed')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text('Kembalikan Buku'),
                  onPressed: () async {
                    final ok = await borrowProv.returnBook(
                      borrowId: borrow.id!,
                      userId: userId,
                      bookId: borrow.bookId,
                    );

                    if (ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Buku berhasil dikembalikan'),
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Gagal kembalikan buku')),
                      );
                    }
                  },
                ),
              )
            else
              Text('Status: ${borrow.status}'),
          ],
        ),
      ),
    );
  }
}
