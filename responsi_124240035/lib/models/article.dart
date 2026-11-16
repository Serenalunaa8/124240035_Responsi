class Articles {
  final int id;
  final String title;
  final String authors;
  final String url;
  final String image_url;
  final String news_site;
  final String summary;
  final String published_at;

  Articles({
    required this.id,
    required this.title,
    required this.authors,
    required this.url,
    required this.image_url,
    required this.news_site,
    required this.summary,
    required this.published_at,
  });

  factory Articles.fromJson(Map<String, dynamic> json) {
    return Articles(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      authors: json['authors'] != null ? (json['authors']['name'] ?? '') : '',
      url: json['url'] ?? '',
      image_url: json['image_url'] ?? '',
      news_site: json['news_site'] ?? '',
      summary: json['summary'] ?? '',
      published_at: json['published_at'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'url': url,
      'image_url': image_url,
      'news_site': news_site,
      'summary': summary,
      'published_at': published_at,
    };
  }

  factory Articles.fromMap(Map<String, dynamic> map) {
    return Articles(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      authors: map['authors'] != null ? (map['authors']['name'] ?? '') : '',
      url: map['url'] ?? '',
      image_url: map['image_url'] ?? '',
      news_site: map['news_site'] ?? '',
      summary: map['summary'] ?? '',
      published_at: map['published_at'] ?? '',
    );
  }
}
