import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/borrows_book_provider.dart';
import '../providers/auth_provider.dart';
import '../models/borrows_book_model.dart';
import 'borrow_detail_page.dart';
import 'user_dashboard_page.dart';
import 'profile_page.dart';

class MyBooksPage extends StatefulWidget {
  const MyBooksPage({super.key});

  @override
  State<MyBooksPage> createState() => _MyBooksPageState();
}

class _MyBooksPageState extends State<MyBooksPage> {
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final userId = auth.user?.id?.toString() ?? '1';
      Provider.of<BorrowProvider>(
        context,
        listen: false,
      ).fetchMyBorrows(userId);
    });
  }

  void _onNavTapped(int index) {
    if (index == _selectedIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserDashboardPage()),
        );
        break;

      case 1:
        break;

      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final borrowProv = Provider.of<BorrowProvider>(context);
    final items = borrowProv.myBorrows;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Buku Saya",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body:
          items.isEmpty
              ? const Center(
                child: Text(
                  "Belum ada buku yang dipinjam",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (ctx, i) {
                  final BorrowModel b = items[i];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BorrowDetailPage(borrow: b),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            ),
                            child:
                                b.cover.isNotEmpty
                                    ? Image.network(
                                      b.cover,
                                      width: 100,
                                      height: 130,
                                      fit: BoxFit.cover,
                                    )
                                    : Container(
                                      width: 100,
                                      height: 130,
                                      color: Colors.grey.shade200,
                                      child: const Icon(Icons.book, size: 40),
                                    ),
                          ),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    b.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Dipinjam: ${b.borrowedAt.split("T")[0]}",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  Row(
                                    children: [
                                      Icon(
                                        b.status == "borrowed"
                                            ? Icons.bookmark
                                            : Icons.check_circle,
                                        size: 18,
                                        color:
                                            b.status == "borrowed"
                                                ? Colors.blue
                                                : Colors.green,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        b.status == "borrowed"
                                            ? "Sedang Dipinjam"
                                            : "Dikembalikan",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              b.status == "borrowed"
                                                  ? Colors.blue
                                                  : Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.indigo,
      //   unselectedItemColor: Colors.grey,
      //   onTap: _onNavTapped,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
      //     BottomNavigationBarItem(icon: Icon(Icons.book), label: "Buku Saya"),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: "Akun"),
      //   ],
      // ),
    );
  }
}
