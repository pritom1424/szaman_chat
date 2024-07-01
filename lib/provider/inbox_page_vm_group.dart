import 'package:flutter/material.dart';
import 'package:szaman_chat/data/models/message_model.dart';
import 'package:szaman_chat/data/repositories/inbox_repos_group.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';

class InboxPageVmGroup with ChangeNotifier {
  String _inputText = "";

  final _inboxRepos = InboxReposGroup();

  bool? _isImageExist;
  bool _isDocUploading = false;
  bool _isImagePicking = false;
  bool get isImagePicking {
    return _isImagePicking;
  }

  bool get isDocUploading {
    return _isDocUploading;
  }

  String get inputText {
    return _inputText;
  }

  bool? get IsImageExist {
    return _isImageExist;
  }

  void setIsDocLoading(bool isLoad) {
    _isDocUploading = isLoad;
    notifyListeners();
  }

  void setImagePicking(bool pickImage) {
    _isImagePicking = pickImage;
    notifyListeners();
  }

  void setImageExist(bool? isExist) {
    _isImageExist = isExist;
    notifyListeners();
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

  Future<bool> addMember(String gID, String gName, String fID) async {
    try {
      if (Usercredential.id != null || Usercredential.token != null) {
        final didSuccess = await _inboxRepos.addToGroup(
            Usercredential.token!, gID, fID, gName);
        if (didSuccess) {
          return true;
        }
        return false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<List<MessageModel>> getAllMessages(String token, String gid) async {
    try {
      final data = await _inboxRepos.getMessages(token, gid);
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

  Stream<List<MessageModel>> getAllMessagesStream(String token, String gid) {
    return Stream.periodic(const Duration(milliseconds: 100))
        .asyncMap((_) async {
      try {
        final data = await _inboxRepos.getMessages(token, gid);
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

  Future<bool> islastMessageSeen(
    String gid,
  ) async {
    if (Usercredential.id == null || Usercredential.token == null) {
      return false;
    }
    final res = await _inboxRepos.isLastMessageSeen(
        Usercredential.id!, gid, Usercredential.token!);

    return res;
  }

  Future<void> lastMessageUpdate(String gid, bool isSeen) async {
    if (Usercredential.id == null || Usercredential.token == null) {
      return;
    }
    await _inboxRepos.lastMessageUpdate(
        Usercredential.id!, Usercredential.token!, gid, isSeen);
  }

  Future<List<String>> getGroupIDs(String uid) async {
    if (Usercredential.token == null) {
      return [];
    }
    final mapData = await _inboxRepos.getGroupIds(
        Usercredential.token!, uid); //getFriendIds(uid, Usercredential.token!);

    return mapData;
  }

  Future<List<String>> getGroupMembers(String gid) async {
    if (Usercredential.token == null) {
      return [];
    }
    final mapData = await _inboxRepos.getGroupMembers(
        Usercredential.token!, gid); //getFriendIds(uid, Usercredential.token!);

    return mapData;
  }

  Future<String> getGroupNameById(String gid) async {
    if (Usercredential.token == null || Usercredential.id == null) {
      return "";
    }
    final gName = await _inboxRepos.getGroupNameBYID(gid, Usercredential.token!,
        Usercredential.id!); //getFriendIds(uid, Usercredential.token!);

    return gName;
  }

  Future<String> createGroup(String groupName, MessageModel mModel) async {
    if (Usercredential.token == null || Usercredential.id == null) {
      return "";
    }
    return await _inboxRepos.createGroup(
        Usercredential.token!, groupName, Usercredential.id!, mModel);
  }
}
