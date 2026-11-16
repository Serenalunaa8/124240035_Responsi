class Articles {
  final int id;
  final String title;
  final String authors;
  final String url;
  final String imageUrl;
  final String newsSite;
  final String summary;
  final String publishedAt;

  Articles({
    required this.id,
    required this.title,
    required this.authors,
    required this.url,
    required this.imageUrl,
    required this.newsSite,
    required this.summary,
    required this.publishedAt,
  });

  factory Articles.fromJson(Map<String, dynamic> json) {
    String authorText = 'Unknown Author';
    if (json['authors'] != null && json['authors'] is List && (json['authors'] as List).isNotEmpty) {
      final list = json['authors'] as List;
      final names = list
          .map((item) => item['name']?.toString() ?? '')
          .where((name) => name.isNotEmpty)
          .toList();
      if (names.isNotEmpty) {
        authorText = names.join(', ');
      }
    }

    return Articles(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      authors: authorText,
      url: json['url'] ?? '',
      imageUrl: json['image_url'] ?? '',
      newsSite: json['news_site'] ?? '',
      summary: json['summary'] ?? '',
      publishedAt: json['published_at'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'url': url,
      'image_url': imageUrl,
      'news_site': newsSite,
      'summary': summary,
      'published_at': publishedAt,
    };
  }

  factory Articles.fromMap(Map<String, dynamic> map) {
    return Articles(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      authors: map['authors'] ?? 'Unknown Author',
      url: map['url'] ?? '',
      imageUrl: map['image_url'] ?? '',
      newsSite: map['news_site'] ?? '',
      summary: map['summary'] ?? '',
      publishedAt: map['published_at'] ?? '',
    );
  }
}
