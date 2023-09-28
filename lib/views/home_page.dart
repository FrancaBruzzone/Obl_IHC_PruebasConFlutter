import 'package:flutter/material.dart';
import 'package:obl_ihc_pruebasconflutter/views/articles_page.dart';
import 'package:obl_ihc_pruebasconflutter/views/login_page.dart';
import 'package:obl_ihc_pruebasconflutter/views/profile_page.dart';
import 'package:obl_ihc_pruebasconflutter/views/searchproduct_page.dart';

class HomePage extends StatelessWidget {
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
              Text('GreenTrace', style: TextStyle(fontSize: 20)),
              SizedBox(height: 2.0),
              Text('¡Bienvenid@! Franca', style: TextStyle(fontSize: 16)),
            ],
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Productos'),
              Tab(text: 'Artículos'),
              Tab(text: 'Mi perfil'),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
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