import 'package:finances/utils/account_manager.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class VisibilityButtonWidget extends StatelessWidget {
  const VisibilityButtonWidget({super.key = const Key('Visibility')});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Provider.of<AccountManager>(context, listen: false).updateShowValues(),
      icon: Icon(
        Provider.of<AccountManager>(context).showValues
            ? Symbols.visibility
            : Symbols.visibility_off,
        color: Theme.of(context).colorScheme.tertiary,
      ),
    );
  }
}
