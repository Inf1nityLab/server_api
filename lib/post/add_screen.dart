import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {



  TextEditingController nameController = TextEditingController();
  TextEditingController jobController = TextEditingController();


  Future<User?> postData(String name, String job) async{
    var response = await http.post(Uri.https('reqres.in', '/api/users'), body: {'name': name, 'job': job});
    var data = response.body;
    print(data);

    if (response.statusCode == 201){
      String responseString = response.body;
      userFromJson(responseString );
    } else {
      throw Exception('Failed to load posts');
    };
  }

  User? _user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           TextField(
            controller: nameController,
            decoration:
                InputDecoration(border: OutlineInputBorder(), hintText: 'Name'),
          ),
           TextField(
            controller: jobController,
            decoration:
                InputDecoration(border: OutlineInputBorder(), hintText: 'Job'),
          ),
          ElevatedButton(
            onPressed: () async{


              User? data = await postData(nameController.text, jobController.text);

              setState(() {
                _user = data;
              });

            },
            child: const Text('Add data'),
          ),
        ],
      ),
    );
  }
}


