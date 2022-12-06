import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:money_hooks/src/api/userApi.dart';

import '../class/userClass.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _showPassword = false;
  bool _isLoading = false;
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
  }

  // ログイン処理
  void _login(BuildContext context, userClass loginInfo) async {
    await userApi.login(context, loginInfo, setLoading);
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.lightBlueAccent, size: 50),
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
                    onPressed: _isLoading
                        ? null
                        : () {
                            _login(context, loginInfo);
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
