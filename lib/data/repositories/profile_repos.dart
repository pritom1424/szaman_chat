import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:szaman_chat/utils/constants/api_links.dart';
import 'package:szaman_chat/utils/constants/app_paths.dart';

class ProfileRepos {
  Future<Map<String, dynamic>> getProfileInfo(
      String? token, String? uid) async {
    if (token == null || uid == null) {
      return {'error': 'unauthorized access'};
    }
    print("uid $uid");
    print("toke $token");
    var params = {'auth': token};

    final url = Uri.https(ApiLinks.baseUrl, '/users/$uid.json', params);
    print("urlk ${url.toString()}"); //, params
    final response = await http.get(url);

    print("respose ${response.body}");
    Map<String, dynamic> responseMap = {};
    if (response.statusCode == 200) {
      responseMap = json.decode(response.body) as Map<String, dynamic>;
    }
    return responseMap;
  }
}
