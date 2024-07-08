import 'package:flutter/material.dart';

class CustomTabItem extends StatelessWidget {
  final Function() onTap;
  final IconData icon;
  final bool selected;

  const CustomTabItem({
    super.key,
    required this.onTap,
    required this.icon,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
        ),
        child: AnimatedContainer(
          height: 75,
          duration: const Duration(milliseconds: 400),
          decoration: BoxDecoration(
            color: selected
                ? Theme.of(context).colorScheme.primaryContainer
                : null,
            borderRadius: BorderRadius.circular(35),
          ),
          child: Center(
            child: Icon(
              icon,
              size: 40,
              color: selected
                  ? Theme.of(context).focusColor
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
