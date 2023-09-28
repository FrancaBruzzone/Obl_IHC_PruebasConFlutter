import 'package:flutter/material.dart';
import 'package:obl_ihc_pruebasconflutter/views/confirmation_page.dart';

class RecoveryPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    void _sendRecoveryEmail() {
      String userEmail = emailController.text;
      // Enviar un correo con un enlace de recuperación a 'userEmail'
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar Contraseña'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Ingrese su email para recuperar su contraseña',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              onPressed: () {
                _sendRecoveryEmail();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ConfirmationPage(),
                  ),
                );
              },
              icon: Icon(
                Icons.send, // Icono de enviar
                color: Colors.white,
              ),
              label: Text(
                'Enviar enlace',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}