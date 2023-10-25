import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:obl_ihc_pruebasconflutter/entities/Product.dart';
import 'package:obl_ihc_pruebasconflutter/views/addproduct_page.dart';
import 'package:obl_ihc_pruebasconflutter/views/productdetail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:obl_ihc_pruebasconflutter/views/loading.dart';

class SearchProductPage extends StatelessWidget {
  Future<void> _scanBarcode(BuildContext context) async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancelar", true, ScanMode.BARCODE);
      print('Código de barras escaneado: $barcodeScanRes');

      if (barcodeScanRes != "-1") {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Container(
                width: 80, // Establece el ancho deseado
                height: 80, // Establece la altura deseada
                color: Colors.white.withOpacity(0.1),
                child:
                    LoadingIndicator(), // Muestra el widget de indicador de carga
              ),
            );
          },
        );
      }
      // Muestra el indicador de carga mientras se obtiene la información del producto

      Product? scannedProduct = await getProductInfo(barcodeScanRes);

      // Cierra el diálogo de carga
      Navigator.pop(context);

      if (scannedProduct != null) {
/*         List<Product> recommendedProducts =
            await getRecommendedProducts(scannedProduct); */

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              product: scannedProduct,
              recommendedProducts: [],
              ask:true,
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
        // El usuario canceló el escaneo
        print('Escaneo cancelado');
      } else {
        // Ocurrió un error durante el escaneo
        print('Error al escanear código de barras: $e');
      }
    }
  }

  Future<void> _takePicture(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? picture = await picker.pickImage(source: ImageSource.camera);

    if (picture != null) {
      print('Foto sacada: ${picture.path}');
      // Agregar la lógica con la foto que se sacó
    } else {
      print('El usuario canceló la toma de la foto o ocurrió un error.');
    }
  }

  Future<Product?> getProductInfo(String barcode) async {
    Map? data;
    http.Response response = await http
        .get(Uri.parse('https://ihc.gil.com.uy/api/products/$barcode'));
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
                    horizontal: 16.0), // Padding horizontal
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
                  .infinity, // Ancho máximo para igualar el tamaño de los botones
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0), // Padding horizontal
                child: ElevatedButton(
                  onPressed: () {
                    _takePicture(context);
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
