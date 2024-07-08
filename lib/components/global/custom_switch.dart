import 'package:finances/components/home/period_button.dart';
import 'package:flutter/material.dart';

class CustomSwitchWidget extends StatelessWidget {
  final Map<Enum, String> options;
  final Enum selected;
  final Function(Enum newSelection) onTap;

  const CustomSwitchWidget(
      {super.key, required this.options, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(15),
      ),
      height: 40,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          const SizedBox(width: 5),
          for (var entry in options.entries) ...[
            Expanded(
              child: PeriodButtonWidget(
                active: selected == entry.key,
                text: entry.value,
                onTap: () => onTap(entry.key),
              ),
            ),
            const SizedBox(width: 5)
          ]
        ],
      ),
    );
  }
}
