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
                // Lógica para actualizar el nombre
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                initialValue: user.apellido,
                decoration: InputDecoration(labelText: 'Apellido'),
                // Lógica para actualizar el apellido
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                initialValue: user.email,
                decoration: InputDecoration(labelText: 'Email'),
                // Lógica para actualizar el email
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                obscureText: true,
                initialValue: user.contrasena,
                decoration: InputDecoration(labelText: 'Contraseña'),
                // Lógica para actualizar la contraseña
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              onPressed: () {
                // Lógica para guardar los cambios en el perfil
                Navigator.of(context).pop(); // Vuelve a la página de perfil después de guardar
              },
              icon: Icon(
                Icons.save,
                color: Colors.white,
              ),
              label: Text('Guardar',
                  style: TextStyle(color: Colors.white)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
