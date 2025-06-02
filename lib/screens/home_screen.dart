import 'package:flutter/material.dart';
import 'package:flutter_news_app/screens/bookmark_screen.dart';
import '../models/article.dart';
import '../services/news_api_service.dart';
import '../widgets/article_card.dart';

final TextEditingController _searchController = TextEditingController();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Article>> _articlesFuture;
  String? selectedCategory = 'general';
  bool isLoading = false; // New state

  final List<String> categories = [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ];

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  void _loadArticles({String? query}) {
    setState(() {
      isLoading = true; //  Show spinner immediately
      _articlesFuture = NewsApiService()
          .fetchTopHeadlines(category: selectedCategory, query: query)
          .whenComplete(() {
            if (mounted) setState(() => isLoading = false); // Hide after fetch
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search news...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            selectedCategory = null;
            _loadArticles(query: value);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BookmarksScreen()),
              );
            },
          ),
        ],
        backgroundColor: Colors.blue,
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          _loadArticles();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Chips Section
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category;

                  return ChoiceChip(
                    label: Text(
                      category[0].toUpperCase() + category.substring(1),
                    ),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        selectedCategory = category;
                        _searchController.clear(); // clear search
                        _loadArticles();
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // Display Articles
            if (isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: FutureBuilder<List<Article>>(
                  future: _articlesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No articles found."));
                    } else {
                      final articles = snapshot.data!;
                      return ListView.builder(
                        itemCount: articles.length,
                        itemBuilder:
                            (context, index) =>
                                ArticleCard(article: articles[index]),
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
