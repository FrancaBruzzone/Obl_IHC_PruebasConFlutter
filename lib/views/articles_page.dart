import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:obl_ihc_pruebasconflutter/entities/Article.dart';
import 'package:obl_ihc_pruebasconflutter/utils.dart';
import 'package:obl_ihc_pruebasconflutter/views/articledetail_page.dart';

// ==========================
// Vista
// ==========================
class ArticlesPage extends StatefulWidget {
  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  List<Article> articles = [];
  Map? data;
  List? articlesData;

  @override
  initState() {
    super.initState();
    getArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshList,
        child: ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Utils.getTypeArticle(articles[index].type! ),
                title: Text(articles[index].title),
                subtitle: Container(
                  margin: const EdgeInsets.only(top: 8.0),
                  child: Text(Utils.getFirstWords(articles[index].description) + '...'),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ArticleDetailPage(articles[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  // ==========================
  // Lógica
  // ==========================
  void getArticles() async {
    try {
      http.Response response = await http.get(Uri.parse('https://ihc.gil.com.uy/api/articles'));
      data = json.decode(response.body);
      articlesData = data?['articles'];

      if (articlesData != null) {
        final List<Article> newArticles = articlesData!
            .map((a) => Article(
          type: a['category'] as String,
          title: a['title'] as String,
          description: a['description'] as String,
          articleUrl: a['articleUrl'] as String,
          content: a['content'] as String,
          timestamp: a['timestamp'] as String,
        )).toList();

        setState(() {
          articles = newArticles;
          articles.sort((a, b) => (DateTime.parse(b.timestamp).millisecondsSinceEpoch)
              .compareTo(DateTime.parse(a.timestamp).millisecondsSinceEpoch)
          );
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> refreshList() async {
    await http.get(Uri.parse('https://ihc.gil.com.uy/api/articles/create'));
    getArticles();
  }
}