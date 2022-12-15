import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:money_hooks/src/api/api.dart';
import 'package:money_hooks/src/class/savingTargetClass.dart';

class savingTargetApi {
  static String rootURI = '${Api.rootURI}/savingTarget';
  static Dio dio = Dio();
  static FlutterSecureStorage storage = const FlutterSecureStorage();

  static Future<void> getSavingTargetList(Function setSavingTargetList) async {
    await Future(() async {
      Response res = await dio.post('$rootURI/getSavingTargetList',
          data: {'userId': 'a77a6e94-6aa2-47ea-87dd-129f580fb669'});
      if (res.data['status'] == 'error') {
        // 失敗
      } else {
        // 成功
        List<savingTargetClass> resultList = [];
        res.data['savingTarget'].forEach((value) {
          resultList.add(savingTargetClass.setTargetFields(
              value['savingTargetId'], value['savingTargetName']));
        });
        setSavingTargetList(resultList);
      }
    });
  }
}
