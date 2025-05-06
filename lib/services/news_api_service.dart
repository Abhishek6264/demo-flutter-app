import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsApiService {
  static const String _apiKey = 'a111db6b7d9446cfbb899e612b39c267';
  static const String _baseUrl = 'https://newsapi.org/v2';

  Future<List<Article>> fetchTopHeadlines({
    String? category,
    String? query,
  }) async {
    var url = Uri.parse(
      "$_baseUrl/top-headlines?country=us&category=general&apiKey=$_apiKey",
    );

    if (query != null && query.isNotEmpty) {
      url = Uri.parse(
        'https://newsapi.org/v2/everything?q=$query&apiKey=$_apiKey',
      );
    } else {
      url = Uri.parse(
        '$_baseUrl/top-headlines?country=us&category=${category ?? 'general'}&apiKey=$_apiKey',
      );
    }

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final articles = jsonData['articles'] as List;
      return articles.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load news");
    }
  }
}
