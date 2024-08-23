import 'dart:async';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:finances/components/back_header.dart';
import 'package:finances/components/create/transaction/choose_category.dart';
import 'package:finances/components/create/transaction/date_line.dart';
import 'package:finances/components/global/card.dart';
import 'package:finances/components/global/category_vertical.dart';
import 'package:finances/components/global/custom_switch.dart';
import 'package:finances/models/category.dart';
import 'package:finances/models/transactions.dart';
import 'package:finances/services/category_service.dart';
import 'package:finances/services/transactions_service.dart';
import 'package:finances/utils/app_locale.dart';
import 'package:finances/utils/enums.dart';
import 'package:finances/utils/get_it.dart';
import 'package:finances/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:uuid/uuid.dart';

class CreateTransaction extends StatefulWidget {
  final Transactions? transaction;
  const CreateTransaction({super.key, this.transaction});

  @override
  State<CreateTransaction> createState() => _CreateTransactionState();
}

class _CreateTransactionState extends State<CreateTransaction> {
  final TextEditingController _valueEditingController = TextEditingController();
  final TextEditingController _titleEditingController = TextEditingController();
  final CurrencyTextInputFormatter mask =
      CurrencyTextInputFormatter.currency(symbol: '\$');
  Category? _category;
  DateTime _date = DateTime.now();
  TransactionType _type = TransactionType.expenses;

  DateTime get _dateNow => DateTime.now();
  DateTime get _dateYesterday => DateTime.now().subtract(
        const Duration(days: 1),
      );

  Future<List<Category>> _listCategories =
      getIt<CategoryService>().listCategories(
    limit: 7,
    type: TransactionType.expenses,
  );

  @override
  void initState() {
    if (widget.transaction != null) {
      _valueEditingController.text =
          mask.formatDouble(widget.transaction!.value);
      _titleEditingController.text = widget.transaction!.title;
      _category = widget.transaction!.category;
      _date = widget.transaction!.dateTime;
      _type = widget.transaction!.type;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          BackHeaderWidget(title: AppLocale.newTransaction.getString(context)),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomSwitchWidget(
                      options: {
                        TransactionType.expenses:
                            AppLocale.expense.getString(context),
                        TransactionType.income:
                            AppLocale.income.getString(context),
                      },
                      selected: _type,
                      onTap: (value) {
                        setState(() {
                          _type = value as TransactionType;
                          _listCategories =
                              getIt<CategoryService>().listCategories(
                            limit: 7,
                            type: _type,
                          );
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomCardWidget(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedOpacity(
                            opacity:
                                _titleEditingController.text.isEmpty ? 1 : .5,
                            duration: const Duration(milliseconds: 400),
                            child: Text(
                              AppLocale.title.getString(context),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextField(
                            controller: _titleEditingController,
                            onChanged: (value) =>
                                setState(() => _titleEditingController),
                          ),
                          const SizedBox(height: 20),
                          AnimatedOpacity(
                            opacity:
                                _valueEditingController.text.isEmpty ? 1 : .5,
                            duration: const Duration(milliseconds: 400),
                            child: Text(
                              AppLocale.value.getString(context),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextField(
                            controller: _valueEditingController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [mask],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomCardWidget(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Opacity(
                            opacity: .5,
                            child: Text(
                              AppLocale.date.getString(context),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: DateLineWidget(
                                  date: DateTime.now(),
                                  selected: _date.day == _dateNow.day,
                                  onTap: () {
                                    setState(() => _date = _dateNow);
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DateLineWidget(
                                  date: _dateYesterday,
                                  selected: _date.day == _dateYesterday.day,
                                  onTap: () {
                                    setState(() => _date = _dateYesterday);
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DateLineWidget(
                                  date: _date.day != _dateYesterday.day &&
                                          _date.day != _dateNow.day
                                      ? _date
                                      : null,
                                  selected: _date.day != _dateYesterday.day &&
                                      _date.day != _dateNow.day,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now()
                                          .subtract(const Duration(days: 9999)),
                                      lastDate: DateTime.now(),
                                    ).then((date) {
                                      if (date != null) {
                                        setState(() => _date = date);
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomCardWidget(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedOpacity(
                            opacity: _category == null ? 1 : .5,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOutQuart,
                            child: Text(
                              AppLocale.category.getString(context),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: double.infinity,
                            height: (110 * 2) + 10,
                            child: FutureBuilder(
                              future: _listCategories,
                              builder: (context, snapshot) {
                                bool spaceBetween = snapshot.hasData &&
                                    snapshot.data!.length >= 3;
                                bool showMore = snapshot.hasData &&
                                    snapshot.data!.length >= 7;
                                bool chosenIsInSnap = _category == null ||
                                    snapshot.data!
                                        .any((cat) => cat.id == _category?.id);
                                if (snapshot.hasData) {
                                  return Wrap(
                                    runSpacing: 10,
                                    alignment: spaceBetween
                                        ? WrapAlignment.spaceBetween
                                        : WrapAlignment.start,
                                    children: [
                                      if (_category != null && !chosenIsInSnap)
                                        CategoryVertical(
                                          category: _category!,
                                          onTap: () {},
                                          selected: true,
                                        ),
                                      for (var i = 0;
                                          i <
                                              snapshot.data!.length -
                                                  (chosenIsInSnap ? 0 : 1);
                                          i++)
                                        CategoryVertical(
                                          category: snapshot.data![i],
                                          onTap: () {
                                            setState(() {
                                              _category = snapshot.data![i];
                                            });
                                          },
                                          selected: _category?.id ==
                                              snapshot.data![i].id,
                                        ),
                                      CategoryVertical(
                                        category: Category(
                                          id: '',
                                          name: (showMore
                                                  ? AppLocale.other
                                                  : AppLocale.newlbl)
                                              .getString(context),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          icon: showMore
                                              ? Symbols.menu
                                              : Symbols.add,
                                          plannedOutlay: 0,
                                          transactionType:
                                              TransactionType.expenses,
                                        ),
                                        onTap: () {
                                          if (showMore) {
                                            showModalBottomSheet(
                                              context: context,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              builder: (context) =>
                                                  ChooseCategory(type: _type),
                                            ).then((chosen) {
                                              if (chosen != null &&
                                                  chosen is Category) {
                                                setState(
                                                  () => _category = chosen,
                                                );
                                              }
                                            });
                                          } else {
                                            Navigator.pushNamed(
                                              context,
                                              AppRoutes.createCategory,
                                              arguments: _type,
                                            ).then((value) {
                                              setState(() {
                                                _listCategories =
                                                    getIt<CategoryService>()
                                                        .listCategories(
                                                  limit: 7,
                                                  type: _type,
                                                );
                                              });
                                            });
                                          }
                                        },
                                      ),
                                      for (var i = 0;
                                          i < 8 - snapshot.data!.length;
                                          i++)
                                        const SizedBox(
                                          height: 110,
                                          width: 80,
                                        )
                                    ],
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_category != null &&
                  _titleEditingController.text.isNotEmpty &&
                  _valueEditingController.text.isNotEmpty)
                Positioned(
                  bottom: 20,
                  left: 100,
                  right: 100,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (widget.transaction == null) {
                        await getIt<TransactionsService>().insertTransactions(
                          Transactions(
                            id: const Uuid().v4(),
                            category: _category!,
                            dateTime: _date,
                            title: _titleEditingController.text,
                            description: '',
                            type: _category!.transactionType,
                            value: mask.getDouble(),
                          ),
                          context,
                        );
                      } else {
                        await getIt<TransactionsService>().updateTransactions(
                          Transactions(
                            id: widget.transaction!.id,
                            category: _category!,
                            dateTime: _date,
                            title: _titleEditingController.text,
                            description: '',
                            type: _category!.transactionType,
                            value: mask.getDouble(),
                          ),
                          context,
                        );
                      }

                      if (context.mounted) Navigator.pop(context);
                    },
                    child: Text(AppLocale.save.getString(context)),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
