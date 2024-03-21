import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final nameTextField = TextEditingController();
  final phoneTextField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить данные'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            TextField(
              controller: nameTextField,
              decoration: const InputDecoration(hintText: 'Введите имя'),
            ),
            TextField(
              controller: phoneTextField,
              decoration: const InputDecoration(hintText: 'Введите номер телефона'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameTextField.text;
                final phone = phoneTextField.text;

                final body = jsonEncode({'name': name, 'contact': phone});

                final response = await http.post(
                  Uri.parse('https://65f97f2bdf1514524611cbd0.mockapi.io/api/to_do/Contacts'),
                  body: body,
                  headers: {'Content-Type': 'application/json'},
                );

                if (response.statusCode == 201) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Данные успешно добавлены!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка: ${response.statusCode}')),
                  );
                }
              },
              child: const Text('Добавить'),
            ),
          ],
        ),
      ),
    );
  }
}