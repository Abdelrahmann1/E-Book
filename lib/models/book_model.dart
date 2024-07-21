class Book {
  int? id;
  String title;
  String subtitle;
  String author;
  String programmingLanguage;
  String? imagePath;
  int copies;
  int borrowingCopies;

  Book({
    this.borrowingCopies = 0,
    this.id,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.programmingLanguage,
    this.imagePath,
    required this.copies,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'author': author,
      'programming_language': programmingLanguage,
      'image_path': imagePath,
      'copies': copies,
    };
  }
}
