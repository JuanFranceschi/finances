import 'package:finances/models/account.dart';
import 'package:finances/services/account_service.dart';
import 'package:finances/utils/app_locale.dart';
import 'package:finances/utils/get_it.dart';
import 'package:finances/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Text(
                AppLocale.welcome.getString(context),
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                AppLocale.toGetStarted.getString(context),
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w100,
                    ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              TextField(
                controller: _textEditingController,
              ),
              const Spacer(),
              Text(
                AppLocale.yourNameWillHelpUs.getString(context),
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w100,
                    ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 4),
              ElevatedButton(
                onPressed: () async {
                  Account account = Account(
                    owner: _textEditingController.value.text,
                    value: 0,
                  );

                  await getIt<AccountService>().createOrUpdateAccount(account);

                  if (context.mounted) {
                    Navigator.pushNamed(context, AppRoutes.onboarding).then((value) {
                      Navigator.pop(context);
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  AppLocale.continueLbl.getString(context),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
