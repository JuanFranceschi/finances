import 'package:finances/components/back_header.dart';
import 'package:finances/components/global/custom_switch.dart';
import 'package:finances/services/account_service.dart';
import 'package:finances/utils/app_locale.dart';
import 'package:finances/utils/get_it.dart';
import 'package:finances/utils/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackHeaderWidget(title: AppLocale.settings),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocale.theme.getString(context)),
            const SizedBox(height: 10),
            CustomSwitchWidget(
                options: {
                  ThemeMode.system: AppLocale.themeSystem.getString(context),
                  ThemeMode.dark: AppLocale.themeDark.getString(context),
                  ThemeMode.light: AppLocale.themeLight.getString(context),
                },
                selected: Provider.of<ThemeManager>(context).themeMode,
                onTap: (value) {
                  Provider.of<ThemeManager>(context, listen: false).toggleTheme(value as ThemeMode);

                  getIt<AccountService>().updateThemeMode(value);
                }),
          ],
        ),
      ),
    );
  }
}
