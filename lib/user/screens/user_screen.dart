import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../model/user_model.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  Future<List<UserModel>>? _userModel;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<List<UserModel>> getData() async {
    final response = await http.get(Uri.parse(
        'https://65f97f2bdf1514524611cbd0.mockapi.io/api/to_do/Users'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => UserModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> postData(String name, String email, String password) async {
    final body =
        jsonEncode({'name': name, 'email': email, 'password': password});
    final response = await http.post(
      Uri.parse('https://65f97f2bdf1514524611cbd0.mockapi.io/api/to_do/Users'),
      body: body,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Данные успешно добавлены!')),
      );
      setState(() {
        _userModel = getData();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${response.statusCode}')),
      );
    }
  }

  Future<void> deleteData(String id) async {
    final response = await http.delete(Uri.parse(
        'https://65f97f2bdf1514524611cbd0.mockapi.io/api/to_do/Users/$id'));

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Данные успешно удалены')),
      );
      setState(() {
        _userModel = getData();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${response.statusCode}')),
      );
    }
  }

  Future<void> putData(
      String name, String email, String password, String id) async {
    final body =
        jsonEncode({'name': name, 'email': email, 'password': password});
    final response = await http.put(
      Uri.parse(
          'https://65f97f2bdf1514524611cbd0.mockapi.io/api/to_do/Users/$id'),
      body: body,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Данные успешно обнавлены!')),
      );
      setState(() {
        _userModel = getData();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${response.statusCode}')),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userModel = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<UserModel>>(
        future: _userModel,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return GestureDetector(
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title:
                                const Text('Вы реально хотите удалить данные?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Нет')),
                              TextButton(
                                  onPressed: () async {
                                    await deleteData(user.id);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Да')),
                            ],
                          );
                        });
                  },
                  child: Container(
                    height: 100,
                    color: Colors.tealAccent,
                    margin: const EdgeInsets.all(20),
                    child: ListTile(
                      leading: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Update User info'),
                                  content: Container(
                                    height: 200,
                                    child: Column(
                                      children: [
                                        textFieldWidget('Name', nameController),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        textFieldWidget(
                                            'Email', emailController),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        textFieldWidget(
                                            'Password', passwordController)
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() async {
                                          if (nameController.text.isNotEmpty &&
                                              emailController.text.isNotEmpty &&
                                              passwordController
                                                  .text.isNotEmpty) {
                                            await putData(
                                                nameController.text,
                                                emailController.text,
                                                passwordController.text,
                                                user.id);
                                            Navigator.pop(context);
                                            nameController.clear();
                                            emailController.clear();
                                            passwordController.clear();
                                          }
                                        });
                                      },
                                      child: const Text('Add data'),
                                    ),
                                  ],
                                );
                              });
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      title: Text('Name: ${user.name}'),
                      subtitle: Text('Email: ${user.email}'),
                      trailing: Text('Password : ${user.password}'),
                    ),
                  ),
                );
              },
            );
          }

          // Display a loading indicator while waiting for data
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Add User info'),
                  content: Container(
                    height: 200,
                    child: Column(
                      children: [
                        textFieldWidget('Name', nameController),
                        const SizedBox(
                          height: 10,
                        ),
                        textFieldWidget('Email', emailController),
                        const SizedBox(
                          height: 10,
                        ),
                        textFieldWidget('Password', passwordController)
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() async {
                          if (nameController.text.isNotEmpty &&
                              emailController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty) {
                            await postData(nameController.text,
                                emailController.text, passwordController.text);
                            Navigator.pop(context);
                            nameController.clear();
                            emailController.clear();
                            passwordController.clear();
                          }
                        });
                      },
                      child: const Text('Add data'),
                    ),
                  ],
                );
              });
        },
        child: const Icon(Icons.add_box),
      ),
    );
  }

  Widget textFieldWidget(
      String text, TextEditingController textEditingController) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: text,
      ),
    );
  }
}
