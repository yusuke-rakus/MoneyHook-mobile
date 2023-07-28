import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:money_hooks/src/api/userApi.dart';
import 'package:money_hooks/src/components/commonLoadingAnimation.dart';
import 'package:money_hooks/src/env/googleSignIn.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../app.dart';
import '../class/userClass.dart';

class Login extends StatefulWidget {
  Login(this.isLoading, {super.key});

  bool isLoading;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _showPassword = false;
  late bool _isLoading;
  late userClass loginInfo;

  void setLoading() {
    setState(() {
      _isLoading ? context.loaderOverlay.hide() : context.loaderOverlay.show();
      _isLoading = !_isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    loginInfo = userClass.init();
    _isLoading = widget.isLoading;
  }

  // ログイン処理
  void _login(BuildContext context, userClass loginInfo) async {
    // エラーメッセージをクリア
    loginInfo.errorMessage = '';
    await userApi.login(context, loginInfo, setLoading);

    if (loginInfo.errorMessage.isNotEmpty) {
      // エラーの場合のメッセージ表示
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                content: Text(loginInfo.errorMessage),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('閉じる'),
                  )
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController(text: loginInfo.email);
    emailController.selection = TextSelection.fromPosition(
        TextPosition(offset: emailController.text.length));

    final passwordController = TextEditingController(text: loginInfo.password);
    passwordController.selection = TextSelection.fromPosition(
        TextPosition(offset: passwordController.text.length));

    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: Center(
        child: CommonLoadingAnimation.build(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: (const Text('ログイン')),
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        loginInfo.email = value;
                      });
                    },
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'メールアドレス',
                      icon: Icon(Icons.email_outlined),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        loginInfo.password = value;
                      });
                    },
                    controller: passwordController,
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                        labelText: "パスワード",
                        icon: const Icon(Icons.vpn_key_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(_showPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        )),
                  ),
                ),
                // Googleサインイン
                SignInButton(
                  Buttons.google,
                  onPressed: () async {
                    Future<UserCredential> user = signInWithGoogle();
                    print(user);
                    userApi.googleSignIn(context, 'email', 'token').then(
                        (value) => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const MyStatefulWidget())));
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loginInfo.isDisabled()
                        ? null
                        : _isLoading
                            ? null
                            : () {
                                setState(() {
                                  _login(context, loginInfo);
                                });
                              },
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      fixedSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'ログイン',
                      style: TextStyle(fontSize: 20, letterSpacing: 15),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
