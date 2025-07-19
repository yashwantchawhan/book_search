import 'package:design_system/book_card_shimmer.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  List<Map<String, String>> books = [];

  void _onSearchQueryChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        books = [];
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      books = [];
    });

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
      appBar: AppBar(
        title: const Text("Search Books"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onChanged: _onSearchQueryChanged,
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 8),
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
          ),
        ],
      ),
    );
  }
}
