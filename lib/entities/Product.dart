import 'dart:io';

class Product {
  final String name;
  final String? code;
  final String? description;
  final String? imageUrl;
  final String? environmentalInfo;
  final String? category;
  final String? environmentalCategory;
  final File? imageFile;

  Product({
    required this.name,
    this.code,
    this.description,
    this.imageUrl,
    this.environmentalInfo,
    this.category,
    this.environmentalCategory,
    this.imageFile
  });
}