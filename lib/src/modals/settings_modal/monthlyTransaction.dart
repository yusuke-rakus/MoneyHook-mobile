import 'package:flutter/material.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({Key? key}) : super(key: key);

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  bool _showPassword = false;

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
                        'メールアドレス変更',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'メールアドレス',
                    icon: Icon(Icons.email_outlined),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  obscureText: !_showPassword,
                  // controller: _passwordTextController,
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
