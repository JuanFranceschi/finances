import 'package:finances/components/global/visibility_button.dart';
import 'package:flutter/material.dart';

class BackHeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const BackHeaderWidget({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 16),
      ),
      centerTitle: true,
      actions: const [
        VisibilityButtonWidget(),
      ],
    );
  }
}
