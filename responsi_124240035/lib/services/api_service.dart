import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ApiService {
  static const String baseUrl = 'https://api.spaceflightnewsapi.net/v4/articles';

  static Future<List<Articles>> getArticles({
    String? newsSite,
    String? search,
    int limit = 20,
  }) async {
    final Map<String, String> queryParameters = {
      'limit': limit.toString(),
    };

    if (newsSite != null && newsSite.isNotEmpty && newsSite != 'Semua' && newsSite != 'All') {
      queryParameters['news_site'] = newsSite;
    }

    if (search != null && search.trim().isNotEmpty) {
      queryParameters['search'] = search.trim();
    }

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'] ?? [];
      return results.map((item) => Articles.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat berita dari server');
    }
  }

  static Future<Articles> getArticleDetail(int id) async {
    final uri = Uri.parse('$baseUrl/$id/');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Articles.fromJson(data);
    } else {
      throw Exception('Gagal memuat detail berita');
    }
  }
}
