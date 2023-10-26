import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:obl_ihc_pruebasconflutter/entities/Product.dart';
import 'package:obl_ihc_pruebasconflutter/views/loading.dart';
import 'package:obl_ihc_pruebasconflutter/views/recommendedproducts_section.dart';

class CameraProductDetailPage extends StatefulWidget {
  final Product product;
  late List<Product> recommendedProducts;
  final bool showDetails;
  final bool ask;

  CameraProductDetailPage({
    required this.product,
    required this.recommendedProducts,
    this.showDetails = true,
    required this.ask
  });

  @override
  State<CameraProductDetailPage> createState() => _CameraProductDetailPageState(product, recommendedProducts, showDetails, ask);
}

class _CameraProductDetailPageState extends State<CameraProductDetailPage> {
  final Product product;
  late List<Product> recommendedProducts;
  final bool showDetails;
  bool loadingRecommendedProducts = true;
  bool ask = false;

  _CameraProductDetailPageState(this.product, this.recommendedProducts, this.showDetails, this.ask);

  @override
  void initState() {
    super.initState();
    getRecommendedProducts(product,ask);
  }

  Future<void> getRecommendedProducts(Product scannedProduct, bool ask) async {
    if (!ask) return;
    try {
      Map<String, String> headers = {
        'Authorization': 'ihc',
      };

      http.Response response = await http.get(
          Uri.parse('https://ihc.gil.com.uy/api/querys?filter=${scannedProduct.description}'),
          headers: headers
      );

      var data = json.decode(response.body);
      List<Product> recommendedProd = [];

      if (data != null) {
        for (var p in data) {
          var x = Product(
              name: p["name"],
              description: p["description"],
              imageUrl: "",
              environmentalInfo: p["environmentalInfo"],
              category: p["category"],
              environmentalCategory: p["environmentalCategory"]
          );

          recommendedProd.add(x);
        }

        setState(() {
          recommendedProducts = recommendedProd;
          loadingRecommendedProducts = false;
        });
      } else {
        setState(() {
          recommendedProducts = recommendedProd;
          loadingRecommendedProducts = false;
        });
      }
    } catch (e) {
      setState(() {
        recommendedProducts = [];
        loadingRecommendedProducts = false;
      });
    }
  }

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
              Text(widget.product.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              if (widget.showDetails) ...[
                SizedBox(height: 20),
                Center(
                    child: Image.file(widget.product.imageFile!,
                      width: 60,
                    )
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
                Text('Productos recomendados:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FutureBuilder(
                    future: Future.value(recommendedProducts),
                    builder: (context, snapshot) {
                      if (loadingRecommendedProducts) {
                        return LoadingIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return RecommendedProductsSection( recommendedProducts, false );
                      }
                      return Container();
                    }
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
