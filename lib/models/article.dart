class Article {
  final String title;
  final String author;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;

  Article({
    required this.title,
    required this.author,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
    };
  }
}
