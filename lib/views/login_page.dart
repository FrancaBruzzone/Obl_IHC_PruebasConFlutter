import 'package:flutter/material.dart';
import 'package:obl_ihc_pruebasconflutter/views/home_page.dart';
import 'package:obl_ihc_pruebasconflutter/views/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';


class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController(text: "demo@greentrace.uy");
  final TextEditingController _passwordController = TextEditingController(text: "demo123");

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      // Utiliza Firebase Authentication para iniciar sesión con correo y contraseña
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );



      print("OK al iniciar sesión:");
      // Si la autenticación tiene éxito, puedes redirigir al usuario a la pantalla principal o realizar otras acciones
      // Por ejemplo: 

      print(await _auth.currentUser?.displayName);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
     
    } catch (e) {
      // Si ocurre un error durante la autenticación, muestra un mensaje de error
      print("Error al iniciar sesión: $e");
    }
  }

Future<void> _signInWithGoogle() async {
  print('Iniciando consulta a google por usuario');
    try {
      final UserCredential userCredential = await _auth.signInWithPopup(
        GoogleAuthProvider(),
      );
      final User user = userCredential.user!;
      print('Inicio de sesión exitoso: ${user.displayName}');
      // Redirige a la pantalla principal o realiza otras acciones después del inicio de sesión.
    } catch (e) {
      print('Error al iniciar sesión con Google: $e');
    }
  }

  Future<UserCredential> signInWithFacebook() async {
  // Trigger the sign-in flow

 final LoginResult loginResult = await FacebookAuth.instance.login();

  // Create a credential from the access token
  final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return _auth.signInWithCredential(facebookAuthCredential);

 
 

  // Once signed in, return the UserCredential

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
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
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
             /*  onPressed: () {
                // Navega a la página de inicio
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              }, */
              onPressed: _signInWithEmailAndPassword,
              icon: Icon(
                Icons.login,
                color: Colors.white,
              ),
              label: Text(
                'Iniciar sesión',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      minimumSize:
                          MaterialStateProperty.all<Size>(Size(40, 40))),
                  onPressed: _signInWithGoogle,
                    // Iniciar sesión con Google
                  
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
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      minimumSize:
                          MaterialStateProperty.all<Size>(Size(40, 40))),
                  onPressed: signInWithFacebook,
                  icon: Icon(
                    Icons.facebook,
                    color: Colors.white,
                  ),
                  label: Text(''),
                ),

                
                
              ],
              
            ),
            SizedBox(height: 26.0),
            Text(
              'Usuario DEMO: demo@greentrace.uy Contraseña demo123',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
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
                '¿No tienes una cuenta? Regístrate aquí.' ,
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
