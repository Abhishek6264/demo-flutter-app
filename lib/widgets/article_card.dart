import 'package:flutter/material.dart';
import 'package:flutter_news_app/screens/article_detail_screen.dart';
import '../models/article.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (article.urlToImage.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                article.urlToImage,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          GestureDetector(
            onTap: () {
              // Navigate to article detail screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleDetailScreen(article: article),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    article.author,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    article.publishedAt.substring(0, 10),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
