import 'package:finances/models/transactions.dart';
import 'package:finances/services/transactions_service.dart';
import 'package:finances/utils/app_locale.dart';
import 'package:finances/utils/get_it.dart';
import 'package:finances/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:material_symbols_icons/symbols.dart';

class TransactionBottomModal extends StatelessWidget {
  final Transactions transactions;
  final Function() onAction;
  const TransactionBottomModal({super.key, required this.transactions, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(
                  context,
                  AppRoutes.createTransaction,
                  arguments: transactions,
                ).then((value) => onAction());
              },
              child: Row(
                children: [
                  const Icon(
                    Symbols.edit,
                    size: 16,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    AppLocale.edit.getString(context),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.tertiary,
            ),
            TextButton(
              onPressed: () async {
                await getIt<TransactionsService>().deleteTransaction(transactions, context);

                if (context.mounted) {
                  Navigator.pop(context);
                  onAction();
                }
              },
              child: Row(
                children: [
                  Icon(
                    Symbols.delete,
                    size: 16,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    AppLocale.delete.getString(context),
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
