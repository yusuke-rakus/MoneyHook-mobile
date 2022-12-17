import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:money_hooks/src/api/api.dart';
import 'package:money_hooks/src/class/savingTargetClass.dart';

class savingTargetApi {
  static String rootURI = '${Api.rootURI}/savingTarget';
  static Dio dio = Dio();
  static FlutterSecureStorage storage = const FlutterSecureStorage();

  static Future<void> getSavingTargetList(
      Function setSavingTargetList, String userId) async {
    await Future(() async {
      Response res = await dio
          .post('$rootURI/getSavingTargetList', data: {'userId': userId});
      if (res.data['status'] == 'error') {
        // 失敗
      } else {
        // 成功
        List<savingTargetClass> resultList = [
          savingTargetClass.setTargetFields(null, 'なし')
        ];
        res.data['savingTarget'].forEach((value) {
          resultList.add(savingTargetClass.setTargetFields(
              value['savingTargetId'], value['savingTargetName']));
        });
        setSavingTargetList(resultList);
      }
    });
  }
}
