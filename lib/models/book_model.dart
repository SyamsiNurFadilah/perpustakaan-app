class BookModel {
  final String? id;
  final String judul;
  final String penulis;
  final String kategori;
  final int stok;
  final String cover;
  final String penerbit;
  final String bahasa;
  final String deskripsi;

  BookModel({
    this.id,
    required this.judul,
    required this.penulis,
    required this.kategori,
    required this.stok,
    required this.cover,
    required this.penerbit,
    required this.bahasa,
    required this.deskripsi,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      judul: (json['judul'] ?? '').toString(),
      penulis: (json['penulis'] ?? '').toString(),
      kategori: (json['kategori'] ?? '').toString(),
      stok: int.tryParse(json['stok']?.toString() ?? '0') ?? 0,
      cover: (json['cover'] ?? '').toString(),
      penerbit: (json['penerbit'] ?? '').toString(),
      bahasa: (json['bahasa'] ?? '').toString(),
      deskripsi: (json['deskripsi'] ?? '').toString(),
    );
  }

  get image => null;

  get title => null;

  Map<String, dynamic> toJson() {
    return {
      "judul": judul,
      "penulis": penulis,
      "kategori": kategori,
      "stok": stok,
      "cover": cover,
      "penerbit": penerbit,
      "bahasa": bahasa,
      "deskripsi": deskripsi,
    };
  }

  copyWith({required int stok}) {}
}
