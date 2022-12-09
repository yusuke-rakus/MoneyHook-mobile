import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:money_hooks/src/api/api.dart';

import '../class/savingClass.dart';
import '../env/env.dart';

class savingApi {
  static String rootURI = '${Api.rootURI}/saving';
  static Dio dio = Dio();
  static FlutterSecureStorage storage = const FlutterSecureStorage();

  static Future<void> getMonthlySavingData(
      envClass env, Function setSavingList) async {
    await Future(() async {
      Response res = await dio.post('$rootURI/getMonthlySavingData', data: {
        'userId': 'a77a6e94-6aa2-47ea-87dd-129f580fb669',
        'month': env.thisMonth
      });
      if (res.data['status'] == 'error') {
        // 失敗
      } else {
        // 成功
        List<savingClass> resultList = [];
        int resultAmount = 0;
        res.data['savingList'].forEach((value) {
          resultList.add(savingClass.setFields(
              value['savingDate'],
              value['savingName'],
              value['savingId'],
              value['savingAmount'],
              value['savingTargetId'],
              value['savingTargetName']));
        });
        // for (var e in resultList) {
        //   resultAmount += int.parse(e.savingAmount);
        // }
        setSavingList(resultList, resultAmount);
      }
    });
  }
}
