class Article {

  final String title;
  final String description;
  final String urlToImage;
  final String url;

  Article({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.url,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'title',
      description: json['description'] ?? 'description',
      urlToImage: json['urlToImage'] ?? 'urlToImage',
      url: json['url'] ?? 'url',
    );
  }
}