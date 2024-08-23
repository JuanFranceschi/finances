import 'package:finances/models/account.dart';
import 'package:finances/services/database_controller.dart';
import 'package:finances/utils/account_manager.dart';
import 'package:finances/utils/get_it.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountService {
  final String table = 'account';

  Future<Account?> getAccount() async {
    var accountMap = await getIt<DatabaseController>().database.query(table, where: 'id = 1');

    return accountMap.isEmpty ? null : Account.fromMap(accountMap.first);
  }

  Future addRemoveValue(double value, BuildContext context) async {
    await getIt<DatabaseController>().database.rawUpdate("""
      UPDATE $table
      SET value = value + (${value.toString()})
      WHERE id = 1;
    """);

    if (context.mounted) {
      Provider.of<AccountManager>(context, listen: false).updateAccount();
    }
  }

  Future updateThemeMode(ThemeMode newMode) async {
    var account = await getAccount();

    if (account == null) return;

    if (account.theme != newMode) {
      account.theme = newMode;

      createOrUpdateAccount(account);
    }
  }

  Future updateName(String name) async {
    var account = await getAccount();

    if (account == null) return;

    if (account.owner != name) {
      account.owner = name;

      createOrUpdateAccount(account);
    }
  }

  Future createOrUpdateAccount(Account account) async {
    if ((await getAccount()) == null) {
      await getIt<DatabaseController>().database.insert(table, account.toMap());
    } else {
      await getIt<DatabaseController>().database.update(
            table,
            account.toMap(),
            where: 'id = 1',
          );
    }
  }
}
