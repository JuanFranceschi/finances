import 'package:finances/components/home/categories_tab.dart';
import 'package:finances/components/home/header.dart';
import 'package:finances/components/home/period_switch.dart';
import 'package:finances/components/home/reports_tab.dart';
import 'package:finances/components/home/transactions_tab.dart';
import 'package:finances/controllers/home_controller.dart';
import 'package:finances/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final TabController _controller;
  late final HomeController _homeController;

  @override
  void initState() {
    _controller = TabController(length: 3, vsync: this)
      ..addListener(() => setState(() => _controller));
    _homeController = HomeController(context: context)..getTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeHeaderWidget(),
            Expanded(
              child: Stack(
                children: [
                  ChangeNotifierProvider(
                      create: (context) => _homeController,
                      builder: (context, snapshot) {
                        return Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: PeriodSwitchWidget(),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: TabBarView(
                                controller: _controller,
                                children: const [
                                  TransactionsTabWidget(),
                                  CategoriesTabWidget(),
                                  ReportsTabWidget(),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                  Positioned(
                    bottom: 25,
                    left: 25,
                    right: 105,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 25,
                    left: 25,
                    right: 25,
                    child: Row(
                      children: [
                        Expanded(
                          child: TabBar(
                            controller: _controller,
                            dividerColor: Colors.transparent,
                            indicator: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelColor: Theme.of(context).colorScheme.primaryContainer,
                            splashBorderRadius: BorderRadius.circular(15),
                            tabs: const [
                              Tab(
                                icon: Icon(Symbols.receipt_long_rounded),
                              ),
                              Tab(
                                icon: Icon(Symbols.dataset_rounded),
                              ),
                              Tab(
                                icon: Icon(Symbols.bar_chart_rounded),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Center(
                            child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, AppRoutes.createTransaction)
                                      .then((value) {
                                    _homeController.getTransactions();
                                  });
                                },
                                label: const Icon(Symbols.add)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
