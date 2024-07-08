import 'package:finances/models/category.dart';
import 'package:finances/services/database_controller.dart';
import 'package:finances/utils/enums.dart';
import 'package:finances/utils/get_it.dart';

class CategoryService {
  final String table = 'category';
  Future<List<Category>> listCategories({
    int limit = 99,
    TransactionType type = TransactionType.expenses,
  }) async {
    var resp = await getIt<DatabaseController>().database.query(table,
        limit: limit,
        where: 'transactionType = ?',
        whereArgs: [type.toString()]);

    return List.from(resp.map((obj) => Category.fromMap(obj)));
  }

  Future insertCategory(Category category) async {
    await getIt<DatabaseController>().database.insert(table, category.toMap());
  }

  Future updateCategory(Category category) async {
    await getIt<DatabaseController>().database.update(
      table,
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }
}
