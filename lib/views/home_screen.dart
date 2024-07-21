import 'package:ebook/views/add_book_Screen.dart';
import 'package:ebook/views/book_list_screen.dart';
import 'package:ebook/views/borrowed_books_screen.dart';
import 'package:ebook/component/build_grid_home_item.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Borrowing App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to the Book Borrowing App!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  GridItemHome(
                    icon: Icons.book,
                    title: 'View Books',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BookListScreen()),
                      );
                    },
                  ),
                  GridItemHome(
                    icon: Icons.add,
                    title: 'Add Book',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddBookScreen()),
                      );
                    },
                  ),
                  GridItemHome(
                    icon: Icons.person,
                    title: 'My Books',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BorrowedBooksScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
