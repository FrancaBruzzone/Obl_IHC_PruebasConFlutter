import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicación Flutter',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Aplicación Flutter'),
      ),
      body: Center(
        child: Text(
          '¡Hola, mundo!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}