class Article {
  final String? type;
  final String title;
  final String content;
  final String? url;

  Article({
    this.type,
    required this.title,
    required this.content,
    this.url,
  });
}