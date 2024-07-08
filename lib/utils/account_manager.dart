import 'package:finances/models/account.dart';
import 'package:finances/services/account_service.dart';
import 'package:finances/utils/get_it.dart';
import 'package:flutter/material.dart';

class AccountManager with ChangeNotifier {
  late Account account;
  bool showValues = false;

  updateShowValues() {
    showValues = !showValues;

    notifyListeners();
  }

  updateAccount() async {
    var newAccount = await getIt<AccountService>().getAccount();

    if (newAccount == null) return;

    account = newAccount;

    notifyListeners();
  }
}
