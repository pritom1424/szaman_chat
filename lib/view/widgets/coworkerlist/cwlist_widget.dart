import 'package:flutter/material.dart';
import 'package:szaman_chat/data/models/user_model.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';
import 'package:szaman_chat/view/widgets/coworkerlist/cwlist_template.dart';

class CwlistWidget extends StatelessWidget {
  final Map<String, UserModel> uModel;
  final List<String>? fid;
  const CwlistWidget({super.key, required this.uModel, required this.fid});

  @override
  Widget build(BuildContext context) {
    List<String> friendListID = fid ?? [];
    /*  List<Map<String, dynamic>> data = [
      {
        "uId": "0",
        "username": "user0",
        "imageUrl":
            "https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png",
      },
      {
        "uId": "2",
        "username": "user2",
        "imageUrl":
            "https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png",
      },
      {
        "uId": "3",
        "username": "user3",
        "imageUrl":
            "https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png",
      },
      {
        "uId": "4",
        "username": "user4",
        "imageUrl":
            "https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png",
      },
    ]; */
    final meNameMod = uModel[Usercredential.id];

    return (uModel.length - 1 == friendListID.length)
        ? const Center(
            child: Text("No employee is remained to add!"),
          )
        : ListView.builder(
            itemCount: uModel.length,
            itemBuilder: (ctx, ind) => (uModel.keys.toList()[ind] ==
                        Usercredential.id ||
                    friendListID.any((id) => id == uModel.keys.toList()[ind]))
                ? const SizedBox.shrink()
                : CwlistTemplate(
                    token: uModel.entries.toList()[ind].value.token,
                    uid: uModel.keys.toList()[ind],
                    imageURL: uModel.entries.toList()[ind].value.imageUrl,
                    userName: uModel.entries.toList()[ind].value.name,
                    isAdmin:
                        uModel.entries.toList()[ind].value.isAdmin ?? false,
                    meName: meNameMod?.name ?? "Me",
                  ));
  }
}
