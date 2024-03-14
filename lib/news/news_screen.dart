import 'package:flutter/material.dart';
import 'package:server_data/news/service.dart';
import 'news_model.dart';

class MyNewsApp extends StatefulWidget {
  const MyNewsApp({super.key});

  @override
  State<MyNewsApp> createState() => _MyNewsAppState();
}

class _MyNewsAppState extends State<MyNewsApp> {
  NewsApiService newsService = NewsApiService();
  List<Article>? articles;

  @override
  void initState() {
    super.initState();
    _getHeadlines();
  }

  Future<void> _getHeadlines() async {
    try {
      final fetchedArticles = await newsService.getHeadlines();
      setState(() {
        articles = fetchedArticles; // If using the model class
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My News App'),
      ),
      body: articles != null
          ? ListView.builder(
              itemCount: articles!.length, // If using the model class
              itemBuilder: (context, index) =>
                  _articleCard(articles![index]), // If using the model class
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _articleCard(Article article) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          article.urlToImage.isNotEmpty
              ? Container(
                  height: 400,
                  width: double.infinity,
                  child: Image.network(
                    "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg",
                  ),
                )
              : Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(child: Text('No image available')),
                ),
          const SizedBox(height: 10),
          Text(
            article.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(article.description),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
