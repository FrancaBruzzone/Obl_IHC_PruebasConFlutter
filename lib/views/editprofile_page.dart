import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:obl_ihc_pruebasconflutter/views/loading.dart';

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

  Future<void> _saveProfileChanges() async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            width: 80,
            height: 80,
            color: Colors.white.withOpacity(0.1),
            child: LoadingIndicator(),
          ),
        );
      },
    );

    try {
      final String newDisplayName = nameController.text;
      final String newPassword = newPasswordController.text;

      if (currentPasswordController.text.isNotEmpty && newPassword.isNotEmpty) {
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
        SnackBar(
          content: Text(
            'Error al actualizar el perfil',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                decoration: InputDecoration(labelText: 'Contraseña actual'),
                obscureText: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                controller: newPasswordController,
                decoration: InputDecoration(labelText: 'Nueva contraseña'),
                obscureText: true,
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
}