import 'package:finances/components/home/reports/graphic.dart';
import 'package:finances/components/home/reports_card.dart';
import 'package:finances/controllers/home_controller.dart';
import 'package:finances/models/transactions.dart';
import 'package:finances/utils/account_manager.dart';
import 'package:finances/utils/app_locale.dart';
import 'package:finances/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class ReportsTabWidget extends StatefulWidget {
  const ReportsTabWidget({super.key});

  @override
  State<ReportsTabWidget> createState() => _ReportsTabWidgetState();
}

class _ReportsTabWidgetState extends State<ReportsTabWidget> {
  HomeController get provListenFalse => Provider.of(context, listen: false);
  HomeController get provListenTrue => Provider.of(context);

  Period get period => provListenTrue.period;
  get _visibility => Provider.of<AccountManager>(context).showValues;

  double get totalSpent {
    return activeTransactions
        .where((obj) => obj.type == TransactionType.expenses)
        .fold(0.0, (previousValue, element) => previousValue + element.value);
  }

  double get totalGain {
    return activeTransactions
        .where((obj) => obj.type == TransactionType.income)
        .fold(0.0, (previousValue, element) => previousValue + element.value);
  }

  List<Transactions> get activeTransactions => provListenTrue.activeTransactions;

  @override
  Widget build(BuildContext context) {
    if (!_visibility) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: 25),
            Center(
              child: Opacity(
                opacity: .5,
                child: Icon(
                  Symbols.visibility_off_rounded,
                  size: 34,
                ),
              ),
            )
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GraphicWidget(
            transactions:
                activeTransactions.where((obj) => obj.type == TransactionType.expenses).toList(),
            period: period,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ReportsCardWidget(
                  title: AppLocale.totalSpent.getString(context),
                  value: '\$${totalSpent.toStringAsFixed(2)}',
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ReportsCardWidget(
                  title: AppLocale.totalGain.getString(context),
                  value: '\$${totalGain.toStringAsFixed(2)}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(
            color: Theme.of(context).colorScheme.tertiary.withOpacity(.2),
            indent: 15,
            endIndent: 15,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ReportsCardWidget(
                  title: AppLocale.totalTransactions.getString(context),
                  value: activeTransactions.length.toString(),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ReportsCardWidget(
                  title: AppLocale.categoriesCount.getString(context),
                  value: (provListenTrue.totalByCategory.length +
                          provListenTrue.totalByCategoryIncome.length)
                      .toString(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ReportsCardWidget(
                  title: AppLocale.mostSpentCategory.getString(context),
                  value: provListenTrue.totalByCategory.isEmpty
                      ? '-'
                      : provListenTrue.totalByCategory
                          .reduce((a, b) => a.value > b.value ? a : b)
                          .category
                          .name,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ReportsCardWidget(
                  title: AppLocale.mostProfitableCategory.getString(context),
                  value: provListenTrue.totalByCategoryIncome.isEmpty
                      ? '-'
                      : provListenTrue.totalByCategoryIncome
                          .reduce((a, b) => a.value > b.value ? a : b)
                          .category
                          .name,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
