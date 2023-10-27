class Article {
  final String? type;
  final String title;
  final String description;
  final String content;
  final String articleUrl;

  Article({
    this.type,
    required this.title,
    required this.description,
    required this.content,
    required this.articleUrl,
  });
}