import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:money_hooks/src/components/commonLoadingAnimation.dart';
import 'package:money_hooks/src/env/googleSignIn.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../components/customFloatingButtonLocation.dart';

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
                    Center(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.00, end: 0.5),
                        duration: const Duration(seconds: 1),
                        builder: (BuildContext context, double value,
                            Widget? child) {
                          return ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(colors: const [
                                Color(0xFF42A5F5),
                                Color(0xFFBA68C8),
                                Color(0xFFFB8C00)
                              ], stops: [
                                value,
                                0.75,
                                1.00,
                              ]).createShader(bounds);
                            },
                            child: const Text('こんにちは',
                                style: TextStyle(
                                  fontSize: 35,
                                  color: Colors.white,
                                )),
                          );
                        },
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
