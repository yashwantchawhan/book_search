import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final books = [
      {
        'thumbnail': 'https://covers.openlibrary.org/b/id/8226191-L.jpg',
        'title': 'The Great Gatsby',
        'author': 'F. Scott Fitzgerald',
      },
      {
        'thumbnail': 'https://covers.openlibrary.org/b/id/8369251-L.jpg',
        'title': 'The Guest List',
        'author': 'Lucy Foley',
      },
      {
        'thumbnail': 'https://covers.openlibrary.org/b/id/10515569-L.jpg',
        'title': 'Project Hail Mary',
        'author': 'Andy Weir',
      },
      {
        'thumbnail': 'https://covers.openlibrary.org/b/id/8235116-L.jpg',
        'title': 'The Silent Patient',
        'author': 'Alex Michaelides',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Book Search")),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.58, // adjusted for enough height
          ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return BookCard(
              thumbnailUrl: book['thumbnail'],
              title: book['title']!,
              author: book['author']!,
              onTap: () {
                Navigator.of(context).pushNamed('/details');
              },
            );
          },
        ),
      ),
    );
  }
}
