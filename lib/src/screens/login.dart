import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:money_hooks/src/components/commonLoadingAnimation.dart';
import 'package:money_hooks/src/env/googleSignIn.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../components/commonSnackBar.dart';
import '../components/gradientBar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
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
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidgetBuilder: (_) {
        return Center(child: CommonLoadingAnimation.build());
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: GradientBar(),
          title: (const Text('ログイン')),
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Align(
            alignment: Alignment.center,
            child: Card(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                  maxHeight: 500,
                ),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: 70,
                      child: Image.asset(
                        "images/color_logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Center(child: Text('外部アカウントでログインしてください')),
                    const SizedBox(
                      height: 100,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      height: 60,
                      child: SignInButton(
                        Buttons.google,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        text: 'Googleでログイン',
                        onPressed: () async {
                          _signInWithGoogle();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
