import 'package:finances/models/transactions.dart';
import 'package:finances/utils/account_manager.dart';
import 'package:finances/utils/app_utils.dart';
import 'package:finances/utils/enums.dart';
import 'package:finances/utils/get_it.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionLineWidget extends StatelessWidget {
  final Transactions transaction;
  final Function()? onLongPress, onTap;

  const TransactionLineWidget(
      {super.key, required this.transaction, this.onLongPress, this.onTap});

  String get valueText =>
      (transaction.category.transactionType == TransactionType.expenses
          ? '-'
          : '+') +
      transaction.value.toStringAsFixed(2).replaceAll('.00', '');

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                // color: transaction.category.color,
                border: Border.all(color: transaction.category.color),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  transaction.category.icon,
                  size: 25,
                  // color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    transaction.title,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontSize: 16),
                  ),
                  Text(
                    getIt<AppUtils>()
                        .shortDateTime(transaction.dateTime, context),
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 60, minWidth: 60),
              child: Provider.of<AccountManager>(context).showValues
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        valueText,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontSize: 16,
                              color: transaction.type == TransactionType.income
                                  ? Colors.green
                                  : null,
                            ),
                        maxLines: 1,
                      ),
                    )
                  : Center(
                      child: Container(
                        height: 4,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 10)
          ],
        ),
      ),
    );
  }
}
