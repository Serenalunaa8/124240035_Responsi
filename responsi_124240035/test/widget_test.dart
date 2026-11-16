import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_124240035/models/article.dart';

void main() {
  test('Articles model parsing test', () {
    final json = {
      'id': 1,
      'title': 'Starship Flight Test',
      'url': 'https://example.com/article',
      'image_url': 'https://example.com/image.jpg',
      'news_site': 'NASA',
      'summary': 'Summary of flight test',
      'published_at': '2026-11-16T12:00:00Z',
      'authors': [
        {'name': 'John Explorer'}
      ],
    };

    final article = Articles.fromJson(json);

    expect(article.id, 1);
    expect(article.title, 'Starship Flight Test');
    expect(article.authors, 'John Explorer');
    expect(article.newsSite, 'NASA');
    expect(article.imageUrl, 'https://example.com/image.jpg');
    expect(article.summary, 'Summary of flight test');
  });
}
