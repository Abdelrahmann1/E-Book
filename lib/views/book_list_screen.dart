import 'package:ebook/models/book_model.dart';
import 'package:ebook/book_repo/book_repository.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final BookRepository _bookRepository = BookRepository();
  late Future<List<Book>> _books;

  @override
  void initState() {
    super.initState();
    _books = _bookRepository.getAllBooks();
  }

  Future<void> _borrowBook(Book book) async {
    try {
      if (book.copies > 0) {
        await _bookRepository.borrowBook(book.id!, 1);
        setState(() {
          _books = _bookRepository.getAllBooks();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${book.title} borrowed successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${book.title} is not available right now.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to borrow book: ${e.toString()}')),
      );
    }
  }

  Future<void> _confirmBorrowBook(Book book) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Borrowing'),
          content: Text(
              'Do you want to borrow "${book.title}"? This will reduce the available copies.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); 
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); 
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      _borrowBook(book);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book List'),
      ),
      body: FutureBuilder<List<Book>>(
        future: _books,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No books available'));
          } else {
            final books = snapshot.data!;
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Container(
                  padding: const EdgeInsets.all(8.0), 
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100, 
                        height: 170, 
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(8.0), 
                          child: book.imagePath != null &&
                                  book.imagePath!.startsWith('assets/')
                              ? Image.asset(
                                  book.imagePath!,
                                  fit: BoxFit.fill,
                                )
                              : book.imagePath != null
                                  ? Image.file(
                                      File(book.imagePath!),
                                      fit: BoxFit.fill,
                                    )
                                  : Image.asset(
                                      'assets/images/codepen.jpg',
                                      fit: BoxFit.fill,
                                    ),
                        ),
                      ),
                      const SizedBox(width: 16.0), 
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              '${book.subtitle}\nAuthor: ${book.author}\nLanguage: ${book.programmingLanguage}',
                              style: const TextStyle(fontSize: 14.0),
                            ),
                            book.copies > 0
                                ? Text(
                                    'Copies: ${book.copies}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    'Copies: ${book.copies}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                            book.copies > 0
                                ? ElevatedButton(
                                    onPressed: () => _confirmBorrowBook(book),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.greenAccent,
                                        textStyle: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    child: const Text(
                                      'Borrow Now',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                '${book.title} Not Available Right Now!')),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        textStyle: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    child: const Text(
                                      'Not Available',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
