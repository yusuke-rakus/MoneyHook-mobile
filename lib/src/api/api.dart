import 'package:dio/dio.dart';

class Api {
  static const String rootURI = 'http://localhost:8080';

  static Dio dio = Dio(BaseOptions(
      connectTimeout: 10000, receiveTimeout: 10000, sendTimeout: 10000));

  static String errorMessage(DioError error) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        return 'コネクションタイムアウト';
      case DioErrorType.response:
        return '${error.response!.statusCode}: サーバーエラー';
      case DioErrorType.cancel:
        return 'キャンセルされました';
      default:
        return '不明なエラーが発生しました';
    }
  }
}
