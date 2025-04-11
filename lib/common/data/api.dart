import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:money_hooks/common/data/data/user/userApi.dart';
import 'package:money_hooks/common/env/envClass.dart';

class Api {
  static late final String rootURI;

  static Future<void> initialize() async {
    const localUri = String.fromEnvironment("ROOT_URI");
    if (localUri.isNotEmpty) {
      rootURI = "$localUri/api";
    } else {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));
      remoteConfig.setDefaults(const {"rootURI": "http://localhost:8080"});
      await remoteConfig.fetchAndActivate();
      rootURI = "${remoteConfig.getString("rootURI")}/api";
    }
  }

  static Dio dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30)));

  static Future<Options?> getHeader() async {
    User? user = FirebaseAuth.instance.currentUser;
    Options? options = await user?.getIdToken().then((value) async {
      final String? token = value;
      final String? email = user.email;

      if (EnvClass.enableFirebaseAuth()) {
        return Options(headers: {'Authorization': token});
      }

      if (email == null || token == null) {
        return null;
      } else {
        final String userId = convHash(email);
        final String hashedToken = convHash(token);
        // ローカルにあるトークンと比較
        String? localToken = await UserApi.getToken();
        if (localToken == null) {
          return null;
        }
        // 異なる場合：GoogleSignIn
        if (hashedToken.compareTo(localToken) != 0) {
          await UserApi.updateToken(userId, hashedToken);
        }

        return Options(headers: {'Authorization': hashedToken});
      }
    });
    return options;
  }

  static String errorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'コネクションタイムアウト';
      case DioExceptionType.connectionError:
        return '${error.response!.statusCode}: サーバーエラー';
      case DioExceptionType.cancel:
        return 'キャンセルされました';
      default:
        return '不明なエラーが発生しました';
    }
  }

  static String convHash(String value) {
    List<int> tokenBytes = utf8.encode(value);
    return sha256.convert(tokenBytes).toString();
  }
}
