import 'package:flutter/material.dart';
import 'package:obl_ihc_pruebasconflutter/entities/User.dart';
import 'package:obl_ihc_pruebasconflutter/views/editprofile_page.dart';
import 'package:obl_ihc_pruebasconflutter/views/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


  void _saveData(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", value);
  }
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
            _buildProfileInfo('Nombre:', user.nombre, Icons.person),
            _buildProfileInfo('Apellido:', user.apellido, Icons.person),
            _buildProfileInfo('Email:', user.email, Icons.email),
            _buildProfileInfo('Contraseña:', user.contrasena, Icons.lock),
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(user),
                  ),
                );
              },
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              label: Text('Editar', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              onPressed: () {
                _saveData("");
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                      (route) => false,
                );
              },
              icon: Icon(
                Icons.exit_to_app, // Icono de cierre de sesión
                color: Colors.white,
              ),
              label: Text('Salir', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(String label, String value, IconData icon) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 16),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  icon,
                  color: Colors.green,
                  size: 24.0,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}