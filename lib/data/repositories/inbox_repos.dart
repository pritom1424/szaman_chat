import 'dart:convert';

import 'package:szaman_chat/data/models/message_model.dart';
import 'package:szaman_chat/data/models/user_model.dart';
import 'package:szaman_chat/utils/constants/api_links.dart';
import 'package:http/http.dart' as http;
import 'package:szaman_chat/utils/push_notification/firebase_push.dart';

class InboxRepos {
  Future<bool> addMessage(String token, MessageModel mModel, String uid,
      String fid, String userName) async {
    var params = {'auth': token};

    try {
      final url =
          Uri.https(ApiLinks.baseUrl, '/messages/$uid/$fid.json', params);

      final bodyData = messageModelToJson(mModel);
      final friendModel = MessageModel(
          isCallExit: mModel.isCallExit,
          createdAt: mModel.createdAt,
          message: mModel.message,
          imageUrl: mModel.imageUrl,
          isImageExist: mModel.isImageExist,
          isCalling: mModel.isCalling,
          isVideoOn: mModel.isVideoOn,
          senderID: uid,
          isME: false);
      final bodyDataFriend = messageModelToJson(friendModel);
      final urlfriend =
          Uri.https(ApiLinks.baseUrl, '/messages/$fid/$uid.json', params);

      final callURl =
          Uri.https(ApiLinks.baseUrl, '/call_log/$uid.json', params);
      final callURlFriend =
          Uri.https(ApiLinks.baseUrl, '/call_log/$fid.json', params);

//call log
      if (mModel.isCalling == true && mModel.isCallExit == false) {
        final respCall = await http.put(callURl,
            body: jsonEncode({"isCall": true, "isMe": true}));
        final respCallF = await http.put(callURlFriend,
            body: jsonEncode({"isCall": true, "isMe": false}));
      }

      if (mModel.isCalling == false && mModel.isCallExit == true) {
        final respCall = await http.put(callURl,
            body: jsonEncode({"isCall": false, "isMe": true}));
        final respCallF = await http.put(callURlFriend,
            body: jsonEncode({"isCall": false, "isMe": false}));
      }

      final responseFriend = await http.post(urlfriend, body: bodyDataFriend);
      final response = await http.post(url, body: bodyData);

      final fUrl = Uri.https(ApiLinks.baseUrl, '/users/$fid.json', params);

      final responseName = await http.get(fUrl);
      if (responseName.statusCode == 200) {
        final responseModel = UserModel.fromJson(jsonDecode(responseName.body));

        final dToken = responseModel.token;
        if (dToken != null && dToken != "default") {
          await FirebasePush().sendV1PushNotification(
              userName, mModel.message ?? "", uid, dToken);
        }
      }

      if (response.statusCode == 200 && responseFriend.statusCode == 200) {
        await lastMessageUpdate(uid, token, fid, true, mModel);
        await lastMessageUpdate(fid, token, uid, false, friendModel);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error occured!: ${e.toString()}");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCallLog(String uid, String token) async {
    var params = {'auth': token};
    final url = Uri.https(ApiLinks.baseUrl, '/call_log/$uid.json', params);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return {"error": "no respose"};
      }
    } catch (e) {
      return {"error": "no respose"};
    }
  }

  Future<Map<String, MessageModel>> getMessages(
      String token, String uid, String fid) async {
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

      if (response.statusCode == 200) {
        final messages = messagesModelFromJson(response.body);

        return messages;
      } else {
        return {};
      }
    } catch (e) {
      print("Error occured!: ${e.toString()}");
      rethrow;
    }
  }

  Future<void> lastMessageUpdate(String uid, String token, String fid,
      bool isSeen, MessageModel? mModel) async {
    var params = {'auth': token};
    final url = Uri.https(
      ApiLinks.baseUrl,
      '/last_messages/$uid/$fid.json',
      params,
    );
    if (mModel != null) {
      final body = {"communicate": isSeen, "message": mModel.toJson()};
      final responseFriend = await http.put(url, body: jsonEncode(body));
    } else {
      final body = {"communicate": isSeen};
      final responseFriend = await http.patch(url, body: jsonEncode(body));
    }
  }

  Future<Map<String, dynamic>> isLastMessageSeen(
      String uid, String fid, String token) async {
    var params = {'auth': token};
    try {
      final url = Uri.https(
        ApiLinks.baseUrl,
        '/last_messages/$uid/$fid.json',
        params,
      );

      final response = await http.get(url);
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;

      final model = MessageModel.fromJson(jsonResponse['message']);
      return {"communicate": jsonResponse['communicate'], 'message': model};
    } catch (e) {
      return {"error": "something went wrong!"};
    }
  }

  Future<Map<String, dynamic>> getFriendIds(String userId, String token) async {
    try {
      var params = {'auth': token};

      final url = Uri.https(ApiLinks.baseUrl, '/messages/$userId.json', params);

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

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
