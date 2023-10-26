import 'package:flutter/material.dart';
import 'package:obl_ihc_pruebasconflutter/entities/User.dart';

class EditProfilePage extends StatelessWidget {
  final User user;

  EditProfilePage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Editar perfil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                initialValue: user.nombre,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                initialValue: user.apellido,
                decoration: InputDecoration(labelText: 'Apellido'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                initialValue: user.email,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                obscureText: true,
                initialValue: user.contrasena,
                decoration: InputDecoration(labelText: 'Contraseña'),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.save,
                color: Colors.white,
              ),
              label: Text('Guardar', style: TextStyle(color: Colors.white)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
