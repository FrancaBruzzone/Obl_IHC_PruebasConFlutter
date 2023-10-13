import 'package:flutter/material.dart';
import 'package:obl_ihc_pruebasconflutter/views/home_page.dart';
import 'login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool isLogged = false;
  static const String _key = 'token';

  @override
  void initState() {
    super.initState();
    _loadData(); // Cargamos el valor almacenado en las preferencias compartidas
  }

  void _loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String value = prefs.getString(_key) ?? '';
    setState(() {

      isLogged = (value == '') ? false : true;
    });
  }

  void _saveData(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: (isLogged) ? HomePage() : LoginPage(),
    );
  }
}
