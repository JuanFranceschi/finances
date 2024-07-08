import 'package:finances/components/global/custom_switch.dart';
import 'package:finances/components/home/category_card.dart';
import 'package:finances/controllers/home_controller.dart';
import 'package:finances/models/category.dart';
import 'package:finances/services/category_service.dart';
import 'package:finances/utils/app_locale.dart';
import 'package:finances/utils/enums.dart';
import 'package:finances/utils/get_it.dart';
import 'package:finances/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
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
  Future<List<Category>> _categoriesBuilder = getIt<CategoryService>().listCategories();

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
                _categoriesBuilder = getIt<CategoryService>().listCategories(type: _type);
              });
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.createCategory).then((value) {
                setState(() {
                  _categoriesBuilder = getIt<CategoryService>().listCategories(type: _type);
                });
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              minimumSize: const Size(double.infinity, 40),
              elevation: 0,
            ),
            child: Icon(
              Icons.add,
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
                    var totalCategories =
                        provListenFalse.totalByCategory(provListenTrue.activeTransactions);
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          for (Category category in snapshot.data!) ...[
                            InkWell(
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.categoryTransactions,
                                arguments: category,
                              ),
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: CategoryCardWidget(
                                category: category,
                                totalCategories: totalCategories,
                              ),
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
