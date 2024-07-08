import 'package:finances/models/transactions.dart';
import 'package:finances/services/transactions_service.dart';
import 'package:finances/utils/account_manager.dart';
import 'package:finances/utils/app_utils.dart';
import 'package:finances/utils/enums.dart';
import 'package:finances/utils/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HomeController with ChangeNotifier {
  final BuildContext context;
  Period period = Period.weekly;
  DateTime customBegin = DateTime.now(), customEnd = DateTime.now();

  HomeController({required this.context});

  List<Transactions> get _weeklyTransactions {
    var dates = getIt<AppUtils>().getDateRange(Period.weekly, _today);

    return _monthlyTransactions.where((obj) {
      return obj.dateTime.isAfter(dates[0]) && obj.dateTime.isBefore(dates[1]);
    }).toList();
  }

  List<Transactions> get _todayTransactions {
    return _monthlyTransactions.where((obj) {
      return obj.dateTime.isAfter(_today) &&
          obj.dateTime.isBefore(_today.add(const Duration(days: 1)));
    }).toList();
  }

  List<Transactions> get _customTransactions {
    return _monthlyTransactions.where((obj) {
      return obj.dateTime.isAfter(customBegin) &&
          obj.dateTime.isBefore(customEnd.add(const Duration(days: 1)));
    }).toList();
  }

  List<Transactions> get activeTransactions {
    switch (period) {
      case Period.today:
        return _todayTransactions;
      case Period.weekly:
        return _weeklyTransactions;
      case Period.monthly:
        return _monthlyTransactions;
      case Period.custom:
        return _customTransactions;
    }
  }

  final List<Transactions> _monthlyTransactions = List.empty(growable: true);

  List<Transactions> totalByCategory(List<Transactions> transactions) {
    List<Transactions> result = List.empty(growable: true);

    for (var transaction in transactions.where((obj) => obj.type == TransactionType.expenses)) {
      bool filter(Transactions obj) => obj.category.id == transaction.category.id;
      if (result.any(filter)) {
        result.firstWhere(filter).value += transaction.value;
      } else {
        result.add(
          Transactions(
            id: 'any',
            category: transaction.category,
            dateTime: transaction.dateTime,
            title: transaction.title,
            description: transaction.description,
            value: transaction.value,
            type: transaction.category.transactionType,
          ),
        );
      }
    }

    return result;
  }

  changePeriod(Period newPeriod, {DateTime? begin, DateTime? end}) {
    if (begin != null && end != null) {
      customBegin = begin;
      customEnd = end;
    }

    period = newPeriod;

    notifyListeners();
  }

  getTransactions() {
    var dates = getIt<AppUtils>().getDateRange(Period.monthly, _today);

    getIt<TransactionsService>().listTransactionsByTimeRange(dates[0], dates[1]).then(
      (value) {
        _monthlyTransactions.clear();
        _monthlyTransactions.addAll(value);

        notifyListeners();
      },
    );
  }

  DateTime get _today {
    var now = DateTime.now();

    return DateTime(now.year, now.month, now.day);
  }

  String get totalBalance {
    return Provider.of<AccountManager>(context).account.value.toStringAsFixed(2);
  }
}
