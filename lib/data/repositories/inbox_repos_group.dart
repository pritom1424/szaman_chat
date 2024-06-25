import 'dart:convert';
import 'dart:ffi';

import 'package:szaman_chat/data/models/message_model.dart';
import 'package:szaman_chat/utils/constants/api_links.dart';
import 'package:http/http.dart' as http;

class InboxReposGroup {
  Future<String> createGroup(
      String token, String groupName, String uid, MessageModel mModel) async {
    var params = {'auth': token};
    final url = Uri.https(ApiLinks.baseUrl, '/group_messages.json', params);
    final bodyData = messageModelToJson(mModel);
    final response = await http.post(url, body: bodyData);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      String groupId = data['name'].toString();
      await addToGroup(token, groupId, uid, groupName);

      return groupId;
    }
    return "";
  }

  Future<bool> addToGroup(
      String token, String groupId, String uid, String groupName) async {
    var params = {'auth': token};
    try {
      final url =
          Uri.https(ApiLinks.baseUrl, '/group_ids/$uid/$groupId.json', params);
      final url1 = Uri.https(
          ApiLinks.baseUrl, '/group_members/$groupId/$uid.json', params);

      final body = {"groupName": groupName};
      final response = await http.post(url, body: jsonEncode(body));
      final response1 = await http.post(url1, body: jsonEncode(body));
      if (response.statusCode == 200 && response1.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error occured!: ${e.toString()}");
      rethrow;
    }
  }

  Future<List<String>> getGroupMembers(String token, String gid) async {
    var params = {'auth': token};
    try {
      final url =
          Uri.https(ApiLinks.baseUrl, '/group_members/$gid.json', params);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data.keys.toList();
      } else {
        throw Exception("Failed to load group IDs: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getGroupNameBYID(String gid, String token, String uid) async {
    var params = {'auth': token};
    final url =
        Uri.https(ApiLinks.baseUrl, '/group_members/$gid/$uid.json', params);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var val = json.decode(response.body) as Map<String, dynamic>;
      print("test: ${val.values.toList()[0]['groupName']}");
      return val.values.toList()[0]['groupName'];
    }
    return "";
  }

  Future<List<String>> getGroupIds(String token, String uid) async {
    var params = {'auth': token};
    try {
      final url = Uri.https(ApiLinks.baseUrl, '/group_ids/$uid.json', params);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data.keys.toList();
      } else {
        throw Exception("Failed to load group IDs: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addMessage(
      String token, MessageModel mModel, String uid, String gid) async {
    var params = {'auth': token};

    try {
      final url =
          Uri.https(ApiLinks.baseUrl, '/group_messages/$gid.json', params);

      final bodyData = messageModelToJson(mModel);

      //final responseFriend = await http.post(urlfriend, body: bodyDataFriend);
      final response = await http.post(url, body: bodyData);

      if (response.statusCode == 200) {
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
      String token, String gid) async {
    print("message response ");
    var params = {
      'auth': token,
      'orderBy': '"createdAt"',
      'sortedBy': '"\$value"'
    };
    try {
      final url = Uri.https(
        ApiLinks.baseUrl,
        '/group_messages/$gid.json',
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
}
