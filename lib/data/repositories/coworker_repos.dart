import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:szaman_chat/data/models/user_model.dart';
import 'package:szaman_chat/utils/constants/api_links.dart';
import 'package:szaman_chat/data/models/message_model.dart';

class CoworkerRepos {
  Future<Map<String, UserModel>?> getUsersInfo(String? token) async {
    if (token == null) {
      return null;
    }

    var params = {'auth': token};

    final url = Uri.https(ApiLinks.baseUrl, '/users.json', params);

    final response = await http.get(url);

    Map<String, UserModel> responseMap = {};
    if (response.statusCode == 200) {
      responseMap = userModelFromJson(response.body);
    }
    return responseMap;
  }

  Future<bool> addMessage(
      String token, MessageModel mModel, String uid, String fid) async {
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

  Future<bool> addFriend(
      String userId, String friendId, String token, MessageModel model) async {
    try {
      var params = {'auth': token};
      final url = Uri.https(
          ApiLinks.baseUrl, '/messages/$userId/$friendId.json', params);
      final isDone = await addMessage(token, model, userId, friendId);

      if (isDone) {
        return true;
        // return data.keys.toList();
      } else {
        print("Failed to load friend IDs");

        return false;
      }
    } catch (e) {
      print("error add friend ${e.toString()}");
      //rethrow;
      return false;
    }
  }
}
