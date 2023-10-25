import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:obl_ihc_pruebasconflutter/entities/Product.dart';
import 'package:obl_ihc_pruebasconflutter/views/editproduct_page.dart';
import 'package:obl_ihc_pruebasconflutter/views/loading.dart';
import 'package:obl_ihc_pruebasconflutter/views/recommendedproducts_section.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  late List<Product> recommendedProducts;
  final bool showDetails;

  ProductDetailPage({
    required this.product,
    required this.recommendedProducts,
    this.showDetails = true,
  });

  @override
  State<ProductDetailPage> createState() =>
      _ProductDetailPageState(product, recommendedProducts, showDetails);
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final Product product;
  late List<Product> recommendedProducts;
  final bool showDetails;
  bool loadingRecommendedProducts = true;

  _ProductDetailPageState(
      this.product, this.recommendedProducts, this.showDetails);


  @override
  void initState() {
    super.initState();
    getRecommendedProducts(product);
/*     this.recommendedProducts = [
      Product(category: "",description: "", imageUrl: "", environmentalCategory: "", environmentalInfo: "", name: "nombre1"),
      Product(category: "",description: "", imageUrl: "", environmentalCategory: "", environmentalInfo: "", name: "nombre2")
    ]; */
  }

  Future<void> getRecommendedProducts(Product scannedProduct) async {
    try {
      Map<String, String> headers = {
        'Authorization': 'ihc',
      };

      http.Response response = await http.get(
          Uri.parse(
              'https://ihc.gil.com.uy/api/querys?filter=${scannedProduct.description}'),
          headers: headers);
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
              environmentalCategory: p["environmentalCategory"]);

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
    //getRecommendedProducts(product);
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
                widget.product.name,
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
                widget.product.environmentalInfo,
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
                widget.product.description,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              if (widget.showDetails) ...[
                SizedBox(height: 20),
                Center(
                    child: Image.network(
                  widget.product.imageUrl,
                  width: 60,
                  // Esto utiliza el administrador de caché predeterminado
                )),
                Center(
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditProductPage(widget.product),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Editar',
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
                FutureBuilder(
                    future: Future.value(recommendedProducts),
                    builder: (context, snapshot) {
                      if (loadingRecommendedProducts) {
                        return LoadingIndicator(); // Muestra un indicador de carga
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return RecommendedProductsSection(
                            recommendedProducts);
                      }
                      return Container();
                    }),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
