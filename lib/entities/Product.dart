import 'dart:io';

class Product {
  final String name;
  String? code;
  String? description;
  String? imageUrl;
  String? environmentalInfo;
  String? category;
  String? environmentalCategory;
  File? imageFile;

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