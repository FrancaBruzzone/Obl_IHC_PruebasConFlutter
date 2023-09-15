import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class SearchProductPage extends StatelessWidget {
  Future<void> _scanBarcode(BuildContext context) async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancelar", true, ScanMode.BARCODE);
      print('Código de barras escaneado: $barcodeScanRes');

      await fetchData("https://es.openfoodfacts.org/api/v0/product/"+barcodeScanRes);

      // Acá buscar el producto en la BD
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


  Future<void> fetchData(String urlapi) async {
  final url = Uri.parse(urlapi); // Reemplaza con la URL de la API que deseas consultar

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print("todo ok");
      // Si la solicitud es exitosa (código de estado 200)
      final data = jsonDecode(response.body);
      // data contiene la respuesta de la API en formato JSON

      // Aquí puedes procesar los datos según tus necesidades
      print('Datos recibidos: $data');
    } else {
      // Si la solicitud no es exitosa, maneja el error
      print('Error en la solicitud: ${response.statusCode}');
    }
  } catch (e) {
    // Maneja las excepciones si ocurren durante la solicitud
    print('Error en la solicitud: $e');
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