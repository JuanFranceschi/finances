import 'package:flutter/material.dart';

class PeriodButtonWidget extends StatelessWidget {
  final bool active;
  final String text;
  final Function() onTap;

  const PeriodButtonWidget(
      {super.key, required this.active, required this.text, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(active ? 1 : 0),
          borderRadius: BorderRadius.circular(10),
        ),
        height: double.infinity,
        child: Center(
          child: Text(
            text,
          ),
        ),
      ),
    );
  }
}
