// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

Map<String, UserModel> userModelFromJson(String str) =>
    Map.from(json.decode(str))
        .map((k, v) => MapEntry<String, UserModel>(k, UserModel.fromJson(v)));

String userModelToJson(Map<String, UserModel> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class UserModel {
  DateTime creatorId;

  String? imageUrl;
  bool? isAdmin;
  String? name;
  String? phone;
  String? token;

  UserModel({
    required this.creatorId,
    required this.imageUrl,
    required this.isAdmin,
    required this.name,
    required this.phone,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        creatorId: DateTime.parse(json["creatorId"]),
        phone: json["phone"],
        imageUrl: json["imageUrl"],
        isAdmin: json["isAdmin"],
        name: json["name"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "creatorId": creatorId.toIso8601String(),
        "phone": phone,
        "imageUrl": imageUrl,
        "isAdmin": isAdmin,
        "name": name,
        "token": token
      };
}
