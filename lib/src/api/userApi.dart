import 'package:money_hooks/src/class/response/homeTransaction.dart';
import 'package:money_hooks/src/env/env.dart';

class transactionApi {
  static void printSample(envClass env, homeTransaction homeTransactinList) {
    homeTransactinList.categoryList = [
      {
        'categoryName': '変わったよ',
        'categoryTotalAmount': '-10000',
        'subCategoryList': [
          {
            'subCategoryName': 'スーパー',
            'subCategoryTotalAmount': '-10000',
          },
          {
            'subCategoryName': 'なし',
            'subCategoryTotalAmount': '-10000',
          },
        ]
      },
    ];
  }
}
