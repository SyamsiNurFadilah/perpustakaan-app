import 'package:flutter/material.dart';
import 'user_dashboard_page.dart';
import 'my_book_page.dart';
import 'profile_page.dart';

class UserMainNavigation extends StatefulWidget {
  const UserMainNavigation({super.key});

  @override
  State<UserMainNavigation> createState() => _UserMainNavigationState();
}

class _UserMainNavigationState extends State<UserMainNavigation> {
  int _index = 0;

  final pages = const [UserDashboardPage(), MyBooksPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Buku Saya"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Akun"),
        ],
      ),
    );
  }
}
