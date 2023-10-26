import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:obl_ihc_pruebasconflutter/entities/Product.dart';
import 'package:obl_ihc_pruebasconflutter/views/addproduct_page.dart';
import 'package:obl_ihc_pruebasconflutter/views/productdetail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:obl_ihc_pruebasconflutter/views/loading.dart';
import 'dart:io';

class SearchProductPage extends StatelessWidget {
  Future<void> _scanBarcode(BuildContext context) async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancelar", true, ScanMode.BARCODE
      );
      print('Código de barras escaneado: $barcodeScanRes');

      if (barcodeScanRes != "-1") {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Container(
                width: 80,
                height: 80,
                color: Colors.white.withOpacity(0.1),
                child: LoadingIndicator(),
              ),
            );
          },
        );
      }

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
      if (e is FormatException) {
        print('Escaneo cancelado');
      } else {
        print('Error al escanear código de barras: $e');
      }
    }
  }

  Future<Product?> getProductInfo(String barcode) async {
    Map? data;
    http.Response response = await http.get(Uri.parse('https://ihc.gil.com.uy/api/products/$barcode'));
    data = json.decode(response.body);
    print("DATA OBTENIDA: ${data}");

    if (data != null && data["error"] == null) {
      return Product(
        name: data["brand"] + " " + data["name"] + " " + data["quantity"],
        description: data["description"],
        imageUrl: data["imageUrl"],
        environmentalInfo: data["environmentalInfo"],
        category: data["category"],
        environmentalCategory: data["environmentalCategory"],
      );
    } else {
      return null;
    }
  }

  Future<void> _takePicture(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? picture = await picker.pickImage(source: ImageSource.camera);

    if (picture != null) {
      print('Foto sacada: ${picture.path}');
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              width: 80,
              height: 80,
              color: Colors.white.withOpacity(0.1),
              child: LoadingIndicator(),
            ),
          );
        },
      );

      Product? scannedProduct = await detectObjectsWithCloudVision(picture.path);
      Navigator.pop(context);

      if (scannedProduct != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              product: scannedProduct,
              recommendedProducts: [],
              ask: true
            ),
          ),
        );
      }
    } else {
      print('El usuario canceló la toma de la foto o ocurrió un error.');
    }
  }

  Future<Product?> detectObjectsWithCloudVision(String imagePath) async {
    final apiUrl = 'https://vision.googleapis.com/v1/images:annotate?key=AIzaSyC8lZz1_tMeY297wjg3WfcnAwykoAjnCig';
    final imageFile = File(imagePath);

    if (!imageFile.existsSync()) {
      print('La imagen no se encontró en la ubicación especificada.');
      return null;
    }

    final request = {
      'requests': [
        {
          'image': {
            'content': base64Encode(imageFile.readAsBytesSync()),
          },
          'features': [
            {
              'type': 'OBJECT_LOCALIZATION',
            },
          ],
          'imageContext': {
            'languageHints': ['es'],
          },
        },
      ],
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(request),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final objects = responseBody['responses'][0]['localizedObjectAnnotations'];
      bool objectWasFound = false;

      if (objects != null) {
        for (var object in objects) {
          final score = object['score'];

          if (score >= 0.85) {
            final description = object['name'];
            objectWasFound = true;

            var x = Product(
              name: object['name'],
              description: object['name'],
              imageUrl: "https://ihc.gil.com.uy/images/no_photo.jpg",
              environmentalInfo: object['name'],
              category: object['name'],
              environmentalCategory: object['name'],
            );

            print('Objeto: $description, Confianza: $score');
            return x;
          }
        }

        if (!objectWasFound) {
          print('No se encontró un objeto con una confianza mayor a 85%');
          return null;
        }
      } else {
        print('No se encontró ninguna respuesta');
        return null;
      }
    } else {
      print( 'Error al enviar la imagen a Google Cloud Vision. Código de respuesta: ${response.statusCode}');
      return null;
    }
    return null;
  }

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
                    _scanBarcode(context);
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
                      Text(
                        'Escanear código de barras',
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
                    _takePicture(context);
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
                      Text(
                        'Sacar foto a producto',
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
}