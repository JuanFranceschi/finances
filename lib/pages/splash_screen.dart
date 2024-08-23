import 'package:finances/services/account_service.dart';
import 'package:finances/services/preferences_service.dart';
import 'package:finances/utils/account_manager.dart';
import 'package:finances/utils/get_it.dart';
import 'package:finances/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool preferencesSetup = false;
  @override
  void initState() {
    super.initState();

    ensureInitialization();
  }

  ensureInitialization() async {
    var account = await getIt<AccountService>().getAccount();
    if (!preferencesSetup) {
      await getIt<PreferencesService>().setup();
      preferencesSetup = true;
    }

    try {
      getIt<PreferencesService>().getDefaultPeriod;
    } catch (e) {
      ensureInitialization();

      return;
    }

    if (!mounted) return;

    Provider.of<AccountManager>(context, listen: false).updateShowValues(
      value: getIt<PreferencesService>().getVisibility,
    );

    if (account == null) {
      Navigator.pushNamed(context, AppRoutes.createAccount).then((value) => ensureInitialization());
    } else {
      await Provider.of<AccountManager>(context, listen: false).updateAccount();

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
