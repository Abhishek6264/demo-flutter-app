import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/bookmark_service.dart';
import 'article_detail_screen.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  bool isLoading = false; // Added isLoading state
  List<Article> bookmarks = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  void _loadBookmarks() async {
    setState(() {
      isLoading = true; // Start loading
    });

    bookmarks = await BookmarkService().getBookmarks();

    setState(() {
      isLoading = false; // Stop loading
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarked Articles')),
      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(),
              ) // Showing loader while loading
              : bookmarks.isEmpty
              ? Center(child: Text('No bookmarks yet.'))
              : ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: bookmarks.length,
                itemBuilder: (context, index) {
                  final article = bookmarks[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: ListTile(
                      title: Text(article.title),
                      subtitle: Text(article.author),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    ArticleDetailScreen(article: article),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
