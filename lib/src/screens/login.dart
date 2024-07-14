import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:money_hooks/src/components/centerWidget.dart';
import 'package:money_hooks/src/components/commonLoadingAnimation.dart';
import 'package:money_hooks/src/components/customFloatingButtonLocation.dart';
import 'package:money_hooks/src/env/googleSignIn.dart';
import 'package:sign_in_button/sign_in_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _firstVisible = false;
  bool _secondVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(seconds: 1), () => setState(() => _firstVisible = true));
    Future.delayed(const Duration(seconds: 2),
        () => setState(() => _secondVisible = true));
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
        body: ListView(children: [
          _loginButton(),
          _imageLayer(),
          _descriptionPageLayer(),
          const SizedBox(height: 100)
        ]),
      ),
    );
  }

  Widget _loginButton() {
    return CenterWidget(
      padding: const EdgeInsets.only(top: 7.5, bottom: 7.5),
      child: Align(
          alignment: Alignment.centerRight,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.blue, width: 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.5))),
            onPressed: () {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => _signInCard());
            },
            child:
                const Text('Login', style: TextStyle(color: Color(0xFF0D47A1))),
          )),
    );
  }

  Widget _signInCard() {
    return Align(
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
              const SizedBox(
                height: 50,
              ),
              const Center(child: Text('外部アカウントでログインしてください')),
              const SizedBox(
                height: 50,
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
    );
  }

  Widget _imageLayer() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E88E5), Color(0xFF64B5F6)]),
      ),
      child: Stack(children: [
        CenterWidget(
            child: Align(
                alignment: Alignment.centerLeft,
                child: AnimatedOpacity(
                    duration: const Duration(seconds: 1),
                    opacity: _firstVisible ? 1.0 : 0.0,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: SizedBox(
                          height: 170,
                          child: Row(children: [
                            Image.asset('images/color_logo.png',
                                fit: BoxFit.contain),
                            const Text('シンプル家計簿',
                                style: TextStyle(
                                    fontSize: 35, color: Colors.white70))
                          ])),
                    )))),
        CenterWidget(
            child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                    width: 500,
                    height: 350,
                    margin: const EdgeInsets.only(top: 170),
                    child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        margin: EdgeInsets.only(right: _firstVisible ? 20 : 0),
                        child: AnimatedOpacity(
                            duration: const Duration(seconds: 1),
                            opacity: _firstVisible ? 1.0 : 0.0,
                            child: SizedBox(
                                width: 400,
                                height: 300,
                                child: Image.asset('images/pc-home.png',
                                    fit: BoxFit.contain))))))),
        CenterWidget(
            child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                    alignment: Alignment.centerRight,
                    width: 500,
                    height: 280,
                    margin: const EdgeInsets.only(top: 200),
                    child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        margin: EdgeInsets.only(right: _firstVisible ? 20 : 0),
                        child: AnimatedOpacity(
                            duration: const Duration(seconds: 1),
                            opacity: _firstVisible ? 1.0 : 0.0,
                            child: SizedBox(
                                width: 200,
                                height: 280,
                                child: Image.asset('images/phone-home.png',
                                    fit: BoxFit.contain)))))))
      ]),
    );
  }

  Widget _descriptionPageLayer() {
    return AnimatedContainer(
        duration: const Duration(seconds: 1),
        child: AnimatedOpacity(
            opacity: _secondVisible ? 1.0 : 0.0,
            duration: const Duration(seconds: 1),
            child: ListView(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 10),
                  CenterWidget(
                      child: const Align(
                          alignment: Alignment.centerLeft,
                          child:
                              Text('機能のご紹介', style: TextStyle(fontSize: 20)))),
                  const SizedBox(height: 10),
                  CenterWidget(
                      color: Colors.white,
                      child: LayoutBuilder(builder: (context, constraints) {
                        double screenWidth = constraints.maxWidth;
                        double itemWidth = 300.0;
                        double viewportFraction = itemWidth / screenWidth;

                        return Container(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            height: 550,
                            child: PageView(
                                controller: PageController(
                                    viewportFraction: viewportFraction),
                                children: [
                                  _fixedWidthPage(
                                      width: itemWidth,
                                      child: Image.asset(
                                          'images/phone-home.png',
                                          fit: BoxFit.contain),
                                      title: 'ホーム画面',
                                      description:
                                          '支出が円グラフで表示され、\nカテゴリ毎の合計支出を閲覧できます。'),
                                  _fixedWidthPage(
                                      width: itemWidth,
                                      child: Image.asset(
                                          'images/phone-timeline.png',
                                          fit: BoxFit.contain),
                                      title: 'タイムライン一覧表示',
                                      description:
                                          '支出推移のグラフが表示されます。\nまた、今月の支出リストが表示されます。'),
                                  _fixedWidthPage(
                                      width: itemWidth,
                                      child: Image.asset(
                                          'images/phone-calendar.png',
                                          fit: BoxFit.contain),
                                      title: 'カレンダー表示',
                                      description:
                                          'カレンダーに支出額が表示されます。\n日付をタップすることで内訳の確認ができます。'),
                                  _fixedWidthPage(
                                      width: itemWidth,
                                      child: Image.asset(
                                          'images/phone-payment.png',
                                          fit: BoxFit.contain),
                                      title: '支払い方法毎のまとめ機能',
                                      description:
                                          '支払い方法毎にまとめて表示でき、支出の管理が可能です。'),
                                ]));
                      }))
                ])));
  }

  static Widget _fixedWidthPage({
    required double width,
    required Widget child,
    required String title,
    required String description,
  }) {
    double imageWidth = width - 120;
    return Center(
      child: Container(
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
            child: Card(
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Color(0xFFEEEEEE)),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            title,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                          )),
                      Container(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          width: imageWidth,
                          child: child),
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(description,
                              style: const TextStyle(
                                  color: Color(0xFF303030), fontSize: 12))),
                    ],
                  ),
                ))),
      ),
    );
  }
}
