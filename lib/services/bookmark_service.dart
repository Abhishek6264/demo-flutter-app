import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
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
    return bookmarks.any((a) => a.url == article.url);
  }

  Future<void> toggleBookmark(Article article) async {
    final bookmarks = await getBookmarks();
    final exists = bookmarks.any((a) => a.url == article.url);

    if (exists) {
      final updated = bookmarks.where((a) => a.url != article.url).toList();
      await saveBookmarks(updated);
    } else {
      await saveBookmarks([...bookmarks, article]);
    }
  }
}
