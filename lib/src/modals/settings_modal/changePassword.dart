import 'package:flutter/material.dart';
import 'package:money_hooks/src/api/userApi.dart';
import 'package:money_hooks/src/class/changePasswordClass.dart';

import '../../env/envClass.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key, required this.env}) : super(key: key);
  envClass env;

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showNewPassword2 = false;

  late changePasswordClass passwordClass;

  @override
  void initState() {
    super.initState();
    passwordClass = changePasswordClass.init(widget.env.userId);
  }

  void backNavigation() {
    Navigator.pop(context);
  }

  void _changePassword() {
    userApi.changePassword(passwordClass, backNavigation);
  }

  @override
  Widget build(BuildContext context) {
    final passwordController =
        TextEditingController(text: passwordClass.password);
    passwordController.selection = TextSelection.fromPosition(
        TextPosition(offset: passwordController.text.length));

    final newPasswordController =
        TextEditingController(text: passwordClass.newPassword);
    newPasswordController.selection = TextSelection.fromPosition(
        TextPosition(offset: newPasswordController.text.length));

    final newPassword2Controller =
        TextEditingController(text: passwordClass.newPassword2);
    newPassword2Controller.selection = TextSelection.fromPosition(
        TextPosition(offset: newPassword2Controller.text.length));

    return Scaffold(
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
                        'パスワード変更',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  obscureText: !_showCurrentPassword,
                  onChanged: (value) {
                    setState(() {
                      passwordClass.password = value;
                    });
                  },
                  controller: passwordController,
                  decoration: InputDecoration(
                      labelText: "現在のパスワード",
                      errorText: passwordClass.passwordError.isNotEmpty
                          ? passwordClass.passwordError
                          : null,
                      suffixIcon: IconButton(
                        icon: Icon(_showCurrentPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () {
                          setState(() {
                            _showCurrentPassword = !_showCurrentPassword;
                          });
                        },
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  obscureText: !_showNewPassword,
                  onChanged: (value) {
                    setState(() {
                      passwordClass.newPassword = value;
                    });
                  },
                  controller: newPasswordController,
                  decoration: InputDecoration(
                      labelText: "新しいパスワード",
                      errorText: passwordClass.newPasswordError.isNotEmpty
                          ? passwordClass.newPasswordError
                          : null,
                      suffixIcon: IconButton(
                        icon: Icon(_showNewPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () {
                          setState(() {
                            _showNewPassword = !_showNewPassword;
                          });
                        },
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  obscureText: !_showNewPassword2,
                  onChanged: (value) {
                    setState(() {
                      passwordClass.newPassword2 = value;
                    });
                  },
                  controller: newPassword2Controller,
                  decoration: InputDecoration(
                      labelText: "再入力",
                      errorText: passwordClass.newPassword2Error.isNotEmpty
                          ? passwordClass.newPassword2Error
                          : null,
                      suffixIcon: IconButton(
                        icon: Icon(_showNewPassword2
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () {
                          setState(() {
                            _showNewPassword2 = !_showNewPassword2;
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
                  onPressed: passwordClass.isDisabled()
                      ? null
                      : () {
                          setState(() {
                            _changePassword();
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
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
    );
  }
}
