import 'package:finances/pages/create/account.dart';
import 'package:finances/pages/home.dart';
import 'package:finances/pages/onboarding.dart';
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
      categoryTransactions = 'category/transactions',
      onboarding = 'onboarding';

  static Map<String, WidgetBuilder> routesBuilder = {
    splash: (BuildContext context) => const SplashScreen(),
    createAccount: (BuildContext context) => const CreateAccountPage(),
    onboarding: (BuildContext context) => const OnboardingPage(),
    home: (BuildContext context) => const HomePage(),
    settings: (BuildContext context) => const SettingsPage(),
  };
}
