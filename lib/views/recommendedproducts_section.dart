import 'package:flutter/material.dart';
import 'package:obl_ihc_pruebasconflutter/entities/Product.dart';
import 'package:obl_ihc_pruebasconflutter/views/barcodeproductdetail_page.dart';
import 'package:obl_ihc_pruebasconflutter/views/cameraproductdetail_page.dart';

class RecommendedProductsSection extends StatelessWidget {
  final List<Product> recommendedProducts;
  final bool isBarcodeDetail;

  RecommendedProductsSection(this.recommendedProducts, this.isBarcodeDetail);

  String _getFirstWords(String content) {
    List<String> words = content.split(' ');
    if (words.length >= 20) {
      return words.sublist(0, 20).join(' ');
    } else {
      return content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recommendedProducts.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            leading: Icon(Icons.shopping_cart, color: Colors.green),
            title: Text(recommendedProducts[index].name),
            subtitle: Container(
              margin: EdgeInsets.only(top: 8.0),
              child: Text(_getFirstWords(recommendedProducts[index].description!) + '...'),
            ),
            onTap: () {
              if (this.isBarcodeDetail) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        BarcodeProductDetailPage(
                            product: recommendedProducts[index],
                            recommendedProducts: recommendedProducts,
                            showDetails: false,
                            ask:false
                        ),
                  ),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        CameraProductDetailPage(
                            product: recommendedProducts[index],
                            recommendedProducts: recommendedProducts,
                            showDetails: false,
                            ask:false
                        ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}