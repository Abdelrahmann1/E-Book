import 'dart:io';

import 'package:ebook/models/book_model.dart';
import 'package:ebook/book_repo/book_repository.dart';
import 'package:ebook/models/borrowing_model.dart';
import 'package:flutter/material.dart';

class BorrowedBooksScreen extends StatefulWidget {
  const BorrowedBooksScreen({super.key});

  @override
  _BorrowedBooksScreenState createState() => _BorrowedBooksScreenState();
}

class _BorrowedBooksScreenState extends State<BorrowedBooksScreen> {
  final BookRepository _bookRepository = BookRepository();
  late Future<List<BorrowingModel>> _borrowedBooks;

  @override
  void initState() {
    super.initState();
    _borrowedBooks = _fetchBorrowedBooks();
  }

  Future<List<BorrowingModel>> _fetchBorrowedBooks() async {
    const userId = 1;
    return await _bookRepository.getBorrowingsByUser(userId);
  }

  Future<Book> _getBookById(int bookId) async {
    return await _bookRepository.getBookById(bookId);
  }

  Future<void> _returnBook(int bookId, int numberOfCopies) async {
    try {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Return Book'),
          content: const Text(
              'You are about to return copy(s) of this book. Are you sure?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); 
                try {
                  await _bookRepository.returnBook(
                      bookId, 1); 
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Book returned successfully!')),
                  );
                  setState(() {
                    _borrowedBooks =
                        _fetchBorrowedBooks(); 
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Failed to return book: ${e.toString()}')),
                  );
                }
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('No'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to return book: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Borrowed Books'),
      ),
      body: FutureBuilder<List<BorrowingModel>>(
        future: _borrowedBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No borrowed books'));
          } else {
            final borrowings = snapshot.data!;
            return FutureBuilder<List<Book>>(
              future: Future.wait(
                borrowings.map((borrowing) => _getBookById(borrowing.bookId)),
              ),
              builder: (context, bookSnapshot) {
                if (bookSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (bookSnapshot.hasError) {
                  return Center(child: Text('Error: ${bookSnapshot.error}'));
                } else if (!bookSnapshot.hasData ||
                    bookSnapshot.data!.isEmpty) {
                  return const Center(child: Text('No books found'));
                } else {
                  final books = bookSnapshot.data!;
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
                                borderRadius: BorderRadius.circular(
                                    8.0), 
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
                            const SizedBox(
                                width: 16.0), 
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    '${book.subtitle}\nAuthor: ${book.author}\nLanguage: ${book.programmingLanguage}',
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                  ElevatedButton(
                                    onPressed: book.copies > 0
                                        ? () =>
                                            _returnBook(book.id!, book.copies)
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: book.copies > 0
                                          ? Colors.greenAccent
                                          : Colors.redAccent,
                                      textStyle: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    child: Text(
                                      book.copies > 0
                                          ? 'Return The Book'
                                          : 'Not Available',
                                      style:
                                          const TextStyle(color: Colors.white),
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
            );
          }
        },
      ),
    );
  }
}
