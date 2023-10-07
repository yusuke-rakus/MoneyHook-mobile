import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Api {
  static const String rootURI = 'http://localhost:8080';

  static Dio dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30)));

  static Future<Options?> getHeader() async {
    User? user = FirebaseAuth.instance.currentUser;
    Options? options = await user?.getIdToken().then((value) {
      final String? token = value;
      final String? email = user.email;

      if (email == null || token == null) {
        return null;
        // return Options(
        //     headers: {'userId': 'userId', 'Authorization': 'hashedToken'});
      } else {
        List<int> emailBytes = utf8.encode(email);
        final userId = sha256.convert(emailBytes).toString();

        List<int> tokenBytes = utf8.encode(token);
        final hashedToken = sha256.convert(tokenBytes).toString();
        return Options(
            // headers: {'userId': 'userId', 'Authorization': 'hashedToken'});
            headers: {'userId': userId, 'Authorization': hashedToken});
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
}
