import 'package:szaman_chat/utils/constants/api_links.dart';
import 'package:http/http.dart' as http;

class InboxRepos {
  Future<void> addMessage(token) async {
    var params = {'auth': token};
    final url = Uri.https(ApiLinks.baseUrl, '/messages.json', params);

    final response = await http.post(url, body: {"text": "hi!"});

    /*  final url = Uri.https(
                'szaman-chat-default-rtdb.firebaseio.com', '/products.json');
            final response = await http.post(url,
                body: json.encode({
                  "title": "test",
                  "description": "test is a ...",
                  "imageUrl": "url",
                  "price": 100,
                  "creatorId": DateTime.now().toIso8601String(),
                })); */
  }
}
