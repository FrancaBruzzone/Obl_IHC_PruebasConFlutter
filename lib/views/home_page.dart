import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:obl_ihc_pruebasconflutter/views/articles_page.dart';
import 'package:obl_ihc_pruebasconflutter/views/profile_page.dart';
import 'package:obl_ihc_pruebasconflutter/views/searchproduct_page.dart';

class HomePage extends StatelessWidget {
  final User user;
  HomePage(this.user);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset('images/GREENTRACE_WHITE.png', width: 40),
                  SizedBox(width: 8),
                  Text('GreenTrace', style: TextStyle(fontSize: 26)),
                ],
              )
            ],
          ),
          bottom: TabBar(
            labelStyle: TextStyle(fontSize: 16),
            tabs: [
              Tab(text: 'Productos'),
              Tab(text: 'Artículos'),
              Tab(text: 'Mi perfil'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Expanded(
                  child: SearchProductPage(),
                ),
              ],
            ),
            Column(
              children: [
                Expanded(
                  child: ArticlesPage(),
                ),
              ],
            ),
            Column(
              children: [
                Expanded(
                  child: ProfilePage(user),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}