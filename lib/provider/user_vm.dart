import 'package:flutter/material.dart';
import 'package:szaman_chat/data/models/user_model.dart';
import 'package:szaman_chat/data/repositories/coworker_repos.dart';

class UserViewModel with ChangeNotifier {
  final _cwRepos = CoworkerRepos();
  Future<Map<String, UserModel>?> getInfo(String token) async {
    final cwRepos = await _cwRepos.getUsersInfo(token);

    return cwRepos;
  }
}
