import 'dart:io';

import 'package:flutter/material.dart';
import 'package:szaman_chat/data/models/profile_model.dart';
import 'package:szaman_chat/data/repositories/profile_repos.dart';

class ProfileVm with ChangeNotifier {
  final ProfileRepos _profileRepos = ProfileRepos();
  bool _isEditMode = false;
  bool _isLoading = false;
  File? _storedImage;
  File? get storedImage {
    return _storedImage;
  }

  bool get isLoading {
    return _isLoading;
  }

  void setStoreImage(File? stImage) {
    _storedImage = stImage;
    notifyListeners();
  }

  void setIsLoading(bool isLoad) {
    _isLoading = isLoad;
    notifyListeners();
  }

  bool get isEditMode {
    return _isEditMode;
  }

  void setEditBool(bool isEd) {
    _isEditMode = isEd;
    notifyListeners();
  }

  Future<ProfileModel?> getInfo(String token, String uid) async {
    final profileData = await _profileRepos.getProfileInfo(token, uid);
    ProfileModel? profileModel;
    if (profileData.isEmpty) {
      profileModel = null;
    } else {
      profileModel = ProfileModel.fromJson(profileData);
    }
    return profileModel;
  }
}
