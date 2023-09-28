import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:obl_ihc_pruebasconflutter/entities/Product.dart';
import 'package:obl_ihc_pruebasconflutter/views/addproduct_page.dart';
import 'package:obl_ihc_pruebasconflutter/views/productdetail_page.dart';

class SearchProductPage extends StatelessWidget {
  Future<void> _scanBarcode(BuildContext context) async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancelar", true, ScanMode.BARCODE);
      print('Código de barras escaneado: $barcodeScanRes');

      Product scannedProduct = getProductInfo(barcodeScanRes);

      if (scannedProduct == null) {
        List<Product> recommendedProducts = getRecommendedProducts(scannedProduct);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              product: scannedProduct,
              recommendedProducts: recommendedProducts,
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddProductPage(),
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

  Product getProductInfo(String barcode) {
    return Product(
      name: 'Nombre del Producto',
      description: 'Descripción del Producto',
      imageUrl: 'URL de la imagen del Producto',
      environmentalInfo: 'Información Ambiental del Producto',
      category: 'Categoría del Producto',
      environmentalCategory: 'Categorización Ambiental del Producto',
    );
  }

  List<Product> getRecommendedProducts(Product scannedProduct) {
    List<Product> recommendedProducts = [
      Product(
        name: 'Producto Recomendado 1',
        description: 'Descripción del Producto Recomendado 1',
        imageUrl: 'URL de la imagen del Producto Recomendado 1',
        environmentalInfo: 'Información Ambiental del Producto Recomendado 1',
        category: 'Categoría del Producto Recomendado 1',
        environmentalCategory: 'Categorización Ambiental del Producto Recomendado 1',
      ),
      Product(
        name: 'Producto Recomendado 2',
        description: 'Descripción del Producto Recomendado 2',
        imageUrl: 'URL de la imagen del Producto Recomendado 2',
        environmentalInfo: 'Información Ambiental del Producto Recomendado 2',
        category: 'Categoría del Producto Recomendado 2',
        environmentalCategory: 'Categorización Ambiental del Producto Recomendado 2',
      )
    ];

    return recommendedProducts;
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding horizontal
                child: ElevatedButton(
                  onPressed: () {
                    _scanBarcode(context);
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
              width: double.infinity, // Ancho máximo para igualar el tamaño de los botones
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding horizontal
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