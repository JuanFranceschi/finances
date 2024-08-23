import 'package:finances/models/category.dart';
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
    required this.totalSpent,
    this.onTap,
    this.onLongPress,
  });

  final Category category;
  final double totalSpent;
  final Function()? onTap, onLongPress;

  double get percentageSpent {
    if (category.plannedOutlay > 0) {
      return totalSpent / category.plannedOutlay;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Ink(
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(15),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${AppLocale.estimate.getString(context)}: ${Provider.of<AccountManager>(context).showValues ? getIt<AppUtils>().moneyToString(category.plannedOutlay) : '-'}',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                color: Theme.of(context).colorScheme.tertiary),
                      ),
                      Text(
                        '${category.transactionType == TransactionType.expenses ? AppLocale.totalSpent.getString(context) : AppLocale.totalGain.getString(context)}: ${Provider.of<AccountManager>(context).showValues ? getIt<AppUtils>().moneyToString(totalSpent) : '-'}',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                color: Theme.of(context).colorScheme.tertiary),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: LinearProgressIndicator(
                                minHeight: 10,
                                value: percentageSpent,
                                backgroundColor: Colors.black12,
                                borderRadius: BorderRadius.circular(5),
                                color: category.color,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Center(
                              child: Text(Provider.of<AccountManager>(context)
                                      .showValues
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
      ),
    );
  }
}
