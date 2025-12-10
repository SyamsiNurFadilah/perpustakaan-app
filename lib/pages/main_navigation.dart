import 'package:flutter/material.dart';
import 'package:perpustakaan_app/pages/profile_page.dart';
import 'package:perpustakaan_app/pages/borrow_status_page.dart';
import 'home_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = const [
      HomePage(user: false),
      BorrowStatusPage(),
      ProfilePage(),
    ];

    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          setState(() => index = i);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: "Daftar Buku",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "Status Peminjaman",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}
