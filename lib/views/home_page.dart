import 'package:flutter/material.dart';
import 'package:obl_ihc_pruebasconflutter/views/articles_page.dart';
import 'package:obl_ihc_pruebasconflutter/views/login_page.dart';
import 'package:obl_ihc_pruebasconflutter/views/profile_page.dart';
import 'package:obl_ihc_pruebasconflutter/views/searchproduct_page.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {

/*   void _saveData(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", "yes");

  } */

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Número de pestañas
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('GreenTrace', style: TextStyle(fontSize: 24))
            ],
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Productos'),
              Tab(text: 'Artículos'),
              Tab(text: 'Mi perfil'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Contenido de la pestaña 1
            Column(
              children: [
                Expanded(
                  child: SearchProductPage(),
                ),
              ],
            ),
            // Contenido de la pestaña 2
            Column(
              children: [
                Expanded(
                  child: ArticlesPage(),
                ),
              ],
            ),
            // Contenido de la pestaña 3
            Column(
              children: [
                Expanded(
                  child: ProfilePage(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}