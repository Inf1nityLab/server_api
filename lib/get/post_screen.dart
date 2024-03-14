import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:server_data/get/post_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Post>>? futurePosts;


  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.https('jsonplaceholder.typicode.com', 'posts'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Post.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: Center(
        child: FutureBuilder<List<Post>>(
          future: futurePosts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final post = snapshot.data![index];
                  return Container(
                    height: 200,
                    color: Colors.tealAccent,
                    margin: const EdgeInsets.all(20),
                    child: ListTile(
                      title: Text('$index - title: ${post.title}'),
                      subtitle: Text('body: ${post.body}'),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // Display a loading indicator while waiting for data
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}