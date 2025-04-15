import 'package:localstore/localstore.dart';
import 'package:money_hooks/common/class/categoryClass.dart';
import 'package:money_hooks/features/editTransaction/data/category/editTranCategoryStorage.dart';
import 'package:money_hooks/features/settings/data/hideSubCategory/hideSubCategoryStorage.dart';

class CommonCategoryStorage {
  static final db = Localstore.instance;

  /// ストレージ全削除
  static void allDelete() {
    EditTranCategoryStorage.deleteCategoryList();
    EditTranCategoryStorage.deleteSubCategoryList();
    HideSubCategoryStorage.deleteCategoryWithSubCategoryList();
  }

  static Future<CategoryClass> getDefaultValue() async {
    CategoryClass category =
        CategoryClass.setDefaultValue('1', '食費', '1', 'なし');
    await db.collection('defaultValue').doc('defaultValue').get().then((value) {
      if (value != null) {
        category.categoryId = value['categoryId'].toString();
        category.categoryName = value['categoryName'];
        category.subCategoryId = value['subCategoryId'].toString();
        category.subCategoryName = value['subCategoryName'];
      }
    });
    return category;
  }

  static Future<void> saveDefaultValue(CategoryClass category) async {
    await db.collection('defaultValue').doc('defaultValue').set({
      'categoryId': category.categoryId,
      'categoryName': category.categoryName,
      'subCategoryId': category.subCategoryId,
      'subCategoryName': category.subCategoryName,
    });
  }

  static void deleteDefaultValue() async {
    await db.collection('defaultValue').delete();
  }
}
