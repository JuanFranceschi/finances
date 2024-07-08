import 'package:finances/models/category.dart';
import 'package:finances/models/transactions.dart';
import 'package:finances/utils/account_manager.dart';
import 'package:finances/utils/app_locale.dart';
import 'package:finances/utils/app_utils.dart';
import 'package:finances/utils/enums.dart';
import 'package:finances/utils/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';

class CategoryCardWidget extends StatelessWidget {
  const CategoryCardWidget({
    super.key,
    required this.category,
    required this.totalCategories,
  });

  final Category category;
  final List<Transactions> totalCategories;

  double get totalSpent => totalCategories.any((obj) => obj.category.id == category.id)
      ? totalCategories.firstWhere((obj) => obj.category.id == category.id).value
      : 0;

  double get percentageSpent => totalSpent > 0
      ? totalCategories.firstWhere((obj) => obj.category.id == category.id).value /
          totalCategories.firstWhere((obj) => obj.category.id == category.id).category.plannedOutlay
      : 0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Row(
          children: [
            Container(
              height: 120,
              width: 10,
              color: category.color,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          category.icon,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            category.name,
                            style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${AppLocale.estimate.getString(context)}: ${Provider.of<AccountManager>(context).showValues ? getIt<AppUtils>().moneyToString(category.plannedOutlay) : '-'}',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: Theme.of(context).colorScheme.tertiary),
                    ),
                    Text(
                      '${category.transactionType == TransactionType.expenses ? AppLocale.totalSpent.getString(context) : AppLocale.totalGain.getString(context)}: ${Provider.of<AccountManager>(context).showValues ? getIt<AppUtils>().moneyToString(totalSpent) : '-'}',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: Theme.of(context).colorScheme.tertiary),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            minHeight: 10,
                            value: percentageSpent,
                            borderRadius: BorderRadius.circular(5),
                            backgroundColor: Colors.black12,
                            color: category.color,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Center(
                            child: Text(Provider.of<AccountManager>(context).showValues
                                ? '${(percentageSpent * 100).toInt()}%'
                                : ''),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
