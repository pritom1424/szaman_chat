import 'dart:async';

import 'package:flutter/material.dart';
import 'package:szaman_chat/data/models/message_model.dart';
import 'package:szaman_chat/data/repositories/inbox_repos.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';

class InboxPageVm with ChangeNotifier {
  String _inputText = "";

  bool _isDocUploading = false;
  bool _isImagePicking = false;

  final _inboxRepos = InboxRepos();

  bool? _isImageExist;

  String get inputText {
    return _inputText;
  }

  bool get isImagePicking {
    return _isImagePicking;
  }

  bool? get IsImageExist {
    return _isImageExist;
  }

  bool get isDocUploading {
    return _isDocUploading;
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

  Future<int> getCallStatus() async {
    if (Usercredential.token == null || Usercredential.id == null) {
      return 2;
    }
    final result =
        await _inboxRepos.getCallLog(Usercredential.id!, Usercredential.token!);

    if (result['error'] != null) {
      return 3;
    } else if (result['isCall'] == true) {
      return (result['isMe'] == false) ? 1 : 2;
    }
    return 0;
    //3 error
    //1 got a call already
    // 2 make a call;
    // 0 free
  }

  Stream<int> getCallStatusStream() {
    return Stream.periodic(const Duration(milliseconds: 1000))
        .asyncMap((_) async {
      if (Usercredential.token == null || Usercredential.id == null) {
        return 2;
      }
      try {
        final result = await _inboxRepos.getCallLog(
            Usercredential.id!, Usercredential.token!);
        if (result['error'] != null) {
          return 3;
        } else if (result['isCall'] == true) {
          return (result['isMe'] == false) ? 1 : 2;
        }
        return 0;
      } catch (e) {
        return 3;
      }
    });
  }

  Future<void> lastMessageUpdate(String fid, bool isSeen) async {
    if (Usercredential.id == null || Usercredential.token == null) {
      return;
    }
    await _inboxRepos.lastMessageUpdate(
        Usercredential.id!, Usercredential.token!, fid, isSeen, null);
  }

  Stream<List<MessageModel>> getAllMessagesStream(
      String token, String uid, String fid) {
    return Stream.periodic(const Duration(milliseconds: 100))
        .asyncMap((_) async {
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

  Stream<List<String>> getFriendIDsStream(String uid) {
    StreamController<List<String>> controller = StreamController();
    Timer? timer;

    controller = StreamController<List<String>>.broadcast(
      onListen: () {
        if (Usercredential.token == null) {
          controller.add([]);
          return;
        }

        List<String> lastFriendIDs = [];

        timer = Timer.periodic(const Duration(seconds: 2), (Timer t) async {
          try {
            final mapData =
                await _inboxRepos.getFriendIds(uid, Usercredential.token!);
            List<String> currentFriendIDs = mapData.keys.toList();

            if (currentFriendIDs != lastFriendIDs) {
              lastFriendIDs = currentFriendIDs;
              controller.add(currentFriendIDs);
            }
          } catch (e) {
            print("Error occurred: ${e.toString()}");
            controller.addError(e);
          }
        });
      },
      onCancel: () {
        timer?.cancel();
        controller.close();
      },
    );

    return controller.stream;
  }

  Future<Map<String, dynamic>> islastMessageSeen(
    String fid,
  ) async {
    if (Usercredential.id == null || Usercredential.token == null) {
      return {};
    }
    final res = await _inboxRepos.isLastMessageSeen(
        Usercredential.id!, fid, Usercredential.token!);
    if (res['error'] != null) {
      return {};
    }

    return res;
  }

  Stream<Map<String, dynamic>> isLastMessageSeenStream(String fid) {
    return Stream.periodic(const Duration(milliseconds: 100))
        .asyncMap((_) async {
      if (Usercredential.id == null || Usercredential.token == null) {
        return {};
      }

      try {
        final res = await _inboxRepos.isLastMessageSeen(
            Usercredential.id!, fid, Usercredential.token!);
        if (res['error'] != null) {
          return {};
        }

        return res;
      } catch (e) {
        return {};
      }
    });
  }

  Future<List<String>> getFriendIDs(String uid) async {
    if (Usercredential.token == null) {
      return [];
    }
    final mapData = await _inboxRepos.getFriendIds(uid, Usercredential.token!);

    return mapData.keys.toList();
  }
}
