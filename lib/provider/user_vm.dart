import 'dart:ffi';

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

  Future<bool> updateStatus(bool status) async {
    if (Usercredential.id == null || Usercredential.token == null) {
      return false;
    }

    final updateState = _cwRepos.updateStatus(
        Usercredential.id!, Usercredential.token!, status);

    return updateState;
  }

  Future<List<dynamic>> getStatus(String fid) async {
    if (Usercredential.id == null || Usercredential.token == null) {
      return [];
    }
    final res = await _cwRepos.getStatus(fid, Usercredential.token!);
    if (res['error'] == null) {
      final bool status = res['status'] as bool;
      final DateTime dateTime = DateTime.parse(res['date']);
      final list = [status, dateTime];

      return list;
    }
    return [];
  }

  Stream<List<dynamic>> getStatusStream(String fid) {
    return Stream.periodic(const Duration(milliseconds: 1000))
        .asyncMap((_) async {
      if (Usercredential.id == null || Usercredential.token == null) {
        return [];
      }
      try {
        final res = await _cwRepos.getStatus(fid, Usercredential.token!);

        if (res['error'] == null) {
          final bool status = res['status'] as bool;
          final DateTime dateTime = DateTime.parse(res['date']);
          final list = [status, dateTime];
          return list;
        }
        return [];
      } catch (e) {
        return [];
      }
    });
  }
}
