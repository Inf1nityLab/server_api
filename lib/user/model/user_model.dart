// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String name;
  String email;
  String password;
  String id;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.id,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json["name"] ?? 'No Data',
    email: json["email"] ?? 'No Data',
    password: json["password"] ?? 'No Data',
    id: json["id"] ?? 'No Data',
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "password": password,
    "id": id,
  };
}