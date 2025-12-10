import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/borrorw_admin_provider.dart';

class BorrowStatusPage extends StatefulWidget {
  const BorrowStatusPage({super.key});

  @override
  State<BorrowStatusPage> createState() => _BorrowStatusPageState();
}

class _BorrowStatusPageState extends State<BorrowStatusPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<BorrowAdminProvider>(
        context,
        listen: false,
      ).fetchBorrowData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<BorrowAdminProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Status Peminjaman",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body:
          prov.loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: prov.allBorrows.length,
                itemBuilder: (context, index) {
                  final item = prov.allBorrows[index];

                  final username = prov.getUserName(item["userId"]);
                  final judul = item["title"];
                  final status = item["status"];

                  return Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Buku: $judul",
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              status == "borrowed"
                                  ? Icons.bookmark
                                  : Icons.check_circle,
                              color:
                                  status == "borrowed"
                                      ? Colors.blue
                                      : Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              status == "borrowed"
                                  ? "Sedang Dipinjam"
                                  : "Dikembalikan",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    status == "borrowed"
                                        ? Colors.blue
                                        : Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
