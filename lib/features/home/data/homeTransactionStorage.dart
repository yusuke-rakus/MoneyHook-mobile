import 'package:localstore/localstore.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/features/home/class/homeTransaction.dart';

class HomeTransactionStorage {
  static final db = Localstore.instance;

  /// 【ホーム画面】データ
  static Future<HomeTransaction> getHome(String param) async {
    final id = 'home_data$param';
    Map<String, dynamic>? value =
        await db.collection('home_data').doc(id).get();

    HomeTransaction homeTran = HomeTransaction();

    if (value != null) {
      List<Category> categoryList = [];
      value['category_list'].forEach((category) {
        List<SubCategory> subCategoryList = [];
        category['sub_category_list'].forEach((subCategory) {
          subCategoryList.add(SubCategory(
              subCategoryName: subCategory['sub_category_name'],
              subCategoryTotalAmount:
                  subCategory['sub_category_total_amount']));
        });
        categoryList.add(Category(
            categoryName: category['category_name'],
            categoryTotalAmount: category['category_total_amount'],
            subCategoryList: subCategoryList));
      });
      homeTran.balance = value['balance'];
      homeTran.categoryList = categoryList;
    }

    return homeTran;
  }

  static void saveStorageHomeData(
      int balance, List<dynamic> resultList, String param) async {
    await db
        .collection('home_data')
        .doc('home_data$param')
        .set({'balance': balance, 'category_list': resultList});
  }

  static void deleteHomeData() async {
    await db.collection('home_data').delete();
  }

  static void deleteHomeDataWithParam(
      String userId, String transactionDate) async {
    EnvClass env = EnvClass.initNew(userId, transactionDate);
    final id = 'home_data${env.getJson()}';
    await db.collection('home_data').doc(id).delete();
  }
}
