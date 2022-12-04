import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:money_hooks/src/api/userApi.dart';

import '../app.dart';
import '../class/userClass.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _showPassword = false;
  late userClass loginInfo;

  @override
  void initState() {
    super.initState();
    loginInfo = userClass.init();
  }

  @override
  Widget build(BuildContext context) {
    const storage = FlutterSecureStorage();

    // ログイン処理
    void _login(userClass loginInfo) {
      Future(() async {
        userApi.login(loginInfo);

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const MyStatefulWidget()));
      });
    }

    return Scaffold(
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
                    loginInfo.email = value;
                  },
                  controller: TextEditingController(text: loginInfo.email),
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
                    loginInfo.password = value;
                  },
                  controller: TextEditingController(text: loginInfo.password),
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
                  onPressed: () {
                    _login(loginInfo);
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
    );
  }
}
