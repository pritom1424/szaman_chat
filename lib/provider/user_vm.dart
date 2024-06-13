import 'package:flutter/material.dart';
import 'package:szaman_chat/data/models/message_model.dart';
import 'package:szaman_chat/data/models/user_model.dart';
import 'package:szaman_chat/data/repositories/coworker_repos.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';

class UserViewModel with ChangeNotifier {
  final _cwRepos = CoworkerRepos();
  Future<Map<String, UserModel>?> getInfo(String token) async {
    final cwRepos = await _cwRepos.getUsersInfo(token);

    return cwRepos;
  }

  Future<bool> addFriend(MessageModel mModel, String fid) async {
    if (Usercredential.id == null || Usercredential.token == null) {
      return false;
    }
    final didSuccess = await _cwRepos.addFriend(
        Usercredential.id!, fid, Usercredential.token!, mModel);
    return didSuccess;
  }
}
