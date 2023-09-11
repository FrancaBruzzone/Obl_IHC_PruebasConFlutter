import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';

class SearchProductPage extends StatelessWidget {
  Future<void> _scanBarcode(BuildContext context) async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancelar", true, ScanMode.BARCODE);
      print('Código de barras escaneado: $barcodeScanRes');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _scanBarcode(context);
              },
              child: Row(
              mainAxisSize: MainAxisSize.min, // Alinea elementos en el eje principal (horizontal)
              children: <Widget>[
                Icon(Icons.qr_code_2_sharp), // Icono
                SizedBox(width: 4), // Espacio entre el icono y el texto
                Text('Escanear código de barras'), // Texto
              ],
            )
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _takePicture(context);
              },
              child: Row(
              mainAxisSize: MainAxisSize.min, // Alinea elementos en el eje principal (horizontal)
              children: <Widget>[
                Icon(Icons.camera), // Icono
                SizedBox(width: 4), // Espacio entre el icono y el texto
                Text('Foto al producto'), // Texto
              ],
            ),
            ),
          ],
        ),
      ),
    );
  }
}