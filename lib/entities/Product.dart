class Product {
  final String? code;
  final String name;
  final String description;
  final String imageUrl;
  final String environmentalInfo;
  final String category;
  final String environmentalCategory;

  Product({
    this.code,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.environmentalInfo,
    required this.category,
    required this.environmentalCategory
  });
}