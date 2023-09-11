import 'package:flutter/material.dart';

class SearchProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                print('Se seleccionó escanear código de barras');
              },
              child: Text('Escanear código de barras'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print('Se seleccionó sacar foto a producto');
              },
              child: Text('Sacar foto al producto'),
            ),
          ],
        ),
      ),
    );
  }
}