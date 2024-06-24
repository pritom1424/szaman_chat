/* 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:szaman_chat/utils/components/app_vars.dart';
import 'package:szaman_chat/utils/constants/app_colors.dart';
import 'package:szaman_chat/utils/constants/app_paths.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';
import 'package:szaman_chat/view/pages/nav_page.dart';

class LoginForm extends StatefulWidget {
  final String? title;
  const LoginForm({super.key, this.title});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

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
    emailController.dispose();
    passController.dispose();
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
                      /* const SizedBox(height: 10),
                      Container(
                          decoration: BoxDecoration(
                              color: Appcolors.assignButtonColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Login",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 45,
                                fontWeight: FontWeight.bold),
                          )), */
                      /*  SizedBox(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: (_storedImage != null)
                                  ? FileImage(_storedImage!)
                                  : AssetImage(AppPaths.charplaceholderPath)
                                      as ImageProvider,
                            ),
                          ],
                        ),
                      ), */
                      const SizedBox(height: 20),
                      TextFormField(
                        //focusNode: emailFocusNode,
                        controller: emailController,
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
                          hintText: 'Email',
                          labelText: 'Email',
                          labelStyle:
                              TextStyle(fontSize: 18, color: Colors.grey),
                          prefixIcon:
                              Icon(Icons.email_outlined, color: Colors.grey),
                        ),
                        validator: (value) {
                          if (value != null && value == "") {
                            return "email error";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passController,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                        autofocus: false,
                        obscureText: true,
                        obscuringCharacter: "*",
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
                          hintText: 'Password',
                          labelText: 'Password',
                          labelStyle:
                              TextStyle(fontSize: 18, color: Colors.grey),
                          prefixIcon:
                              Icon(Icons.lock_open_rounded, color: Colors.grey),
                        ),
                        validator: (value) {
                          if (value != null && value == "") {
                            return "pass error";
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
                                if (_formInfoKey.currentState == null) {
                                  return;
                                }
                                if (_formInfoKey.currentState!.validate()) {
                                  _formInfoKey.currentState!.save();

                                  final authVm = ref.read(authViewModel);

                                  final didRegister = await authVm.login(
                                    emailController.text,
                                    passController.text,
                                  );

                                  if (didRegister) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) => const NavPage()));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text("Login failed!")));
                                  }

                                  emailController.text = "";
                                  passController.text = "";
                                  ref.watch(authViewModel).setStoreImage(null);
                                  authVm.setAdmin(false);
                                  /*    final prov = Provider.of<HrmsAuthController>(context,
                                listen: false);
                            prov.setLoading(true);
                            final result = await prov.Authenticate(
                                emailController.text, passController.text);
                    
                            prov.setLoading(false);
                    
                            if (result) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (ctx) => RootNavPage()));
                            } else {
                              AppMethods().snackBar(
                                  AppStrings.loginErrorMessage, context);
                            } */
                                }
                              },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(fontSize: 25),
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
                          : const SizedBox.shrink(),
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
 */