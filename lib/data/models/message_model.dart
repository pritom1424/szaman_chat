// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

Map<String, MessageModel> messagesModelFromJson(String str) =>
    Map.from(json.decode(str)).map(
        (k, v) => MapEntry<String, MessageModel>(k, MessageModel.fromJson(v)));

String messagesModelToJson(Map<String, MessageModel> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

MessageModel messageModelFromJson(String str) =>
    MessageModel.fromJson(json.decode(str));

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
  final DateTime createdAt;
  final String? message;
  final String? imageUrl;
  final bool? isImageExist;
  final bool? isDeleted;
  final String? name;
  final String? friendName;
  final bool isME;

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
      createdAt: DateTime.parse(json["createdAt"]),
      message: json["message"],
      imageUrl: json["imageUrl"],
      isImageExist: json["isImageExist"],
      isDeleted: json["isDeleted"],
      name: json["name"],
      friendName: json['friendName'],
      isME: json['isME']);

  MessageModel(
      {required this.createdAt,
      required this.message,
      required this.imageUrl,
      required this.isImageExist,
      required this.isDeleted,
      required this.name,
      required this.friendName,
      required this.isME});

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt.toIso8601String(),
        "message": message,
        "imageUrl": imageUrl,
        "isImageExist": isImageExist,
        "isDeleted": isDeleted,
        "name": name,
        "friendName": friendName,
        "isME": isME
      };
}
