import 'package:finances/components/global/custom_switch.dart';
import 'package:finances/components/home/category_bottom_modal.dart';
import 'package:finances/components/home/category_card.dart';
import 'package:finances/controllers/home_controller.dart';
import 'package:finances/models/category.dart';
import 'package:finances/models/transactions.dart';
import 'package:finances/services/category_service.dart';
import 'package:finances/utils/app_locale.dart';
import 'package:finances/utils/enums.dart';
import 'package:finances/utils/get_it.dart';
import 'package:finances/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class CategoriesTabWidget extends StatefulWidget {
  const CategoriesTabWidget({super.key});

  @override
  State<CategoriesTabWidget> createState() => _CategoriesTabWidgetState();
}

class _CategoriesTabWidgetState extends State<CategoriesTabWidget> {
  HomeController get provListenFalse => Provider.of(context, listen: false);
  HomeController get provListenTrue => Provider.of(context);

  var _type = TransactionType.expenses;
  Future<List<Category>> _categoriesBuilder =
      getIt<CategoryService>().listCategories();
  List<Transactions> get totalCategories => _type == TransactionType.income
      ? provListenTrue.totalByCategoryIncome
      : provListenTrue.totalByCategory;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSwitchWidget(
            options: {
              TransactionType.expenses: AppLocale.expense.getString(context),
              TransactionType.income: AppLocale.income.getString(context),
            },
            selected: _type,
            onTap: (value) {
              setState(() {
                _type = value as TransactionType;
                _categoriesBuilder =
                    getIt<CategoryService>().listCategories(type: _type);
              });
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.createCategory)
                  .then((value) {
                setState(() {
                  _categoriesBuilder =
                      getIt<CategoryService>().listCategories(type: _type);
                });
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              minimumSize: const Size(double.infinity, 40),
              elevation: 0,
            ),
            child: Icon(
              Symbols.add,
              color: Theme.of(context).focusColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            (_type == TransactionType.expenses
                    ? AppLocale.expenseCategories
                    : AppLocale.incomeCategories)
                .getString(context),
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder(
                future: _categoriesBuilder,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    snapshot.data!.sort((a, b) {
                      double aValue = 0;
                      double bValue = 0;

                      bool whereA(Transactions obj) => obj.category.id == a.id;

                      bool whereB(Transactions obj) => obj.category.id == b.id;

                      if (totalCategories.any(whereA)) {
                        aValue = totalCategories.firstWhere(whereA).value;
                      }

                      if (totalCategories.any(whereB)) {
                        bValue = totalCategories.firstWhere(whereB).value;
                      }

                      return bValue.compareTo(aValue);
                    });

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          for (Category category in snapshot.data!) ...[
                            CategoryCardWidget(
                              category: category,
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.categoryTransactions,
                                arguments: category,
                              ),
                              onLongPress: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => CategoryBottomModal(
                                    category: category,
                                    onAction: () {
                                      provListenFalse.getTransactions();
                                      setState(() {
                                        _categoriesBuilder =
                                            getIt<CategoryService>()
                                                .listCategories(type: _type);
                                      });
                                    },
                                  ),
                                );
                              },
                              totalSpent: totalCategories.any(
                                      (obj) => obj.category.id == category.id)
                                  ? totalCategories
                                      .where((obj) =>
                                          obj.category.id == category.id)
                                      .first
                                      .value
                                  : 0,
                            ),
                            const SizedBox(height: 10),
                          ],
                          const SizedBox(height: 100),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
          ),
        ],
      ),
    );
  }
}
