import 'package:flutter/material.dart';
import 'package:money_hooks/src/components/cardWidget.dart';
import 'package:money_hooks/src/components/centerWidget.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginLayer extends StatefulWidget {
  final Function googleSignInProcess;

  const LoginLayer({super.key, required this.googleSignInProcess});

  @override
  State<LoginLayer> createState() => _LoginLayerState();
}

class _LoginLayerState extends State<LoginLayer> {
  @override
  Widget build(BuildContext context) {
    return CenterWidget(
        padding: const EdgeInsets.only(top: 7.5, bottom: 7.5),
        child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: () {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          _signInCard(widget.googleSignInProcess));
                },
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
                child: const Text('ログイン',
                    style: TextStyle(color: Color(0xFF616161))))));
  }
}

Widget _signInCard(Function googleSignInProcess) {
  return Align(
      alignment: Alignment.center,
      child: CardWidget(
          child: Container(
              constraints: const BoxConstraints(
                maxWidth: 400,
                maxHeight: 500,
              ),
              child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 50),
                    const Center(child: Text('外部アカウントでログインしてください')),
                    const SizedBox(height: 50),
                    Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        height: 60,
                        child: SignInButton(Buttons.google,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            text: 'Googleでログイン',
                            onPressed: () async => await googleSignInProcess()))
                  ]))));
}
