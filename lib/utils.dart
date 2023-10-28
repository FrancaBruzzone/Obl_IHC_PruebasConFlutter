import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:obl_ihc_pruebasconflutter/views/loading.dart';

class Utils {
  static final googleCloudApiKey = 'AIzaSyC8lZz1_tMeY297wjg3WfcnAwykoAjnCig';

  static String removeDiacritics(String input) {
    return input.replaceAll(RegExp(r'[áÁ]'), 'a')
        .replaceAll(RegExp(r'[éÉ]'), 'e')
        .replaceAll(RegExp(r'[íÍ]'), 'i')
        .replaceAll(RegExp(r'[óÓ]'), 'o')
        .replaceAll(RegExp(r'[úÚ]'), 'u')
        .replaceAll(RegExp(r'[ñÑ]'), 'n');
  }

  static String getFirstWords(String content) {
    List<String> words = content.split(' ');
    if (words.length >= 20) {
      return words.sublist(0, 20).join(' ');
    } else {
      return content;
    }
  }

  static Icon getTypeArticle(String type) {
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

  static SnackBar getSnackBarError(message) {
    return SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 5),
      backgroundColor: Colors.red,
    );
  }

  static Future<String> translateToSpanish(String text) async {
    final endpoint = 'https://translation.googleapis.com/language/translate/v2';

    final response = await http.post(
      Uri.parse('$endpoint?key=$googleCloudApiKey'),
      body: {
        'q': text,
        'target': 'es',
      },
    );

    if (response.statusCode == 200) {
      final translatedText = json.decode(response.body)['data']['translations'][0]['translatedText'];
      return translatedText;
    } else {
      return text;
    }
  }

  static Dialog getLoaderDialog() {
    return Dialog(
      child: Container(
        width: 80,
        height: 80,
        color: Colors.white.withOpacity(0.1),
        child: LoadingIndicator(),
      ),
    );
  }
}