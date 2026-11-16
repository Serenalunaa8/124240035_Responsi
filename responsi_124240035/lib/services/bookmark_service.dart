import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article.dart';

class BookmarkService {
  static const String _bookmarkKey = 'bookmark_articles';

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loginData') ?? false;
  }

  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    return prefs.getString('session_username') ?? prefs.getString('username') ?? 'User';
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loginData', false);
    await prefs.remove('session_username');
  }

  static Future<List<Articles>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> rawList = prefs.getStringList(_bookmarkKey) ?? [];
    return rawList.map((item) {
      final Map<String, dynamic> map = jsonDecode(item);
      return Articles.fromMap(map);
    }).toList();
  }

  static Future<bool> isBookmark(int id) async {
    final bookmarks = await getBookmarks();
    return bookmarks.any((item) => item.id == id);
  }

  static Future<bool> toggleBookmark(Articles article) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarks();
    final index = bookmarks.indexWhere((item) => item.id == article.id);

    bool isAdded;
    if (index >= 0) {
      bookmarks.removeAt(index);
      isAdded = false;
    } else {
      bookmarks.add(article);
      isAdded = true;
    }

    final List<String> encodedList = bookmarks
        .map((item) => jsonEncode(item.toMap()))
        .toList();
    await prefs.setStringList(_bookmarkKey, encodedList);

    return isAdded;
  }

  static Future<void> removeBookmark(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarks();
    bookmarks.removeWhere((item) => item.id == id);

    final List<String> encodedList = bookmarks
        .map((item) => jsonEncode(item.toMap()))
        .toList();
    await prefs.setStringList(_bookmarkKey, encodedList);
  }
}
