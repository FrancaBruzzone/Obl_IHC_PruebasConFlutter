import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:obl_ihc_pruebasconflutter/entities/Product.dart';
import 'package:obl_ihc_pruebasconflutter/utils.dart';
import 'package:obl_ihc_pruebasconflutter/views/addproduct_page.dart';
import 'package:obl_ihc_pruebasconflutter/views/productdetail_page.dart';

// ==========================
// Vista
// ==========================
class SearchProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    scanBarcode(context);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.all(16.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.qr_code_scanner,
                        size: 40,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8),
                      Text('Escanear código de barras',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double
                  .infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    takePicture(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.all(16.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8),
                      Text('Sacar foto a producto',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================
  // Lógica
  // ==========================
  Future<void> scanBarcode(BuildContext context) async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancelar", true, ScanMode.BARCODE
      );

      if (barcodeScanRes != "-1")
        Utils.showLoaderDialog(context);

      Product? scannedProduct = await getProductInfo(barcodeScanRes);
      Navigator.pop(context);

      if (scannedProduct != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
                product: scannedProduct,
                recommendedProducts: [],
                ask: true,
                withBarcode: true
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddProductPage(
              productCode: barcodeScanRes,
            ),
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);

      if (e is! FormatException) {
        ScaffoldMessenger.of(context).showSnackBar(
            Utils.getSnackBarError('Hubo un error al escanear el código de barras, reitente más tarde.')
        );
      }
    }
  }

  Future<Product?> getProductInfo(String barcode) async {
    http.Response response = await http.get(Uri.parse('https://ihc.gil.com.uy/api/products/$barcode'));

    if (response.statusCode == 201) {
      Map data = json.decode(response.body);

      return Product(
        name: data["name"],
        description: data["description"],
        imageUrl: data["imageUrl"],
        environmentalInfo: data["environmentalInfo"],
        category: data["category"],
        environmentalCategory: data["environmentalCategory"],
      );
    }

    return null;
  }

  Future<void> takePicture(BuildContext context) async {
    final XFile? picture = await ImagePicker().pickImage(source: ImageSource.camera);

    if (picture != null) {
      Utils.showLoaderDialog(context);
      Product? scannedProduct = await detectObjectsWithCloudVision(context, picture.path);

      if (scannedProduct != null) {
        await getProductDetail(scannedProduct);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
                product: scannedProduct,
                recommendedProducts: [],
                ask: true,
                withBarcode: false
            ),
          ),
        );
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            Utils.getSnackBarError('No se encontró ningún producto relacionado después de 3 intentos.')
        );
      }
    }
  }

  Future<Product?> detectObjectsWithCloudVision(BuildContext context, String imagePath) async {
    final imageFile = File(imagePath);

    if (!imageFile.existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
          Utils.getSnackBarError('Hubo una falla en la imagen, vuelve a intentarlo.')
      );

      return null;
    }

    double confidenceThreshold = 0.80;

    for (int retry = 0; retry < 3; retry++) {
      final request = {
        'requests': [
          {
            'image': {'content': base64Encode(imageFile.readAsBytesSync())},
            'features': [{'type': 'OBJECT_LOCALIZATION'}]
          }
        ],
      };

      final response = await http.post(
        Uri.parse('https://vision.googleapis.com/v1/images:annotate?key=${Utils.googleCloudApiKey}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final objects = responseBody['responses'][0]['localizedObjectAnnotations'];

        if (objects != null && objects is List) {
          objects.sort((a, b) {
            final double scoreA = a['score'];
            final double scoreB = b['score'];
            return scoreB.compareTo(scoreA);
          });

          if (objects.isNotEmpty) {
            final bestObject = objects[0];
            final double bestScore = bestObject['score'];
            final String name = bestObject['name'];

            if (bestScore >= confidenceThreshold) {
              final name = bestObject['name'];
              final translatedName = await Utils.translateToSpanish(name);
              var x = Product(
                name: translatedName,
                description: '',
                imageUrl: '',
                environmentalInfo: '',
                category: '',
                environmentalCategory: '',
                imageFile: imageFile,
              );
              return x;
            } else {
              confidenceThreshold -= 0.10;
            }
          }
        }
      }
    }

    return null;
  }

  Future<void> getProductDetail(Product scannedProduct) async {
    String filter = scannedProduct.name;
    filter = Utils.removeDiacritics(filter);
    filter = filter.toUpperCase();

    try {
      Map<String, String> headers = { 'Authorization': 'ihc', };
      http.Response response = await http.get(Uri.parse('https://ihc.gil.com.uy/api/productDetails?filter=${filter}'),
          headers: headers
      );

      var data = json.decode(response.body);

      if (data != null) {
        scannedProduct.description = data["description"] as String;
        scannedProduct.environmentalInfo = data["environmentalInfo"] as String;
        scannedProduct.category = data["category"] as String;
        scannedProduct.environmentalCategory = data["environmentalCategory"] as String;
      }
    } catch (e) {
      print(e);
    }
  }
}