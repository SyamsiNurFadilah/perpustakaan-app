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
    final borrowDate = DateTime.tryParse(borrow.borrowedAt);
    final formattedBorrowDate =
        borrowDate != null
            ? "${borrowDate.year}-${borrowDate.month}-${borrowDate.day}"
            : borrow.borrowedAt;

    int? daysLeft;
    if (borrow.status == "borrowed" && borrowDate != null) {
      final now = DateTime.now();
      const maxDays = 15;
      final used = now.difference(borrowDate).inDays;
      daysLeft = maxDays - used;
      if (daysLeft < 0) daysLeft = 0;
    }

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        title: const Text(
          "Detail Peminjaman",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child:
                    borrow.cover.isNotEmpty
                        ? Image.network(
                          borrow.cover,
                          height: 260,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                        : Container(
                          height: 260,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.book, size: 80),
                        ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              borrow.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (borrow.status == "borrowed")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "DIPINJAM PADA",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedBorrowDate,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),

                  Text(
                    "STATUS PEMINJAMAN",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),

                  Row(
                    children: [
                      Icon(
                        borrow.status == "borrowed"
                            ? Icons.access_time
                            : Icons.check_circle,
                        color:
                            borrow.status == "borrowed"
                                ? Colors.orange
                                : Colors.green,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        borrow.status == "borrowed"
                            ? "Sedang Dipinjam"
                            : "Dikembalikan",
                        style: TextStyle(
                          color:
                              borrow.status == "borrowed"
                                  ? Colors.orange
                                  : Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  if (borrow.status == "borrowed" && daysLeft != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "WAKTU TERSISA",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$daysLeft hari tersisa dari 15 hari",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            if (borrow.status == "borrowed")
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.indigo,
                  ),
                  icon: const Icon(Icons.menu_book, color: Colors.white),
                  label: const Text(
                    "Baca Buku",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    // navigasi ke halaman baca
                  },
                ),
              ),

            const SizedBox(height: 12),

            if (borrow.status == 'borrowed')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.redAccent,
                  ),
                  icon: const Icon(
                    Icons.assignment_return,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Kembalikan Buku",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    final ok = await borrowProv.returnBook(
                      borrowId: borrow.id!,
                      userId: userId,
                      bookId: borrow.bookId,
                    );

                    if (ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Buku berhasil dikembalikan"),
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Gagal mengembalikan buku"),
                        ),
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
