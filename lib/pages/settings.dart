import 'package:finances/components/back_header.dart';
import 'package:finances/components/global/custom_switch.dart';
import 'package:finances/services/account_service.dart';
import 'package:finances/services/preferences_service.dart';
import 'package:finances/utils/account_manager.dart';
import 'package:finances/utils/app_locale.dart';
import 'package:finances/utils/enums.dart';
import 'package:finances/utils/get_it.dart';
import 'package:finances/utils/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final TextEditingController nameEditingController;

  @override
  void initState() {
    nameEditingController = TextEditingController(
        text: Provider.of<AccountManager>(context, listen: false).account.owner);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackHeaderWidget(title: AppLocale.settings.getString(context)),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocale.defaultPeriod.getString(context)),
            const SizedBox(height: 5),
            CustomSwitchWidget(
                options: {
                  Period.weekly: AppLocale.weekly.getString(context),
                  Period.monthly: AppLocale.monthly.getString(context),
                },
                selected: getIt<PreferencesService>().getDefaultPeriod,
                onTap: (value) async {
                  await getIt<PreferencesService>().setDefaultPeriod(value as Period);
                  setState(() {});
                }),
            const SizedBox(height: 20),
            Text(AppLocale.theme.getString(context)),
            const SizedBox(height: 5),
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
            const SizedBox(height: 20),
            Text(AppLocale.defaultVisibility.getString(context)),
            const SizedBox(height: 5),
            CustomSwitchWidget(
                options: {
                  ThemeMode.dark: AppLocale.visible.getString(context),
                  ThemeMode.light: AppLocale.notVisible.getString(context),
                },
                selected:
                    getIt<PreferencesService>().getVisibility ? ThemeMode.dark : ThemeMode.light,
                onTap: (value) async {
                  if (value is ThemeMode) {
                    if (value == ThemeMode.dark) {
                      await getIt<PreferencesService>().setDefaultVisibility(true);
                    } else {
                      await getIt<PreferencesService>().setDefaultVisibility(false);
                    }

                    if (mounted) {
                      setState(() {});
                    }
                  }
                }),
            const SizedBox(height: 20),
            Text(AppLocale.name.getString(context)),
            const SizedBox(height: 5),
            TextField(
              controller: nameEditingController,
              onSubmitted: (value) async {
                await getIt<AccountService>().updateName(value);

                if (context.mounted) {
                  Provider.of<AccountManager>(context, listen: false).updateAccount();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
