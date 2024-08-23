import 'package:finances/models/category.dart';
import 'package:finances/models/transactions.dart';
import 'package:finances/services/account_service.dart';
import 'package:finances/services/database_controller.dart';
import 'package:finances/utils/enums.dart';
import 'package:finances/utils/get_it.dart';
import 'package:flutter/material.dart';

class TransactionsService {
  final String table = 'transactions';

  double _calculateRevenue(Transactions transaction) {
    if (transaction.type == TransactionType.expenses) {
      return transaction.value * -1;
    } else {
      return transaction.value;
    }
  }

  Future<List<Transactions>> listTransactions(
      {int limit = 10, int offset = 0}) async {
    var resp = await getIt<DatabaseController>().database.rawQuery("""
      SELECT 
        transactions.id AS idTransaction,
        transactions.title,
        transactions.description,
        transactions.dateTime,
        transactions.value,
        transactions.type,
        category.id AS idCategory,
        category.name,
        category.color,
        category.icon,
        category.plannedOutlay,
        category.transactionType
      FROM 
          transactions
      JOIN 
          category ON transactions.categoryId = category.id
      ORDER BY DATETIME(transactions.dateTime) DESC
      LIMIT ${limit.toString()} OFFSET ${offset.toString()};
    """);

    return List.from(resp.map((obj) => Transactions.fromMap(obj)));
  }

  Future<List<Transactions>> listTransactionsByTimeRange(
    DateTime begin,
    DateTime end, {
    Category? category,
  }) async {
    var categoryWhere = '';

    if (category != null) {
      categoryWhere = 'AND idCategory = "${category.id}"';
    }

    var resp = await getIt<DatabaseController>().database.rawQuery("""
      SELECT 
        transactions.id AS idTransaction,
        transactions.title,
        transactions.description,
        transactions.dateTime,
        transactions.value,
        transactions.type,
        category.id AS idCategory,
        category.name,
        category.color,
        category.icon,
        category.plannedOutlay,
        category.transactionType
      FROM 
          transactions
      JOIN 
          category ON transactions.categoryId = category.id
      where 
          DATETIME(transactions.dateTime) 
            BETWEEN DATETIME('${begin.toIso8601String()}') 
            AND DATETIME('${end.toIso8601String()}')
          $categoryWhere
      ORDER BY transactions.dateTime DESC;
          ;
    """);

    return List.from(resp.map((obj) => Transactions.fromMap(obj)));
  }

  Future insertTransactions(
    Transactions transactions,
    BuildContext context,
  ) async {
    await getIt<DatabaseController>().database.insert(
          table,
          transactions.toMap(),
        );

    if (context.mounted) {
      await getIt<AccountService>()
          .addRemoveValue(_calculateRevenue(transactions), context);
    }
  }

  Future<Transactions> getTransaction(String id) async {
    var resp = await getIt<DatabaseController>().database.rawQuery("""
      SELECT 
        transactions.id AS idTransaction,
        transactions.title,
        transactions.description,
        transactions.dateTime,
        transactions.value,
        transactions.type,
        category.id AS idCategory,
        category.name,
        category.color,
        category.icon,
        category.plannedOutlay,
        category.transactionType
      FROM 
          transactions
      JOIN 
          category ON transactions.categoryId = category.id
      where 
          idTransaction = '$id'
          ;
    """);

    return Transactions.fromMap(resp.first);
  }

  Future updateTransactions(
    Transactions transactions,
    BuildContext context,
  ) async {
    var oldTransaction = await getTransaction(transactions.id);

    await getIt<DatabaseController>().database.update(
      table,
      transactions.toMap(),
      where: 'id = ?',
      whereArgs: [transactions.id],
    );

    if (context.mounted) {
      await getIt<AccountService>().addRemoveValue(
        _calculateRevenue(oldTransaction) - _calculateRevenue(transactions),
        context,
      );
    }
  }

  Future deleteTransaction(
    Transactions transaction,
    BuildContext context,
  ) async {
    await getIt<DatabaseController>().database.delete(
      table,
      where: 'id = ?',
      whereArgs: [transaction.id],
    );

    if (context.mounted) {
      await getIt<AccountService>()
          .addRemoveValue(_calculateRevenue(transaction) * -1, context);
    }
  }
}
