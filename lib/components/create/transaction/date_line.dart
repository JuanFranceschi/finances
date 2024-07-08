import 'package:finances/utils/app_locale.dart';
import 'package:finances/utils/app_utils.dart';
import 'package:finances/utils/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class DateLineWidget extends StatelessWidget {
  final DateTime? date;
  final bool selected;
  final Function() onTap;

  const DateLineWidget(
      {super.key, required this.date, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 40, maxHeight: 40, minWidth: 80),
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).focusColor : null,
          borderRadius: BorderRadius.circular(20),
          border: selected
              ? null
              : Border.all(
                  color: Theme.of(context).focusColor,
                ),
        ),
        child: Center(
          child: Text(
            date == null
                ? AppLocale.custom.getString(context)
                : getIt<AppUtils>().shortDateTime(date!, context, onlyDay: true),
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: selected ? Colors.white : null),
          ),
        ),
      ),
    );
  }
}
