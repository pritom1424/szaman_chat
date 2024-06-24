import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szaman_chat/data/models/profile_model.dart';
import 'package:szaman_chat/utils/components/app_component.dart';
import 'package:szaman_chat/utils/components/app_vars.dart';
import 'dart:io';

import 'package:szaman_chat/utils/constants/app_paths.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  bool isInit = false;
  final _usernameController = TextEditingController();
  String phoneNumber = "";

  ProfileModel? profileModel;

  String? token, id;
  @override
  void initState() {
    isInit = false;

    // TODO: implement initState
    super.initState();
  }

  void _saveProfile(WidgetRef ref) async {
    // Save profile changes (you caan replace this with actual saving logic)
    final username = _usernameController.text;
    //final phone = _emailController.text;
    final phone = phoneNumber;
    final profileImage = ref.read(profileViewModel).storedImage;
    FocusScope.of(context).unfocus();
    ref.watch(profileViewModel).setIsLoading(true);

    final message = await ref
        .read(authViewModel)
        .update(Usercredential.token!, phone, username, profileImage);

    // Show a success message
    ref.read(profileViewModel).setIsLoading(false);
    ref.watch(profileViewModel).setEditBool(false);
    isInit = false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (Usercredential.id == null || Usercredential.token == null)
        ? const Center(
            child: Text("Access Denied!"),
          )
        : Consumer(builder: (ctx, ref, _) {
            final refProv = ref.read(profileViewModel);

            if (!isInit) {
              print('first init');
              return FutureBuilder(
                  future: refProv.getInfo(
                      Usercredential.token!, Usercredential.id!),
                  builder: (ctx, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: AppVars.screenSize.height,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (!snap.hasData) {
                      return const Center(
                        child: Text("no data found"),
                      );
                    }
                    print("first init reah");
                    isInit = true;

                    profileModel = snap.data;

                    return profileBody(context, ref);
                  });
            }

            return profileBody(context, ref);
          });
  }

  Widget profileBody(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Center(
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      (ref.read(profileViewModel).storedImage != null)
                          ? FileImage(ref.read(profileViewModel).storedImage!)
                          : (profileModel!.imageUrl != null ||
                                  profileModel!.imageUrl!.isNotEmpty)
                              ? NetworkImage(profileModel!.imageUrl!)
                              : AssetImage(AppPaths.charplaceholderPath)
                                  as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () async {
                      File? selectedFile =
                          await AppComponent.selectpictureAlert(context);
                      phoneNumber = profileModel?.phone ?? "";
                      _usernameController.text = profileModel?.name ?? "";
                      ref.watch(profileViewModel).setStoreImage(selectedFile);
                      ref.read(profileViewModel).setEditBool(true);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text("phone:${profileModel?.phone ?? ""}"),
          const SizedBox(height: 16),
          (ref.read(profileViewModel).isEditMode)
              ? TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Edit Name'),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(profileModel?.name ?? "no name"),
                    IconButton(
                        onPressed: () {
                          phoneNumber = profileModel?.phone ?? "";
                          _usernameController.text = profileModel?.name ?? "";
                          ref.watch(profileViewModel).setEditBool(true);
                        },
                        icon: const Icon(Icons.edit))
                  ],
                ),

          /* (ref.read(profileViewModel).isEditMode)
              ? Text(
                  phoneNumber) /* TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ) */
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(profileModel?.phone ?? ""),
                    IconButton(
                        onPressed: () {
                          phoneNumber = profileModel?.phone ?? "";
                          _usernameController.text = profileModel?.name ?? "";

                          ref.watch(profileViewModel).setEditBool(true);
                        },
                        icon: const Icon(Icons.edit))
                  ],
                ), */
          if (ref.read(profileViewModel).isEditMode) const SizedBox(height: 16),
          if (ref.read(profileViewModel).isEditMode)
            ElevatedButton(
              onPressed: (ref.read(profileViewModel).isLoading)
                  ? null
                  : () {
                      _saveProfile(ref);
                    },
              child: const Text('Save Changes'),
            ),
          const SizedBox(
            height: 20,
          ),
          (ref.read(profileViewModel).isLoading)
              ? const Center(
                  child: CircularProgressIndicator(
                      //  color: Appcolors.contentColorPurple,
                      ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
