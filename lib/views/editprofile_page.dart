import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final User? user;

  EditProfilePage(this.user);

  @override
  _EditProfilePageState createState() => _EditProfilePageState(user);
}

class _EditProfilePageState extends State<EditProfilePage> {
  User? _user;
  late TextEditingController nameController;
  late TextEditingController emailController;

  _EditProfilePageState(this._user);

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: _user?.displayName ?? '');
    emailController = TextEditingController(text: _user?.email ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfileChanges() async {
    try {
      await _user?.updateDisplayName(nameController.text);
      await _user?.reload();
      _user = FirebaseAuth.instance.currentUser;

      await _user?.updateEmail(emailController.text);
      await _user?.reload();
      _user = FirebaseAuth.instance.currentUser;

      nameController.text = _user?.displayName ?? '';
      emailController.text = _user?.email ?? '';

      setState(() {});

      Navigator.pop(context, _user);
    } catch (e) {
      print('Error al actualizar el perfil: $e');
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
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ),
            SizedBox(height: 20),
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
          ],
        ),
      ),
    );
  }
}