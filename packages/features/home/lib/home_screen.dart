import 'package:design_system/book_card_shimmer.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
// assuming you already have these:

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  List<Map<String, String>> books = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() {
    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
        books = [
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
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Search")),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: isLoading ? 6 : books.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          if (isLoading) {
            return const BookCardShimmer();
          } else {
            final book = books[index];
            return BookCard(
              thumbnailUrl: book['thumbnail'] ?? "",
              title: book['title']!,
              author: book['author']!,
              onTap: () {
                Navigator.of(context).pushNamed('/details');
              },
            );
          }
        },
      ),
    );
  }
}

