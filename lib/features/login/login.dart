import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:money_hooks/common/widgets/commonLoadingAnimation.dart';
import 'package:money_hooks/common/widgets/commonSnackBar.dart';
import 'package:money_hooks/features/login/googleSignIn.dart';
import 'package:money_hooks/features/login/views/descriptionPageLayer.dart';
import 'package:money_hooks/features/login/views/imageLayer.dart';
import 'package:money_hooks/features/login/views/loginLayer.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool firstVisible = false;
  bool secondVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(seconds: 1), () => setState(() => firstVisible = true));
    Future.delayed(
        const Duration(seconds: 2), () => setState(() => secondVisible = true));
  }

  /// GoogleSignIn処理
  Future<void> googleSignInProcess() async {
    try {
      await signInWithGoogle();
      Navigator.pop(context);
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
        body: ListView(
          children: [
            LoginLayer(googleSignInProcess: googleSignInProcess),
            Imagelayer(firstVisible: firstVisible),
            DescriptionPageLayer(secondVisible: secondVisible),
            const SizedBox(height: 100)
          ],
        ),
      ),
    );
  }
}
