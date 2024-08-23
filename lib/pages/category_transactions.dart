import 'package:finances/components/back_header.dart';
import 'package:finances/components/home/category_card.dart';
import 'package:finances/components/global/transaction_line.dart';
import 'package:finances/models/category.dart';
import 'package:finances/models/transactions.dart';
import 'package:finances/services/transactions_service.dart';
import 'package:finances/utils/app_utils.dart';
import 'package:finances/utils/enums.dart';
import 'package:finances/utils/get_it.dart';
import 'package:flutter/material.dart';

class CategoryTransactionsPage extends StatefulWidget {
  final Category category;
  const CategoryTransactionsPage({super.key, required this.category});

  @override
  State<CategoryTransactionsPage> createState() => _CategoryTransactionsPageState();
}

class _CategoryTransactionsPageState extends State<CategoryTransactionsPage> {
  final List<Transactions> _transactions = List.empty(growable: true);

  @override
  void initState() {
    _listTransactions();
    super.initState();
  }

  _listTransactions() {
    final dates = getIt<AppUtils>().getDateRange(Period.monthly, getIt<AppUtils>().today);

    getIt<TransactionsService>()
        .listTransactionsByTimeRange(dates[0], dates[1], category: widget.category)
        .then((result) {
      setState(() => _transactions.addAll(result));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackHeaderWidget(title: widget.category.name),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CategoryCardWidget(
                category: widget.category,
                totalSpent: _transactions.fold(
                    0.0, (previousValue, element) => previousValue += element.value),
              ),
              const SizedBox(height: 20),
              for (var transaction in _transactions)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TransactionLineWidget(transaction: transaction, onLongPress: () {}),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
