import 'package:finances/components/global/visibility_button.dart';
import 'package:finances/utils/account_manager.dart';
import 'package:finances/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
              icon: const Icon(Symbols.menu),
            ),
            Expanded(
              child: Text(
                'Olá ${Provider.of<AccountManager>(context).account.owner}!',
                textAlign: TextAlign.center,
              ),
            ),
            const VisibilityButtonWidget(),
          ],
        ),
      ),
    );
  }
}
