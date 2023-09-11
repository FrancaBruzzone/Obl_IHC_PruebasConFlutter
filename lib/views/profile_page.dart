import 'package:flutter/material.dart';
import 'package:obl_ihc_pruebasconflutter/entities/User.dart';

class ProfilePage extends StatelessWidget {
  final user = User(
      'Franca',
      'Bruzzone',
      'francabruzzone2@gmail.com',
      'contrasena123'
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Nombre: ${user.nombre}'),
            Text('Apellido: ${user.apellido}'),
            Text('Email: ${user.email}'),
            Text('Contraseña: ${user.contrasena}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print('Se seleccionó editar perfil');
              },
              child: Text('Editar Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}