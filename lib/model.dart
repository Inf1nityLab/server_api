import 'dart:convert';

PostData postDataFromJson(String str) => PostData.fromJson(json.decode(str));

String postDataToJson(PostData data) => json.encode(data.toJson());

class PostData {
  String name;
  String job;
  String id;
  DateTime createdAt;

  PostData({
    required this.name,
    required this.job,
    required this.id,
    required this.createdAt,
  });

  factory PostData.fromJson(Map<String, dynamic> json) => PostData(
    name: json["name"],
    job: json["job"],
    id: json["id"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "job": job,
    "id": id,
    "createdAt": createdAt.toIso8601String(),
  };
}