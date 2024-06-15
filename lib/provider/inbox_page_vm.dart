import 'package:flutter/material.dart';
import 'package:szaman_chat/data/models/message_model.dart';
import 'package:szaman_chat/data/repositories/inbox_repos.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';

class InboxPageVm with ChangeNotifier {
  String _inputText = "";

  final _inboxRepos = InboxRepos();

  String get inputText {
    return _inputText;
  }

  void setInputText(String str) {
    _inputText = "";
    _inputText = str;
    notifyListeners();
  }

  Future<bool> addMessage(
      String token, MessageModel mModel, String uid, String fid) async {
    try {
      final didSuccess = await _inboxRepos.addMessage(token, mModel, uid, fid);
      if (didSuccess) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<MessageModel>> getAllMessages(
      String token, String uid, String fid) async {
    try {
      final data = await _inboxRepos.getMessages(token, uid, fid);
      List<MessageModel> messages = [];
      if (data.isEmpty) {
        return [];
      }
      data.forEach((key, val) {
        messages.add(val);
      });

      return messages;
    } catch (e) {
      return [];
    }
  }

  Stream<List<MessageModel>> getAllMessagesStream(
      String token, String uid, String fid) {
    return Stream.periodic(const Duration(seconds: 2)).asyncMap((_) async {
      try {
        final data = await _inboxRepos.getMessages(token, uid, fid);
        List<MessageModel> messages = [];
        if (data.isEmpty) {
          return [];
        }
        data.forEach((key, val) {
          messages.add(val);
        });
        return messages;
      } catch (e) {
        return [];
      }
    });
  }

  Future<List<String>> getFriendIDs(String uid) async {
    if (Usercredential.token == null) {
      return [];
    }
    final mapData = await _inboxRepos.getFriendIds(uid, Usercredential.token!);
    print("friend ids ${mapData.keys.toList()}");

    return mapData.keys.toList();
  }
}
