import 'package:flutter/material.dart';
import 'package:obl_ihc_pruebasconflutter/views/home_page.dart';
import 'package:obl_ihc_pruebasconflutter/views/register_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GreenTrace'),
        backgroundColor: Colors.green
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              obscureText: true, // Para ocultar la contraseña
              decoration: InputDecoration(
                labelText: 'Contraseña',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green)
              ),
              onPressed: () {
                // Navega a la página de inicio
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              icon: Icon(
                Icons.login,
                color: Colors.white,
              ),
              label: Text('Iniciar sesión',
                  style: TextStyle(color: Colors.white)
              )
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RegisterPage(),
                  ),
                );
              },
              child: Text(
                '¿No tienes una cuenta? Regístrate aquí',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}