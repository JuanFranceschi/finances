import 'dart:io';

import 'package:finances/models/category.dart';
import 'package:finances/models/transactions.dart';
import 'package:finances/pages/category_transactions.dart';
import 'package:finances/pages/create/category.dart';
import 'package:finances/pages/create/transaction.dart';
import 'package:finances/services/account_service.dart';
import 'package:finances/services/database_controller.dart';
import 'package:finances/services/preferences_service.dart';
import 'package:finances/utils/account_manager.dart';
import 'package:finances/utils/app_locale.dart';
import 'package:finances/utils/enums.dart';
import 'package:finances/utils/get_it.dart';
import 'package:finances/utils/routes.dart';
import 'package:finances/utils/theme_manager.dart';
import 'package:finances/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupGetIt();

  await getIt<DatabaseController>().setupDatabase();

  var account = await getIt<AccountService>().getAccount();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ThemeManager(
              account?.theme ?? ThemeMode.system,
            ),
          ),
          ChangeNotifierProvider(create: (context) => AccountManager()),
        ],
        child: const MainApp(),
      ),
    );
  });
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  void initState() {
    var languageCode = Platform.localeName;
    if (languageCode.toLowerCase().contains('pt')) {
      languageCode = 'pt';
    } else {
      languageCode = 'en';
    }

    localization.init(
      mapLocales: [
        const MapLocale('en', AppLocale.en),
        const MapLocale('pt', AppLocale.pt),
      ],
      initLanguageCode: languageCode,
    );
    localization.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
      routes: AppRoutes.routesBuilder,
      initialRoute: AppRoutes.splash,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: Provider.of<ThemeManager>(context).themeMode,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case AppRoutes.createCategory:
            return MaterialPageRoute(
              builder: (BuildContext context) {
                if (settings.arguments is TransactionType) {
                  return CreateCategory(
                    type: settings.arguments as TransactionType,
                  );
                } else {
                  return CreateCategory(
                    category: settings.arguments as Category?,
                  );
                }
              },
              settings: settings,
            );
          case AppRoutes.categoryTransactions:
            return MaterialPageRoute(
              builder: (BuildContext context) => CategoryTransactionsPage(
                category: settings.arguments as Category,
              ),
              settings: settings,
            );
          case AppRoutes.createTransaction:
            return MaterialPageRoute(
              builder: (BuildContext context) => CreateTransaction(
                transaction: settings.arguments as Transactions?,
              ),
              settings: settings,
            );
          default:
            return null;
        }
      },
    );
  }
}
