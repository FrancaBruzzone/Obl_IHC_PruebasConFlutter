import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:obl_ihc_pruebasconflutter/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:obl_ihc_pruebasconflutter/views/editprofile_page.dart';
import 'package:obl_ihc_pruebasconflutter/views/login_page.dart';

// ==========================
// Vista
// ==========================
class ProfilePage extends StatefulWidget {
  final User? user;
  ProfilePage(this.user);

  @override
  _ProfilePageState createState() => _ProfilePageState(user);
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  _ProfilePageState(this._user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildProfileInfo('Nombre y apellido:', _user?.displayName ?? '', Icons.person),
            _buildProfileInfo('Email:', _user?.email ?? '', Icons.email),
            SizedBox(height: 80),
            SizedBox(
              width: 130,
              height: 40,
              child:
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(_user),
                    ),
                  ).then((resultUser) {
                    if (resultUser != null) {
                      setState(() {
                        _user = resultUser;
                      });
                    }
                  });
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                label: Text('Editar', style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 130,
              height: 40,
              child:
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                onPressed: () {
                  signOut(context);
                },
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.white
                ),
                label: Text('Salir', style: TextStyle(color: Colors.white)),
              ),
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

  // ==========================
  // Lógica
  // ==========================
  Future<void> signOut(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return Utils.getLoaderDialog();
      },
    );

    try {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      saveData("");

      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
            (route) => false,
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al cerrar sesión',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

void saveData(String value) async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString("token", value);
}