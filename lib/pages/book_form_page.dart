import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book_model.dart';
import '../providers/book_provider.dart';

class BookFormPage extends StatefulWidget {
  final BookModel? book;
  const BookFormPage({super.key, this.book});

  @override
  State<BookFormPage> createState() => _BookFormPageState();
}

class _BookFormPageState extends State<BookFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController judulC;
  late TextEditingController penulisC;
  late TextEditingController kategoriC;
  late TextEditingController stokC;
  late TextEditingController coverC;
  late TextEditingController penerbitC;
  late TextEditingController bahasaC;
  late TextEditingController deskripsiC;

  Timer? _debounce;
  bool _saving = false;

  final List<String> categories = [
    'Novel',
    'Komik',
    'Pelajaran',
    'Biografi',
    'Teknologi',
    'Agama',
    'Anak-anak',
    'Lainnya',
  ];

  String? previewUrl;
  final String demoLocalFilePath =
      '/mnt/data/519c0273-4efa-45c1-9480-2def79bc1aba.png';

  @override
  void initState() {
    super.initState();
    judulC = TextEditingController(text: widget.book?.judul ?? '');
    penulisC = TextEditingController(text: widget.book?.penulis ?? '');
    kategoriC = TextEditingController(
      text: widget.book?.kategori ?? categories.first,
    );
    stokC = TextEditingController(
      text: widget.book != null ? widget.book!.stok.toString() : '',
    );
    coverC = TextEditingController(text: widget.book?.cover ?? '');

    previewUrl =
        (widget.book != null && (widget.book!.cover.isNotEmpty))
            ? widget.book!.cover
            : null;

    coverC.addListener(_onCoverChanged);
    penerbitC = TextEditingController(text: widget.book?.penerbit ?? '');
    bahasaC = TextEditingController(text: widget.book?.bahasa ?? '');
    deskripsiC = TextEditingController(text: widget.book?.deskripsi ?? '');
  }

  @override
  void dispose() {
    coverC.removeListener(_onCoverChanged);
    _debounce?.cancel();
    judulC.dispose();
    penulisC.dispose();
    kategoriC.dispose();
    stokC.dispose();
    coverC.dispose();
    penerbitC.dispose();
    bahasaC.dispose();
    deskripsiC.dispose();
    super.dispose();
  }

  void _onCoverChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      final raw = coverC.text.trim();
      setState(() {
        previewUrl = raw.isEmpty ? null : raw;
      });
    });
  }

  Future<void> saveBook() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _saving = true;
    });

    final newBook = BookModel(
      id: widget.book?.id,
      judul: judulC.text.trim(),
      penulis: penulisC.text.trim(),
      kategori: kategoriC.text.trim(),
      stok: int.tryParse(stokC.text.trim()) ?? 0,
      cover: coverC.text.trim(),
      penerbit: penerbitC.text.trim(),
      bahasa: bahasaC.text.trim(),
      deskripsi: deskripsiC.text.trim(),
    );

    final provider = Provider.of<BookProvider>(context, listen: false);
    bool result = false;

    try {
      if (widget.book == null) {
        result = await provider.addBook(newBook);
      } else {
        result = await provider.updateBook(newBook);
      }
    } catch (e) {
      result = false;
    } finally {
      if (!mounted) return;
      setState(() {
        _saving = false;
      });
    }

    if (result) {
      Navigator.pop(context, widget.book == null ? 'added' : 'updated');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Gagal menyimpan data. Periksa koneksi atau format input.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildPreview() {
    final url = previewUrl;

    if (url == null || url.isEmpty) {
      return Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(Icons.image, size: 56, color: Colors.grey),
        ),
      );
    }

    final low = url.toLowerCase();
    if (!(low.startsWith('http://') || low.startsWith('https://'))) {
      return Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(
            Icons.image_not_supported_rounded,
            size: 56,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 180,
            color: Colors.grey.shade100,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 180,
            color: Colors.grey.shade300,
            child: const Center(
              child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.book != null;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(isEdit ? 'Edit Buku' : 'Tambah Buku'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  _buildPreview(),
                  const SizedBox(height: 14),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: judulC,
                          decoration: InputDecoration(
                            labelText: 'Judul Buku',
                            prefixIcon: const Icon(Icons.book),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          validator:
                              (v) =>
                                  v == null || v.trim().isEmpty
                                      ? 'Judul wajib diisi'
                                      : null,
                        ),
                        const SizedBox(height: 12),

                        TextFormField(
                          controller: penulisC,
                          decoration: InputDecoration(
                            labelText: 'Penulis',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          validator:
                              (v) =>
                                  v == null || v.trim().isEmpty
                                      ? 'Penulis wajib diisi'
                                      : null,
                        ),
                        const SizedBox(height: 12),

                        DropdownButtonFormField<String>(
                          value:
                              categories.contains(kategoriC.text)
                                  ? kategoriC.text
                                  : categories.first,
                          decoration: InputDecoration(
                            labelText: 'Kategori',
                            prefixIcon: const Icon(Icons.category),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          items:
                              categories
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(c),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              kategoriC.text = v;
                              setState(() {});
                            }
                          },
                        ),
                        const SizedBox(height: 12),

                        TextFormField(
                          controller: stokC,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Stok',
                            prefixIcon: const Icon(Icons.storage),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty)
                              return 'Stok wajib diisi';
                            final n = int.tryParse(v.trim());
                            if (n == null) return 'Stok harus berupa angka';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        TextFormField(
                          controller: penerbitC,
                          decoration: InputDecoration(
                            labelText: 'Penerbit',
                            prefixIcon: const Icon(Icons.business),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          validator:
                              (v) =>
                                  v == null || v.trim().isEmpty
                                      ? 'Penerbit wajib diisi'
                                      : null,
                        ),
                        const SizedBox(height: 12),

                        TextFormField(
                          controller: bahasaC,
                          decoration: InputDecoration(
                            labelText: 'Bahasa',
                            prefixIcon: const Icon(Icons.language),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          validator:
                              (v) =>
                                  v == null || v.trim().isEmpty
                                      ? 'Bahasa wajib diisi'
                                      : null,
                        ),
                        const SizedBox(height: 12),

                        TextFormField(
                          controller: deskripsiC,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: 'Deskripsi',
                            alignLabelWithHint: true,
                            prefixIcon: const Icon(Icons.description),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          validator:
                              (v) =>
                                  v == null || v.trim().isEmpty
                                      ? 'Deskripsi wajib diisi'
                                      : null,
                        ),
                        const SizedBox(height: 12),

                        TextFormField(
                          controller: coverC,
                          keyboardType: TextInputType.url,
                          decoration: InputDecoration(
                            labelText: 'URL Cover Buku (gambar)',
                            prefixIcon: const Icon(Icons.link),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.remove_red_eye),
                              onPressed: () {
                                final raw = coverC.text.trim();
                                setState(
                                  () => previewUrl = raw.isEmpty ? null : raw,
                                );
                                FocusScope.of(context).unfocus();
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          validator:
                              (v) =>
                                  v == null || v.trim().isEmpty
                                      ? 'Cover wajib diisi'
                                      : null,
                        ),
                        const SizedBox(height: 18),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _saving ? null : saveBook,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child:
                                _saving
                                    ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                    : Text(
                                      isEdit
                                          ? 'Simpan Perubahan'
                                          : 'Tambahkan Buku',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                          ),
                        ),

                        if (kIsWeb)
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                              'Tip: Klik ikon mata pada kolom URL untuk melihat pratinjau gambar.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
