class Article {
  final String? type;
  final String title;
  final String description;
  final String articleUrl;
  final String content;

  Article({
    this.type,
    required this.title,
    required this.description,
    required this.articleUrl,
    required this.content,
  });
}