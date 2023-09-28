import 'package:flutter/material.dart';
import 'package:obl_ihc_pruebasconflutter/entities/Product.dart';
import 'package:obl_ihc_pruebasconflutter/views/editproduct_page.dart';
import 'package:obl_ihc_pruebasconflutter/views/recommendedproducts_section.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  final List<Product> recommendedProducts;
  final bool showDetails;

  ProductDetailPage({
    required this.product,
    required this.recommendedProducts,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del producto'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text(
                product.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Información Ambiental:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                product.environmentalInfo,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Descripción:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                product.description,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              if (showDetails) ...[
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditProductPage(product),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    label: Text('Editar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Divider(
                  color: Colors.grey,
                  thickness: 2.0,
                  height: 20,
                  indent: 20,
                  endIndent: 20,
                ),
                SizedBox(height: 20),
                Text(
                  'Productos recomendados:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RecommendedProductsSection(recommendedProducts),
              ],
            ],
          ),
        ),
      ),
    );
  }
}