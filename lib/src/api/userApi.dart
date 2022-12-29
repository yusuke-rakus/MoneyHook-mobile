import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:money_hooks/src/api/api.dart';
import 'package:money_hooks/src/api/validation/userValidation.dart';
import 'package:money_hooks/src/class/changePasswordClass.dart';
import 'package:money_hooks/src/class/userClass.dart';

import '../app.dart';
import '../class/changeEmailClass.dart';

class userApi {
  static String rootURI = '${Api.rootURI}/user';
  static Dio dio = Dio();
  static FlutterSecureStorage storage = const FlutterSecureStorage();

  // ログイン
  static Future<void> login(
      BuildContext context, userClass loginInfo, Function setLoading) async {
    setLoading();
    await Future(() async {
      Response res =
          await dio.post('$rootURI/login', data: loginInfo.loginJson());
      if (res.data['status'] == 'error') {
        // ログイン失敗
        setLoading();
      } else {
        // ログイン成功
        setLoading();
        await storage.write(key: 'USER_ID', value: res.data['user']['userId']);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const MyStatefulWidget()));
      }
    });
  }

  // パスワード変更
  static Future<void> changePassword(
      changePasswordClass passwordClass, Function backNavigation) async {


    await Future(() async {
      Response res = await dio.post('$rootURI/changePassword',
          data: passwordClass.toJson());
      if (res.data['status'] == 'error') {
        // 失敗
      } else {
        // 成功
        backNavigation();
      }
    });
  }

  // メールアドレス変更
  static Future<void> changeEmail(
      changeEmailClass emailClass, Function backNavigation) async {
    if (userValidation.checkChangeEmail(emailClass)) {
      return;
    }

    await Future(() async {
      Response res =
          await dio.post('$rootURI/changeEmail', data: emailClass.toJson());
      if (res.data['status'] == 'error') {
        // 失敗
      } else {
        // 成功
        backNavigation();
      }
      print('hej');
    });
  }
}
