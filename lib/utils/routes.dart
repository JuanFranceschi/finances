import 'package:finances/pages/create/account.dart';
import 'package:finances/pages/create/transaction.dart';
import 'package:finances/pages/home.dart';
import 'package:finances/pages/settings.dart';
import 'package:finances/pages/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String home = 'home',
      splash = 'splash',
      settings = 'settings',
      createAccount = 'create/account',
      createTransaction = 'create/transaction',
      createCategory = 'create/category',
      categoryTransactions = 'category/transactions';

  static Map<String, WidgetBuilder> routesBuilder = {
    splash: (BuildContext context) => const SplashScreen(),
    createAccount: (BuildContext context) => const CreateAccountPage(),
    home: (BuildContext context) => const HomePage(),
    createTransaction: (BuildContext context) => const CreateTransaction(),
    settings: (BuildContext context) => const SettingsPage(),
  };
}
