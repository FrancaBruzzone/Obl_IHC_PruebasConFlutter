import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:obl_ihc_pruebasconflutter/entities/Article.dart';

// ==========================
// Vista
// ==========================
class ArticleDetailPage extends StatelessWidget {
  final Article article;
  ArticleDetailPage(this.article);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Artículo de interés'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              article.title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              article.description,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              article.content + "...",
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 40),
            Center(
              child: TextButton(
                onPressed: () {
                  launch(article.articleUrl);
                },
                child: Text(
                  'Leer artículo completo',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}