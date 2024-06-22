import 'dart:convert';

import 'package:szaman_chat/data/models/message_model.dart';
import 'package:szaman_chat/utils/constants/api_links.dart';
import 'package:http/http.dart' as http;

class InboxRepos {
  Future<bool> addMessage(
      String token, MessageModel mModel, String uid, String fid) async {
    var params = {'auth': token};

    try {
      final url =
          Uri.https(ApiLinks.baseUrl, '/messages/$uid/$fid.json', params);

      final bodyData = messageModelToJson(mModel);
      final friendModel = MessageModel(
          createdAt: mModel.createdAt,
          message: mModel.message,
          imageUrl: mModel.imageUrl,
          isImageExist: mModel.isImageExist,
          isDeleted: mModel.isDeleted,
          senderID: uid,
          isME: false);
      final bodyDataFriend = messageModelToJson(friendModel);
      final urlfriend =
          Uri.https(ApiLinks.baseUrl, '/messages/$fid/$uid.json', params);

      final responseFriend = await http.post(urlfriend, body: bodyDataFriend);
      final response = await http.post(url, body: bodyData);

      if (response.statusCode == 200 && responseFriend.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error occured!: ${e.toString()}");
      rethrow;
    }
  }

  Future<Map<String, MessageModel>> getMessages(
      String token, String uid, String fid) async {
    print("message response ");
    var params = {
      'auth': token,
      'orderBy': '"createdAt"',
      'sortedBy': '"\$value"'
    };
    try {
      final url = Uri.https(
        ApiLinks.baseUrl,
        '/messages/$uid/$fid.json',
        params,
      );

      final response = await http.get(url);
      print("message response ${json.decode(response.body)}");

      if (response.statusCode == 200) {
        final messages = messagesModelFromJson(response.body);
        print("messages response1 $messages");
        return messages;
      } else {
        return {};
      }
    } catch (e) {
      print("Error occured!: ${e.toString()}");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getFriendIds(String userId, String token) async {
    try {
      var params = {'auth': token};

      final url = Uri.https(ApiLinks.baseUrl, '/messages/$userId.json', params);

      final response = await http.get(url);
      print("Chat list $response");
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print("Chat list $data");
        return data;
        // return data.keys.toList();
      } else {
        print("Failed to load friend IDs: ${response.statusCode}");
        throw Exception("Failed to load friend IDs: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
