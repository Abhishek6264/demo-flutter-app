import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/article.dart';
import 'package:flutter_news_app/screens/webview_screen.dart';
import 'package:flutter_news_app/services/bookmark_service.dart';
import 'package:intl/intl.dart';

final dateFormatter = DateFormat.yMMMd();

class ArticleDetailScreen extends StatefulWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});
  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkIfBookmarked();
  }

  void _checkIfBookmarked() async {
    final result = await BookmarkService().isBookmarked(widget.article);
    setState(() {
      isBookmarked = result;
    });
  }

  void _toggleBookmark() async {
    await BookmarkService().toggleBookmark(widget.article);
    final updatedStatus = await BookmarkService().isBookmarked(widget.article);
    setState(() {
      isBookmarked = updatedStatus;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isBookmarked ? 'Bookmarked' : 'Removed from bookmarks'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.article.title),
        actions: [
          IconButton(
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.article.urlToImage.isNotEmpty)
                Image.network(widget.article.urlToImage),
              const SizedBox(height: 16),
              Text(
                widget.article.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                "By ${widget.article.author}",
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                dateFormatter.format(
                  DateTime.parse(widget.article.publishedAt),
                ),

                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Text(
                widget.article.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WebViewScreen(url: widget.article.url),
                    ),
                  );
                },
                child: const Text('Read Full Article'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
