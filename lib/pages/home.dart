import 'package:finances/components/home/categories_tab.dart';
import 'package:finances/components/home/custom_tab_item.dart';
import 'package:finances/components/home/header.dart';
import 'package:finances/components/home/period_switch.dart';
import 'package:finances/components/home/transactions_tab.dart';
import 'package:finances/controllers/home_controller.dart';
import 'package:finances/utils/routes.dart';
import 'package:flutter/material.dart';
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
    _controller = TabController(length: 2, vsync: this)
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
                                  // TransactionsTabWidget(),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                  Positioned(
                    bottom: 25,
                    left: 25,
                    right: 25,
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(.85),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Row(
                        children: [
                          CustomTabItem(
                            onTap: () => setState(() {
                              _controller.animateTo(0);
                            }),
                            icon: Icons.monetization_on_rounded,
                            selected: _controller.index == 0,
                          ),
                          CustomTabItem(
                            onTap: () => setState(() {
                              _controller.animateTo(1);
                            }),
                            icon: Icons.dataset,
                            selected: _controller.index == 1,
                          ),
                          // CustomTabItem(
                          //   onTap: () => setState(() {
                          //     _controller.animateTo(2);
                          //   }),
                          //   icon: Icons.graphic_eq,
                          //   selected: _controller.index == 2,
                          // ),
                          CustomTabItem(
                            onTap: () => Navigator.pushNamed(context, AppRoutes.createTransaction)
                                .then((value) => _homeController.getTransactions()),
                            icon: Icons.add,
                            selected: false,
                          ),
                        ],
                      ),
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
