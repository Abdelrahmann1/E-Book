class BorrowingModel {
  int? id;
  int bookId;
  int userId;
  String borrowedAt;

  BorrowingModel({this.id, required this.bookId, required this.userId, required this.borrowedAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'book_id': bookId,
      'user_id': userId,
      'borrowed_at': borrowedAt,
    };
  }
}
