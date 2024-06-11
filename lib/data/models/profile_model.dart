// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  DateTime creatorId;
  String? email;
  String? imageUrl;
  bool? isAdmin;
  String? name;

  ProfileModel({
    required this.creatorId,
    required this.email,
    required this.imageUrl,
    required this.isAdmin,
    required this.name,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        creatorId: DateTime.parse(json["creatorId"]),
        email: json["email"],
        imageUrl: json["imageUrl"],
        isAdmin: json["isAdmin"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "creatorId": creatorId.toIso8601String(),
        "email": email,
        "imageUrl": imageUrl,
        "isAdmin": isAdmin,
        "name": name,
      };
}
