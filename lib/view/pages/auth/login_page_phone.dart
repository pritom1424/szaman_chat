import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szaman_chat/utils/components/app_component.dart';

import 'package:szaman_chat/utils/components/app_vars.dart';
import 'package:szaman_chat/utils/constants/app_colors.dart';
import 'package:szaman_chat/utils/constants/app_paths.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';
import 'package:szaman_chat/view/pages/nav_page.dart';

class LoginPhoneForm extends StatefulWidget {
  final String? title;
  const LoginPhoneForm({super.key, this.title});

  @override
  State<LoginPhoneForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<LoginPhoneForm> {
/*   TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController otpController = TextEditingController(); */
  Color actionButtonBgColor = const Color.fromARGB(255, 68, 156, 204);
  Color actionButtonFgColor = Colors.white;
  final _formInfoKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    /*  
    mobileController.dispose();
    nameController.dispose();
    otpController.dispose(); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (widget.title == null)
          ? null
          : AppBar(
              title: Text(widget.title!),
            ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(8),
          color: Colors.white,
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Consumer(builder: (ctx, ref, _) {
              return Container(
                //  height: AppVars.screenSize.height * 1,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Form(
                  key: _formInfoKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            AppPaths.applogoPath,
                            width: AppVars.screenSize.width *
                                0.6, // Adjust as needed
                            height: AppVars.screenSize.height * 0.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        child: Consumer(
                          builder: (ctx, ref, _) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: (ref
                                            .read(authViewModel)
                                            .storedImage !=
                                        null)
                                    ? FileImage(
                                        ref.read(authViewModel).storedImage!)
                                    : AssetImage(AppPaths.charplaceholderPath)
                                        as ImageProvider,
                              ),
                              if ((!ref.read(authViewModel).isMessageSent))
                                TextButton(
                                  onPressed: () async {
                                    File? selectedFile =
                                        await AppComponent.selectpictureAlert(
                                            context);

                                    ref
                                        .watch(authViewModel)
                                        .setStoreImage(selectedFile);
                                  },
                                  child: Text(
                                    (ref.read(authViewModel).storedImage ==
                                            null)
                                        ? "Add Profile Picture"
                                        : "Update Profile Picture",
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        readOnly: (ref.read(authViewModel).isMessageSent)
                            ? true
                            : false,
                        //focusNode: emailFocusNode,
                        controller: ref.read(authViewModel).nameController,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                        //autofocus: false,
                        enabled: true,
                        decoration: const InputDecoration(
                          errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.3)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.3)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.3)),
                          hintText: 'Name',
                          labelText: 'Name',
                          labelStyle:
                              TextStyle(fontSize: 18, color: Colors.grey),
                          prefixIcon: Icon(Icons.person, color: Colors.grey),
                        ),
                        validator: (value) {
                          if (value != null && value == "") {
                            return "Name error";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        readOnly: (ref.read(authViewModel).isMessageSent)
                            ? true
                            : false,
                        //focusNode: emailFocusNode,
                        controller: ref.read(authViewModel).mobileController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                        //autofocus: false,
                        enabled: true,
                        decoration: const InputDecoration(
                          errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.3)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.3)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.3)),
                          hintText: 'Phone',
                          labelText: 'Phone',
                          labelStyle:
                              TextStyle(fontSize: 18, color: Colors.grey),
                          prefixIcon:
                              Icon(Icons.phone_android, color: Colors.grey),
                        ),
                        validator: (value) {
                          if (value != null && value == "") {
                            return "Phone error";
                          }
                          return null;
                        },
                      ),
                      /*  if (!ref.read(authViewModel).isMessageSent)
                        const SizedBox(height: 20),
                      if (!ref.read(authViewModel).isMessageSent)
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text("Are you admin?"),
                              Checkbox(
                                value: ref.read(authViewModel).isAdmin,
                                onChanged: (val) {
                                  ref
                                      .watch(authViewModel)
                                      .setAdmin(val ?? false);
                                },
                              ),
                            ],
                          ),
                        ), */
                      if (ref.read(authViewModel).isMessageSent)
                        TextFormField(
                          controller: ref.read(authViewModel).optController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.normal),
                          autofocus: false,
                          obscureText: true,
                          decoration: const InputDecoration(
                            errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.3)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.3)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.3)),
                            hintText: 'Otp Number',
                            labelText: 'Otp',
                            labelStyle:
                                TextStyle(fontSize: 18, color: Colors.grey),
                            prefixIcon: Icon(Icons.lock_open_rounded,
                                color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value != null && value == "") {
                              return "otp error";
                            }
                            return null;
                          },
                        ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            backgroundColor: Appcolors.assignButtonColor,
                            foregroundColor: actionButtonFgColor),
                        onPressed: (ref.read(authViewModel).isLoading)
                            ? null
                            : () async {
                                FocusScope.of(context).unfocus();

                                final authVm = ref.read(authViewModel);
                                authVm.setIsLoading(true);
                                if (!authVm.isMessageSent) {
                                  if (_formInfoKey.currentState == null) {
                                    return;
                                  }

                                  if (_formInfoKey.currentState!.validate()) {
                                    _formInfoKey.currentState!.save();

                                    authVm.signData = await authVm
                                        .signin(authVm.mobileController.text);

                                    print("data struct ${authVm.signData}");
                                    ref
                                        .read(authViewModel)
                                        .setMessageSent(false);
                                    authVm.setIsLoading(false);
                                    if (authVm.signData.isNotEmpty) {
                                      authVm.optController.text = "";
                                      ref
                                          .watch(authViewModel)
                                          .setMessageSent(true);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text("Message Sent!")));

                                      Navigator.of(context).maybePop();
                                    } else {
                                      ref
                                          .watch(authViewModel)
                                          .setMessageSent(false);
                                      authVm.setIsLoading(false);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Message sent failed!")));
                                    }
                                  }
                                } else {
                                  // otpController.text = "";
                                  bool didRegister = false;
                                  didRegister = await authVm.verifySignIn(
                                      authVm.signData,
                                      authVm.optController.text,
                                      authVm.nameController.text,
                                      authVm.storedImage,
                                      authVm.isAdmin,
                                      authVm.mobileController.text);

                                  if (didRegister) {
                                    authVm.resetAuthForm();
                                    didRegister = false;
                                    print("is come this section");
                                    // otpController.text = "";

                                    print("auth su");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Authentication Success!")));

                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) => const NavPage()));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Authentication  failed!")));
                                  }
                                  print("did pass $didRegister");
                                }
                              },
                        child: Text(
                          (ref.read(authViewModel).isMessageSent)
                              ? 'Login'
                              : 'Request Otp',
                          style: const TextStyle(fontSize: 25),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      (ref.watch(authViewModel).isLoading)
                          ? const Center(
                              child: CircularProgressIndicator(
                                  //  color: Appcolors.contentColorPurple,
                                  ),
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
