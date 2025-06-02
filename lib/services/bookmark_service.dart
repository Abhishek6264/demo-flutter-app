import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart'; // Import for firstWhereOrNull
import '../models/article.dart';

class BookmarkService {
  static const _key = 'bookmarked_articles';

  Future<void> saveBookmarks(List<Article> articles) async {
    final preferences = await SharedPreferences.getInstance();
    final jsonList = articles.map((a) => json.encode(a.toJson())).toList();
    await preferences.setStringList(_key, jsonList);
  }

  Future<List<Article>> getBookmarks() async {
    final preferences = await SharedPreferences.getInstance();
    final jsonList = preferences.getStringList(_key) ?? [];
    return jsonList.map((j) => Article.fromJson(json.decode(j))).toList();
  }

  Future<bool> isBookmarked(Article article) async {
    final bookmarks = await getBookmarks();
    return bookmarks.firstWhereOrNull((a) => a.url == article.url) != null;
  }

  Future<void> toggleBookmark(Article article) async {
    final bookmarks = await getBookmarks();
    final existingArticle = bookmarks.firstWhereOrNull(
      (a) => a.url == article.url,
    );

    if (existingArticle != null) {
      bookmarks.remove(existingArticle);
    } else {
      bookmarks.add(article);
    }

    await saveBookmarks(bookmarks);
  }
}
