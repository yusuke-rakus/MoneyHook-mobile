import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:money_hooks/src/api/api.dart';
import 'package:money_hooks/src/api/validation/userValidation.dart';
import 'package:money_hooks/src/class/changePasswordClass.dart';
import 'package:money_hooks/src/class/userClass.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../class/changeEmailClass.dart';

class userApi {
  static String rootURI = '${Api.rootURI}/user';

  // Googleサインイン
  static Future<void> googleSignIn(
      BuildContext context, String email, String token) async {
    await Future(() async {
      Response res = await Api.dio.post('$rootURI/googleSignIn',
          data: {'userId': email, 'token': token});
      if (res.data['status'] == 'error') {
        // ログイン失敗
      } else {
        // ログイン成功
        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('USER_ID', res.data['user']['userId']);
      }
    });
  }

  // ログイン
  static Future<void> login(userClass loginInfo, Function setLoading,
      Function reload, Function setSnackBar) async {
    setLoading();
    await Future(() async {
      try {
        Response res =
            await Api.dio.post('$rootURI/login', data: loginInfo.loginJson());
        if (res.data['status'] == 'error') {
          // ログイン失敗
        } else {
          // ログイン成功
          SharedPreferences prefs = await SharedPreferences.getInstance();

          await prefs.setString('USER_ID', res.data['user']['userId']);
          reload();
        }
      } on DioError catch (e) {
        setSnackBar(Api.errorMessage(e));
      } finally {
        setLoading();
      }
    });
  }

  // パスワード変更
  static Future<void> changePassword(
      changePasswordClass passwordClass, Function backNavigation) async {
    if (userValidation.checkChangePassword(passwordClass)) {
      return;
    }

    await Future(() async {
      Response res = await Api.dio
          .post('$rootURI/changePassword', data: passwordClass.toJson());
      if (res.data['status'] == 'error') {
        // 失敗
        passwordClass.errorMessage = res.data['message'];
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
          await Api.dio.post('$rootURI/changeEmail', data: emailClass.toJson());
      if (res.data['status'] == 'error') {
        // 失敗
        emailClass.errorMessage = res.data['message'];
      } else {
        // 成功
        backNavigation();
      }
    });
  }
}
