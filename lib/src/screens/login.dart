import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:money_hooks/src/api/userApi.dart';
import 'package:money_hooks/src/app.dart';
import 'package:money_hooks/src/components/commonLoadingAnimation.dart';
import 'package:money_hooks/src/env/googleSignIn.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../class/userClass.dart';
import '../components/commonSnackBar.dart';
import '../components/dataNotRegisteredBox.dart';

class Login extends StatefulWidget {
  Login(this.isLoading, {super.key});

  bool isLoading;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late bool _isLoading;
  late userClass loginInfo;

  // [デバッグ用]
  void setLoading() {
    setState(() {
      _isLoading ? context.loaderOverlay.hide() : context.loaderOverlay.show();
      _isLoading = !_isLoading;
    });
  }

  // アプリケーションの再読み込み[デバッグ用]
  void reload() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const MyStatefulWidget()));
  }

  // スナックバー表示[デバッグ用]
  void setSnackBar(String message) {
    CommonSnackBar.build(context: context, text: message);
  }

  @override
  void initState() {
    super.initState();
    loginInfo = userClass.init();
    _isLoading = widget.isLoading;
  }

  // ログイン処理[デバッグ用]
  void _login(BuildContext context, userClass loginInfo) async {
    await userApi.login(loginInfo, setLoading, reload, setSnackBar);
  }

  /// GoogleSignIn処理
  void _signInWithGoogle() {
    try {
      signInWithGoogle();
    } on Exception {
      CommonSnackBar.build(context: context, text: 'Firebaseエラー');
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
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const dataNotRegisteredBox(message: '外部アカウントでログインしてください'),
                // *** デバッグ用ログイン start ***
                TextField(
                  onChanged: (value) {
                    setState(() {
                      loginInfo.email = value;
                    });
                  },
                  controller: emailController,
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      loginInfo.password = value;
                    });
                  },
                  controller: passwordController,
                ),
                ElevatedButton(
                  onPressed: () {
                    _login(context, loginInfo);
                  },
                  child: const Text(
                    'デバッグ用旧ログイン',
                  ),
                ),
                TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: const Text(
                      'Firebaseログアウト',
                      style: TextStyle(color: Colors.black54),
                    ))
                // *** デバッグ用ログイン end ***
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child:
                      // Googleサインイン
                      SignInButton(
                    Buttons.google,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    text: 'Googleでログイン',
                    onPressed: () async {
                      _signInWithGoogle();
                    },
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
