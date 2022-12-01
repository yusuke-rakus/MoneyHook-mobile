import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showNewPassword2 = false;

  @override
  Widget build(BuildContext context) {
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
                  // controller: _passwordTextController,
                  decoration: InputDecoration(
                      labelText: "現在のパスワード",
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
                  // controller: _passwordTextController,
                  decoration: InputDecoration(
                      labelText: "新しいパスワード",
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
                  // controller: _passwordTextController,
                  decoration: InputDecoration(
                      labelText: "再入力",
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
                  onPressed: () {},
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
