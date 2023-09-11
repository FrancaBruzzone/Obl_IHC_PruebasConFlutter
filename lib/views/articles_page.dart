import 'package:flutter/material.dart';
import 'package:obl_ihc_pruebasconflutter/entities/Article.dart';
import 'package:obl_ihc_pruebasconflutter/views/article_description.dart';

class ArticlesPage extends StatelessWidget {
  final List<Article> articles = [
    Article(
      title: 'Título del artículo 1',
      content: 'Contenido del artículo 1...',
    ),
    Article(
      title: 'Título del artículo 2',
      content: 'Contenido del artículo 2...',
    ),
    Article(
      title: 'Título del artículo 3',
      content: 'Contenido del artículo 3...',
    ),
    Article(
      title: 'Título del artículo 4',
      content: 'Contenido del artículo 4...',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(articles[index].title),
              subtitle: Text(articles[index].content),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleDescription(articles[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}