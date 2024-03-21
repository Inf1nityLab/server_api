
import 'package:http/http.dart' as http;
import 'model.dart';

class ApiClient{


  Future<User?> postData(String name, String job) async{
    var response = await http.post(Uri.https('reqres.in', '/api/users'), body: {'name': name, 'job': job});
    var data = response.body;
    print(data);

    if (response.statusCode == 201){
      String responseString = response.body;
      userFromJson(responseString);
    } else {
      throw Exception('Failed to load posts');
    };
  }
}