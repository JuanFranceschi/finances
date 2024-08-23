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
            color: selected ? Theme.of(context).colorScheme.primary : null,
            borderRadius: BorderRadius.circular(35),
          ),
          curve: Curves.easeOutQuart,
          child: Center(
            child: Stack(
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
                AnimatedOpacity(
                  opacity: selected ? 1 : 0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutQuart,
                  child: Icon(
                    icon,
                    size: 40,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
