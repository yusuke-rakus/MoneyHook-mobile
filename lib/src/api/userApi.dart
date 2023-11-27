import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:money_hooks/src/api/api.dart';

import '../searchStorage/categoryStorage.dart';
import '../searchStorage/monthlyTransactionStorage.dart';
import '../searchStorage/savingStorage.dart';
import '../searchStorage/savingTargetStorage.dart';
import '../searchStorage/transactionStorage.dart';

class UserApi {
  static String rootURI = '${Api.rootURI}/user';
  static final db = Localstore.instance;

  // Googleサインイン
  static Future<String?> googleSignIn(BuildContext context, String email,
      String token, Function setSnackBar, Function setLoginItem) async {
    final userId = convHash(email);
    final hashedToken = convHash(token);
    saveToken(hashedToken);

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
      // Googleサインインは成功するも独自サインインに失敗した場合、サインアウト
      UserApi.signOut();
      setSnackBar(Api.errorMessage(e));
      setLoginItem();
      return null;
    }
  }

  static Future<String?> updateToken(String userId, String hashedToken) async {
    saveToken(hashedToken);
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
    } on DioException {
      // Googleサインインは成功するも独自サインインに失敗した場合、サインアウト
      UserApi.signOut();
      return null;
    }
  }

  // サインアウト処理
  static void signOut() {
    deleteToken();
    TransactionStorage.allDelete();
    SavingStorage.allDelete();
    MonthlyTransactionStorage.allDelete();
    SavingTargetStorage.allDelete();
    CategoryStorage.allDelete();
    FirebaseAuth.instance.signOut();
  }

  static String convHash(String value) {
    List<int> tokenBytes = utf8.encode(value);
    return sha256.convert(tokenBytes).toString();
  }

  /// 端末ストレージの操作メソッド
  static Future<String?> getToken() async {
    return await db
        .collection('user')
        .doc('token')
        .get()
        .then((value) => value?['data']);
  }

  static void saveToken(String token) async {
    await db.collection('user').doc('token').set({'data': token});
  }

  static void deleteToken() async {
    await db.collection('user').delete();
  }
}
