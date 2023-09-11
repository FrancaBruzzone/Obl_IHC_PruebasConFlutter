import 'package:flutter/material.dart';

import '../entities/Article.dart';

class ArticleDescription extends StatelessWidget {
    final Article article;

  ArticleDescription(this.article);

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(article.content),
      ),
    );
  }
}