import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:obl_ihc_pruebasconflutter/utils.dart';

// ==========================
// Vista
// ==========================
class EditProfilePage extends StatefulWidget {
  final User? user;
  EditProfilePage(this.user);

  @override
  _EditProfilePageState createState() => _EditProfilePageState(user);
}

class _EditProfilePageState extends State<EditProfilePage> {
  User? _user;
  late TextEditingController nameController;
  late TextEditingController currentPasswordController;
  late TextEditingController newPasswordController;
  bool currentPasswordObscureText = true;
  bool newPasswordObscureText = true;

  _EditProfilePageState(this._user);

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: _user?.displayName ?? '');
    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

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
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                controller: currentPasswordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña actual',
                  suffixIcon: IconButton(
                    icon: Icon(currentPasswordObscureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        currentPasswordObscureText = !currentPasswordObscureText;
                      });
                    },
                  ),
                ),
                obscureText: currentPasswordObscureText,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                controller: newPasswordController,
                decoration: InputDecoration(
                  labelText: 'Nueva contraseña',
                  suffixIcon: IconButton(
                    icon: Icon(newPasswordObscureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        newPasswordObscureText = !newPasswordObscureText;
                      });
                    },
                  ),
                ),
                obscureText: newPasswordObscureText,
              ),
            ),
            SizedBox(height: 60),
            SizedBox(
              width: 130,
              height: 40,
              child:
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                ),
                onPressed: _saveProfileChanges,
                icon: Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                label: Text('Guardar', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================
  // Lógica
  // ==========================
  Future<void> _saveProfileChanges() async {
    Utils.showLoaderDialog(context);

    try {
      final String newDisplayName = nameController.text;
      final String newPassword = newPasswordController.text;

      if (currentPasswordController.text.isNotEmpty || newPassword.isNotEmpty) {
        final AuthCredential credential = EmailAuthProvider.credential(
          email: _user?.email ?? '',
          password: currentPasswordController.text,
        );

        await _user?.reauthenticateWithCredential(credential);
        await _user?.updatePassword(newPassword);
      }

      if (newDisplayName != _user?.displayName) {
        await _user?.updateDisplayName(newDisplayName);
        await _user?.reload();
        _user = FirebaseAuth.instance.currentUser;

        nameController.text = _user?.displayName ?? '';
      }

      Navigator.pop(context);
      Navigator.pop(context, _user);

    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          Utils.getSnackBarError('Error al actualizar el perfil, datos incorrectos')
      );
    }
  }
}