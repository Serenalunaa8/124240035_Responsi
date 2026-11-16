import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article.dart';

// Layanan untuk mengelola data favorit dan sesi user di SharedPreferences
class FavoriteService {
  static const String _keyFavorites = 'favorite_articles';
  static const String _keyIsLoggedIn = 'loginData';
  static const String _keySessionUsername = 'session_username';
  static const String _keySessionEmail = 'session_email';

  // Cek apakah user sedang login
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Ambil username yang sedang aktif
  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    return prefs.getString(_keySessionUsername) ?? prefs.getString('username') ?? '';
  }

  // Ambil email user yang sedang aktif
  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    return prefs.getString(_keySessionEmail) ?? prefs.getString('email') ?? '';
  }

  // Simpan sesi login baru
  static Future<void> saveLoginSession(String username, [String email = '']) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keySessionUsername, username);
    await prefs.setString('username', username);
    if (email.isNotEmpty) {
      await prefs.setString(_keySessionEmail, email);
    }
  }

  // Hapus status sesi login saat logout
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
    await prefs.remove(_keySessionUsername);
    await prefs.remove(_keySessionEmail);
  }

  static Future<void> logout() async {
    await clearSession();
  }

  // Ambil seluruh daftar karakter favorit
  static Future<List<Articles>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final List<String>? favStrings = prefs.getStringList(_keyFavorites);
    if (favStrings == null || favStrings.isEmpty) {
      return [];
    }
    return favStrings.map((item) {
      final Map<String, dynamic> map = jsonDecode(item);
      return Articles.fromMap(map);
    }).toList();
  }

  // Cek apakah suatu karakter sudah ada di favorit
  static Future<bool> isFavorite(int id) async {
    final favorites = await getFavorites();
    return favorites.any((c) => c.id == id);
  }

  // Tambah atau hapus karakter dari favorit (toggle)
  static Future<bool> toggleFavorite(Articles article) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final favorites = await getFavorites();
    final index = favorites.indexWhere((c) => c.id == article.id);

    if (index >= 0) {
      favorites.removeAt(index);
    } else {
      favorites.add(article);
    }

    final List<String> favStrings = favorites
        .map((c) => jsonEncode(c.toMap()))
        .toList();
    await prefs.setStringList(_keyFavorites, favStrings);

    return index < 0;
  }

  // Hapus karakter dari favorit berdasarkan id
  static Future<bool> removeFavorite(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final favorites = await getFavorites();
    favorites.removeWhere((c) => c.id == id);
    final List<String> favStrings = favorites
        .map((c) => jsonEncode(c.toMap()))
        .toList();
    await prefs.setStringList(_keyFavorites, favStrings);
    return true;
  }
}