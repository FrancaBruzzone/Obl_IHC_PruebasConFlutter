import 'package:flutter/material.dart';
import 'package:obl_ihc_pruebasconflutter/entities/Article.dart';
import 'package:obl_ihc_pruebasconflutter/views/articledetail_page.dart';

class ArticlesPage extends StatelessWidget {
  final List<Article> articles = [
    Article(
      title: '¿Qué es la huella de carbono?',
      content: 'La huella de carbono representa el volumen total de gases de efecto invernadero (GEI) que producen las actividades económicas y cotidianas del ser humano. Conocer el dato —expresado en toneladas de CO2 emitidas— es importante para tomar medidas y poner en marcha las iniciativas necesarias para reducirla al máximo, empezando por cada uno de nosotros en nuestro día a día.',
      url: 'https://www.iberdrola.com/sostenibilidad/huella-de-carbono',
    ),
    Article(
      title: 'Qué es la era de la ebullición global',
      content: 'La era de la ebullición global es un término usado para referirse a la época actual caracterizada por temperaturas altas nunca vistas. Esta era fue determinada por el mes de julio con las tres semanas más calientes de los últimos 120 mil años, o lo que es lo mismo, el mes más caliente desde que se tienen registros del clima. Esto fue clasificado por la Organización Mundial de Meteorología y el Servicio Europeo Climático Copernicus como sin precedentes y notable, significando que no es algo normal y sobre lo que hay que poner atención.',
      url: 'https://www.ecologiaverde.com/era-de-la-ebullicion-global-que-es-consecuencias-y-soluciones-4550.html#:~:text=La%20era%20de%20la%20ebullici%C3%B3n%20global%20es%20un%20t%C3%A9rmino%20usado,por%20temperaturas%20altas%20nunca%20vistas.',
    ),
  ];

  String _getFirstWords(String content) {
    List<String> words = content.split(' ');
    if (words.length >= 20) {
      return words.sublist(0, 20).join(' ');
    } else {
      return content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(Icons.article, color: Colors.green),
              title: Text(articles[index].title),
              subtitle: Container(
                margin: EdgeInsets.only(top: 8.0),
                child: Text(_getFirstWords(articles[index].content) + '...'),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ArticleDetailPage(articles[index]),
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