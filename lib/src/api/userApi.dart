import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_hooks/src/api/api.dart';

class userApi {
  static String rootURI = '${Api.rootURI}/user';

  // Googleサインイン
  static Future<String?> googleSignIn(BuildContext context, String email,
      String token, Function setSnackBar, Function setLoginItem) async {
    List<int> emailBytes = utf8.encode(email);
    final userId = sha256.convert(emailBytes).toString();

    List<int> tokenBytes = utf8.encode(token);
    final hashedToken = sha256.convert(tokenBytes).toString();

    try {
      Response res = await Api.dio.post('$rootURI/googleSignIn',
          data: {'userId': userId},
          options: Options(headers: {'Authorization': hashedToken}));
      if (res.data['status'] == 'error') {
        // ログイン失敗
        return null;
      } else {
        // ログイン成功
        return userId;
      }
    } on DioException catch (e) {
      setSnackBar(Api.errorMessage(e));
      setLoginItem();
      // Googleサインインは成功するも独自サインインに失敗した場合、サインアウト
      FirebaseAuth.instance.signOut();
      return null;
    }
  }
}
