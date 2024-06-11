import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:szaman_chat/data/models/user_model.dart';
import 'package:szaman_chat/utils/constants/api_links.dart';
import 'package:szaman_chat/utils/constants/data.dart';

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
}
