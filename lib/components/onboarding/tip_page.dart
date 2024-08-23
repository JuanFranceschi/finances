import 'package:finances/utils/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class TipPageWidget extends StatelessWidget {
  final IconData icon;
  final String description;

  final bool endButton;

  const TipPageWidget({
    super.key,
    required this.icon,
    required this.description,
    this.endButton = false,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            Icon(
              icon,
              size: 80,
            ),
            const SizedBox(height: 20),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 5),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: endButton
                  ? ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(double.infinity, 50),
                      ),
                      child: Text(
                        AppLocale.ready.getString(context),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
