import 'package:flutter/material.dart';

class ReportsCardWidget extends StatelessWidget {
  final String title, value;

  const ReportsCardWidget({super.key, required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: Theme.of(context).colorScheme.tertiary),
            maxLines: 1,
          ),
          const Spacer(),
          Text(value, style: Theme.of(context).textTheme.headlineMedium!)
        ],
      ),
    );
  }
}
