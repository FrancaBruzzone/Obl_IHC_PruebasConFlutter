import 'package:flutter/material.dart';
import 'package:obl_ihc_pruebasconflutter/entities/Product.dart';
import 'package:obl_ihc_pruebasconflutter/utils.dart';
import 'package:obl_ihc_pruebasconflutter/views/productdetail_page.dart';

// ==========================
// Vista
// ==========================
class RecommendedProductsSection extends StatelessWidget {
  final List<Product> recommendedProducts;
  RecommendedProductsSection(this.recommendedProducts);

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
              child: Text(Utils.getFirstWords(recommendedProducts[index].description!) + '...'),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                  ProductDetailPage(
                    product: recommendedProducts[index],
                    recommendedProducts: recommendedProducts,
                    showDetails: false,
                    ask:false,
                    withBarcode: true,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}