import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';


// Layanan untuk mengambil data dari Spaceflight News API
class ApiService {
  static const String baseUrl = 'https://api.spaceflightnewsapi.net/v4/articles';

  // Mengambil daftar artikel dengan filter status atau pencarian nama
  static Future<List<Articles>> getArticles({
    String? news_site,
    String? title,
  }) async {
    final queryParameters = <String, String>{};

    if (news_site != null && news_site.isNotEmpty) {
      queryParameters['news_site'] = news_site;
    }
    if (title != null && title.trim().isNotEmpty) {
      queryParameters['title'] = title.trim();
    }

    final uri = Uri.parse('$baseUrl').replace(
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'] ?? [];
      return results.map((item) => Articles.fromJson(item)).toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Gagal memuat data artikel (Error: ${response.statusCode})');
    }
  }

  // Mengambil detail satu artikel berdasarkan ID
  static Future<Articles> getArticleDetail(int id) async {
    final uri = Uri.parse('$baseUrl/$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Articles.fromJson(data);
    } else {
      throw Exception('Gagal memuat detail artikel (Error: ${response.statusCode})');
    }
  }

  // Mengambil daftar artikel
  static Future<List<Articles>> getArticle({String? news_site, String? title}) async {
    try {
      final List<Articles> allArticles = [];
      for (int page = 1; page <= 3; page++) {
        final queryParams = <String, String>{'page': page.toString()};
        if (news_site != null && news_site.trim().isNotEmpty) {
          queryParams['news_site'] = news_site.trim();
        }
        if (title != null && title.trim().isNotEmpty) {
          queryParams['title'] = title.trim();
        }
        final uri = Uri.parse('$baseUrl').replace(queryParameters: queryParams);
        final response = await http.get(uri);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final List results = data['results'] ?? [];
          allArticles.addAll(results.map((item) => Articles.fromJson(item)));
          final info = data['info'];
          if (info != null && info['next'] == null) {
            break;
          }
        } else {
          break;
        }
      }
      return allArticles;
    } catch (e) {
      final uri = Uri.parse('$baseUrl/episode');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List results = data['results'] ?? [];
        return results.map((item) => Articles.fromJson(item)).toList();
      }
      throw Exception('Gagal memuat data artikel: $e');
    }
  }
}