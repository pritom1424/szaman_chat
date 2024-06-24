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
  final bool? isCalling;
  final bool? isCallExit;
  final String? senderID;
  // final String? name;
  //final String? friendName;
  final bool isME;

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
      createdAt: DateTime.parse(json["createdAt"]),
      message: json["message"],
      imageUrl: json["imageUrl"],
      isImageExist: json["isImageExist"],
      isCalling: json["isCalling"],
      senderID: json["senderID"],
      isCallExit: json["isCallExit"],
      isME: json['isME']);

  MessageModel(
      {required this.isCallExit,
      required this.createdAt,
      required this.message,
      required this.imageUrl,
      required this.isImageExist,
      required this.isCalling,
      required this.senderID,
      required this.isME});

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt.toIso8601String(),
        "message": message,
        "imageUrl": imageUrl,
        "isImageExist": isImageExist,
        "isCalling": isCalling,
        "senderID": senderID,
        "isCallExit": isCallExit,
        "isME": isME
      };
}
/*

// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

Map<String, UserModel> userModelFromJson(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, UserModel>(k, UserModel.fromJson(v)));

String userModelToJson(Map<String, UserModel> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class UserModel {
    DateTime createdAt;
    String friendName;
    String imageUrl;
    bool isDeleted;
    bool isImageExist;
    bool isMe;
    String message;
    String name;

    UserModel({
        required this.createdAt,
        required this.friendName,
        required this.imageUrl,
        required this.isDeleted,
        required this.isImageExist,
        required this.isMe,
        required this.message,
        required this.name,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        createdAt: DateTime.parse(json["createdAt"]),
        friendName: json["friendName"],
        imageUrl: json["imageUrl"],
        isDeleted: json["isDeleted"],
        isImageExist: json["isImageExist"],
        isMe: json["isME"],
        message: json["message"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "createdAt": createdAt.toIso8601String(),
        "friendName": friendName,
        "imageUrl": imageUrl,
        "isDeleted": isDeleted,
        "isImageExist": isImageExist,
        "isME": isMe,
        "message": message,
        "name": name,
    };
}




 */