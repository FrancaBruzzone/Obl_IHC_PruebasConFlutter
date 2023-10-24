import 'package:flutter/material.dart';
import 'package:obl_ihc_pruebasconflutter/views/home_page.dart';
import 'package:obl_ihc_pruebasconflutter/views/recoverypassword_page.dart';
import 'package:obl_ihc_pruebasconflutter/views/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';



  void _saveData(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", value);
  }


class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  late TextEditingController _emailController = TextEditingController();
  late TextEditingController _passwordController = TextEditingController();


  bool isError = false;
  void setDemo() {
    setState(() {
      _emailController = TextEditingController(text: "demo@greentrace.uy");
      _passwordController = TextEditingController(text: "demo123");
    });
  }

Future<void> _signInWithFacebook() async {
    final result = await FacebookAuth.instance.login();
    final accessToken = result.accessToken;
    // Aquí puedes usar accessToken para autenticar al usuario con Firebase
  }

  Future<User?> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      debugPrint(googleSignInAccount.toString());
      debugPrint("el usuario logueado es:  ${googleSignInAccount.toString()}");
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;
        debugPrint("el usuario logueado es:  ${user.toString()}");

        return user;
      }
    } catch (error) {
      print('Error al iniciar sesión con Google: $error');
      return null;
    }
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    debugPrint(googleUser?.displayName.toString());

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    var cred = await FirebaseAuth.instance.signInWithCredential(credential);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }


  Future<void> _signInWithEmailAndPassword() async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("OK al iniciar sesión:");
      // Si la autenticación tiene éxito, puedes redirigir al usuario a la pantalla principal o realizar otras acciones
      // Por ejemplo:

      print(await _auth.currentUser?.displayName);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      // Si ocurre un error durante la autenticación, muestra un mensaje de error
      debugPrint("Error al iniciar sesión: $e");
      setState(() {
        isError = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GreenTrace'),
        backgroundColor: Colors.green,
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
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              onPressed: () {
                // Navega a la página de inicio
                _saveData("yes");
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
              label: Text(
                'Iniciar sesión',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10.0),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RecoveryPasswordPage(),
                  ),
                );
              },
              child: Text(
                'Olvidé mi contraseña',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(Size(40, 40))
                  ),
                  onPressed: () {
                    // Iniciar sesión con Google
                  },
                  icon: Icon(
                    Icons.g_mobiledata,
                    color: Colors.white,
                  ),
                  label: Text(
                    '',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(Size(40, 40))
                  ),
                  onPressed: () {
                    // Iniciar sesión con Facebook
                  },
                  icon: Icon(
                    Icons.facebook,
                    color: Colors.white,
                  ),
                  label: Text(''),
                ),
              ],
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