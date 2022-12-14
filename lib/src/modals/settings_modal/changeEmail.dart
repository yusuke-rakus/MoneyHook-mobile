import 'package:flutter/material.dart';
import 'package:money_hooks/src/api/userApi.dart';
import 'package:money_hooks/src/class/changeEmailClass.dart';

import '../../env/envClass.dart';

class ChangeEmail extends StatefulWidget {
  ChangeEmail({Key? key, required this.env}) : super(key: key);
  envClass env;

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  bool _showPassword = false;

  late changeEmailClass emailClass;
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailClass = changeEmailClass.init(widget.env.userId);

    emailController.value =
        emailController.value.copyWith(text: emailClass.email);
    emailController.selection = TextSelection.fromPosition(
        TextPosition(offset: emailController.text.length));
  }

  void backNavigation() {
    Navigator.pop(context);
  }

  void _changeEmail() async {
    await userApi.changeEmail(emailClass, backNavigation);

    if (emailClass.errorMessage.isNotEmpty) {
      // エラーの場合のメッセージ表示
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                content: Text(emailClass.errorMessage),
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
    final focusNode = FocusNode();
    final passwordController = TextEditingController(text: emailClass.password);
    passwordController.selection = TextSelection.fromPosition(
        TextPosition(offset: passwordController.text.length));

    return Focus(
      focusNode: focusNode,
      child: GestureDetector(
        onTap: focusNode.requestFocus,
        child: Scaffold(
          appBar: AppBar(
            title: (const Text('設定')),
          ),
          body: Stack(
            children: [
              ListView(
                children: [
                  Container(
                      padding: const EdgeInsets.only(left: 10),
                      height: 35,
                      child: const Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'メールアドレス変更',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          emailClass.email = value;
                        });
                      },
                      controller: emailController,
                      decoration: InputDecoration(
                          labelText: '新しいメールアドレス',
                          icon: const Icon(Icons.email_outlined),
                          errorText: emailClass.emailError.isNotEmpty
                              ? emailClass.emailError
                              : null),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      obscureText: !_showPassword,
                      onChanged: (value) {
                        setState(() {
                          emailClass.password = value;
                        });
                      },
                      controller: passwordController,
                      decoration: InputDecoration(
                          labelText: "パスワード",
                          icon: const Icon(Icons.vpn_key_rounded),
                          errorText: emailClass.passwordError.isNotEmpty
                              ? emailClass.passwordError
                              : null,
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
                      onPressed: emailClass.isDisabled()
                          ? null
                          : () {
                              setState(() {
                                _changeEmail();
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        fixedSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        '登録',
                        style: TextStyle(fontSize: 23, letterSpacing: 20),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
