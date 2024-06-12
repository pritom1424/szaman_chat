import 'dart:convert';

import 'package:szaman_chat/data/models/message_model.dart';
import 'package:szaman_chat/utils/constants/api_links.dart';
import 'package:http/http.dart' as http;
import 'package:szaman_chat/utils/constants/app_paths.dart';

class InboxRepos {
  Future<bool> addMessage(
      String token, MessageModel mModel, String uid, String fid) async {
    var params = {'auth': token};

    try {
      final url =
          Uri.https(ApiLinks.baseUrl, '/messages/$uid/$fid.json', params);

      final response = await http.put(url, body: messageModelToJson(mModel));
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
      String token, String uid, String fid) async {
    var params = {'auth': token};

    try {
      final url = Uri.https(
        ApiLinks.baseUrl,
        '/messages/$uid/$fid.json',
        {'orderBy': '"createdAt"', 'sortedBy': '"\$value"', ...params},
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final messages = messagesModelFromJson(json.encode(response.body));
        return messages;
      } else {
        return {};
      }
    } catch (e) {
      print("Error occured!: ${e.toString()}");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getFriendIds(String userId) async {
    try {
      final url = "${ApiLinks.baseUrl}/messages/$userId.json";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
        // return data.keys.toList();
      } else {
        throw Exception("Failed to load friend IDs: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
