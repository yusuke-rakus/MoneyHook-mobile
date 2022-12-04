import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:money_hooks/src/api/api.dart';
import 'package:money_hooks/src/class/userClass.dart';

class userApi {
  static String rootURI = '${Api.rootURI}/user';
  static Dio dio = Dio();
  static FlutterSecureStorage storage = const FlutterSecureStorage();

  static void login(userClass loginInfo) async {
    Response res = await dio.post('$rootURI/login',
        data: {'email': 'sample@sample.com', 'password': 'matumoto223'});

    if (res.data['status'] == 'error') {
    } else {
      await storage.write(key: 'USER_ID', value: 'Hej,USER_ID');
    }
  }
}
