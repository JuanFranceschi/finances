import 'dart:io';

import 'package:finances/models/category.dart';
import 'package:finances/services/category_service.dart';
import 'package:finances/utils/enums.dart';
import 'package:finances/utils/get_it.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DatabaseController {
  DatabaseController();

  late final Database database;

  setupDatabase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'finances_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          """CREATE TABLE category(
            id VARCHAR(256) PRIMARY KEY, 
            name VARCHAR(256),
            color CHAR(8),
            icon INTEGER,
            plannedOutlay FLOAT, 
            transactionType VARCHAR(20)
          )""",
        );

        await db.execute(
          """CREATE TABLE transactions(
            id VARCHAR(256) PRIMARY KEY, 
            title VARCHAR(124),
            description VARCHAR(512),
            dateTime TEXT,
            categoryId VARCHAR(256),
            value FLOAT,
            type VARCHAR(20)
          )""",
        );

        await db.execute(
          """CREATE TABLE account(
            id INTEGER PRIMARY KEY, 
            owner VARCHAR(124),
            value FLOAT,
            theme VARCHAR(20)
          )""",
        );

        _createStartingCategories();

        return;
      },
      version: 1,
    );
  }

  _createStartingCategories() async {
    await Future.delayed(const Duration(seconds: 1));
    var uuid = const Uuid();
    bool pt = Platform.localeName.contains('pt');
    var categoryGrocery = Category(
      id: uuid.v4(),
      name: pt ? 'Mercado' : 'Groceries',
      color: const Color(0xff36B5B0),
      icon: Symbols.shopping_cart,
      plannedOutlay: 1200,
      transactionType: TransactionType.expenses,
    );

    await getIt<CategoryService>().insertCategory(categoryGrocery);

    var categoryHealth = Category(
      id: uuid.v4(),
      name: pt ? 'Saúde' : 'Health',
      color: const Color(0xffE63946),
      icon: Symbols.healing_rounded,
      plannedOutlay: 400,
      transactionType: TransactionType.expenses,
    );

    await getIt<CategoryService>().insertCategory(categoryHealth);

    var category = Category(
      id: uuid.v4(),
      name: pt ? 'Transporte' : 'Transportation',
      color: const Color(0xffFB5607),
      icon: Symbols.local_gas_station,
      plannedOutlay: 500,
      transactionType: TransactionType.expenses,
    );

    await getIt<CategoryService>().insertCategory(category);

    var categoryPaycheck = Category(
      id: uuid.v4(),
      name: pt ? 'Salário' : 'Paycheck',
      color: const Color(0xff4E89AE),
      icon: Symbols.business_center,
      plannedOutlay: 0,
      transactionType: TransactionType.income,
    );

    await getIt<CategoryService>().insertCategory(categoryPaycheck);
  }
}
