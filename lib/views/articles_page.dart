import 'package:flutter/material.dart';
import 'package:obl_ihc_pruebasconflutter/entities/Article.dart';
import 'package:obl_ihc_pruebasconflutter/views/articledetail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArticlesPage extends StatefulWidget {
  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  List<Article> articles = [];

  String _getFirstWords(String content) {
    List<String> words = content.split(' ');
    if (words.length >= 20) {
      return words.sublist(0, 20).join(' ');
    } else {
      return content;
    }
  }

  Map? data;
  List? articlesData;

  getArticles() async {
    http.Response response = await http.get(Uri.parse('https://ihc.gil.com.uy/api/articles'));
    data = json.decode(response.body);
    articlesData = data?['articles'];

    if (articlesData != null) {
      final List<Article> arts = articlesData!
        .map((a) => Article(
          type: a['category'] as String,
          title: a['title'] as String,
          description: a['description'] as String,
          articleUrl: a['articleUrl'] as String,
          content: a['content'] as String,
        )).toList();

      setState(() {
        articles = arts;
      });
    }
  }

  createArticles() async {
    await http.get(Uri.parse('https://ihc.gil.com.uy/api/articles/create'));
  }

  Future<void> _refreshList() async {
    await createArticles();
    getArticles();
  }

  Icon getTypeArticle(String type) {
    switch (type) {
      case "event":
        return const Icon(Icons.event, color: Colors.green);
      case "article":
        return const Icon(Icons.article, color: Colors.green);
      case "message":
        return const Icon(Icons.message, color: Colors.green);
      case "emergency":
        return const Icon(Icons.emergency, color: Colors.green);
      case "podcast":
        return const Icon(Icons.podcasts, color: Colors.green);
      case "warning":
        return const Icon(Icons.warning, color: Colors.green);
      case "recycling":
        return const Icon(Icons.recycling, color: Colors.green);
      default:
        return const Icon(Icons.article, color: Colors.green);
    }
  }

  @override
  initState() {
    super.initState();
    getArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshList,
        child: ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: getTypeArticle(articles[index].type! ),
                title: Text(articles[index].title),
                subtitle: Container(
                  margin: const EdgeInsets.only(top: 8.0),
                  child: Text(_getFirstWords(articles[index].description) + '...'),
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
}