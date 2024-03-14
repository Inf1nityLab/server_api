import 'dart:convert';

import 'news_model.dart';
import 'package:http/http.dart' as http;


class NewsApiService {
  final String _apiKey = 'f0c8f55bea4b4dae96b5423c5a9ac993'; // Replace with your News API key
  final String _baseUrl = 'https://newsapi.org/v2/';

  Future<List<Article>> getHeadlines({String category = 'business'}) async {
    final Uri url = Uri.parse(_baseUrl + 'top-headlines?apiKey=$_apiKey&category=$category');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final articles = jsonData['articles'] as List;

      // If using the model class:
      return articles.map((article) => Article.fromJson(article)).toList();

      // If not using the model class:
      // return articles.map((article) => article).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}