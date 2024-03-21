import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: const Drawer(),
        backgroundColor: Colors.tealAccent,
        body: Column(
          children: [
            Container(
              height: 200,
              width: 200,
              color: Colors.red,
              child: SearchBar(),
            ),
            Text('Hello'),
            SearchBar(),
          ],
        ));
  }
}