import 'package:finances/components/global/transaction_line.dart';
import 'package:finances/components/home/transaction_bottom_modal.dart';
import 'package:finances/controllers/home_controller.dart';
import 'package:finances/models/transactions.dart';
import 'package:finances/utils/account_manager.dart';
import 'package:finances/utils/app_locale.dart';
import 'package:finances/utils/enums.dart';
import 'package:finances/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';

class TransactionsTabWidget extends StatefulWidget {
  const TransactionsTabWidget({super.key});

  @override
  State<TransactionsTabWidget> createState() => _TransactionsTabWidgetState();
}

class _TransactionsTabWidgetState extends State<TransactionsTabWidget> {
  HomeController get provListenFalse => Provider.of(context, listen: false);
  HomeController get provListenTrue => Provider.of(context);

  Period get period => provListenTrue.period;
  get _visibility => Provider.of<AccountManager>(context).showValues;
  get _totalBalance => provListenTrue.totalBalance;

  double get totalSpent {
    double sum = 0;

    for (var obj in activeTransactions.where((obj) => obj.type == TransactionType.expenses)) {
      sum += obj.value;
    }

    return sum;
  }

  List<Transactions> get activeTransactions => provListenTrue.activeTransactions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocale.totalBalance.getString(context),
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 45,
            child: _visibility
                ? Text(
                    '\$$_totalBalance',
                    style: Theme.of(context).textTheme.displayMedium,
                  )
                : Column(
                    children: [
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.only(right: 200),
                        height: 4,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
          ),
          const SizedBox(height: 20),
          Container(
            constraints: const BoxConstraints(
              minWidth: double.infinity,
              minHeight: 120,
              maxHeight: 120,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocale.totalSpent.getString(context),
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                ),
                SizedBox(
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _visibility
                        ? Text(
                            '\$${totalSpent.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.displaySmall,
                          )
                        : Container(
                            margin: const EdgeInsets.only(right: 200),
                            height: 4,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    for (var obj in provListenTrue.totalByCategory) ...[
                      Expanded(
                        flex: (obj.value / totalSpent * 100).round(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: obj.category.color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          height: 8,
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (activeTransactions.isNotEmpty) ...[
            Text(
              AppLocale.transactions.getString(context),
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
            ),
            const SizedBox(height: 10),
          ],
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (activeTransactions.isEmpty)
                    Center(
                      child: Text(
                        AppLocale.clickToAdd.getString(context),
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ),
                  for (var transaction in activeTransactions)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TransactionLineWidget(
                        transaction: transaction,
                        onLongPress: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => TransactionBottomModal(
                              transactions: transaction,
                              onAction: () => provListenFalse.getTransactions(),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
