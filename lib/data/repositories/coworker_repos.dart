
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

  Future<bool> addFriend(
      String userId, String friendId, String token, MessageModel model) async {
    try {
      var params = {'auth': token};
      final url = Uri.https(
          ApiLinks.baseUrl, '/messages/$userId/$friendId.json', params);
      final bodyData = messageModelToJson(model);
      final friendModel = MessageModel(
          createdAt: model.createdAt,
          message: model.message,
          imageUrl: model.imageUrl,
          isImageExist: model.isImageExist,
          isDeleted: model.isDeleted,
          name: model.name,
          friendName: model.friendName,
          isME: false);
      final bodyDataFriend = messageModelToJson(friendModel);
      final urlfriend = Uri.https(
          ApiLinks.baseUrl, '/messages/$friendId/$userId.json', params);
      final response = await http.post(url, body: bodyData);
      final responseFriend = await http.post(urlfriend, body: bodyDataFriend);

      if (response.statusCode == 200 && responseFriend.statusCode == 200) {
        return true;
        // return data.keys.toList();
      } else {
        print("Failed to load friend IDs: ${response.statusCode}");
        //throw Exception("Failed to load friend IDs: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("error add friend ${e.toString()}");
      //rethrow;
      return false;
    }
  }
}
