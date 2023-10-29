import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'package:obl_ihc_pruebasconflutter/views/home_page.dart';

// ==========================
// Vista
// ==========================
class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool isLogged = false;
  User? currentUser;
  static const String _key = 'token';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       home: (isLogged) ? HomePage(currentUser!) : LoginPage(),
    );
  }

  // ==========================
  // Lógica
  // ==========================
  void loadData() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String value = preferences.getString(_key) ?? '';
    isLogged = (value != '');

    if (isLogged)
      currentUser = FirebaseAuth.instance.currentUser;
  }

  void saveData(String value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(_key, value);
  }
}