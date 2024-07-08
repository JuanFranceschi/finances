import 'package:flutter/material.dart';

class CustomCardWidget extends StatelessWidget {
  final Widget child;

  const CustomCardWidget({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: double.infinity, minHeight: 40),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(20),
      child: child,
    );
  }
}
