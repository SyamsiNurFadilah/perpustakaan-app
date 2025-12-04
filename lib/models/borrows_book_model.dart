class BorrowModel {
  final String? id;
  final String userId;
  final String bookId;
  final String title;
  final String cover;
  final String borrowedAt;
  final String? returnedAt;
  final String status; // "borrowed" or "returned"

  BorrowModel({
    this.id,
    required this.userId,
    required this.bookId,
    required this.title,
    required this.cover,
    required this.borrowedAt,
    this.returnedAt,
    required this.status,
  });

  factory BorrowModel.fromJson(Map<String, dynamic> json) {
    return BorrowModel(
      id: json['id']?.toString(),
      userId: json['userId']?.toString() ?? '',
      bookId: json['bookId']?.toString() ?? '',
      title: json['title'] ?? '',
      cover: json['cover'] ?? '',
      borrowedAt: json['borrowedAt'] ?? '',
      returnedAt: json['returnedAt'],
      status: json['status'] ?? 'borrowed',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "bookId": bookId,
      "title": title,
      "cover": cover,
      "borrowedAt": borrowedAt,
      "returnedAt": returnedAt,
      "status": status,
    };
  }
}
