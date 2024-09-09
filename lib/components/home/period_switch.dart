import 'package:finances/components/global/custom_switch.dart';
import 'package:finances/controllers/home_controller.dart';
import 'package:finances/utils/app_locale.dart';
import 'package:finances/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';

class PeriodSwitchWidget extends StatelessWidget {
  const PeriodSwitchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSwitchWidget(
      options: {
        Period.weekly: AppLocale.weekly.getString(context),
        Period.monthly: AppLocale.monthly.getString(context),
        Period.custom: AppLocale.custom.getString(context),
      },
      selected: Provider.of<HomeController>(context).period,
      onTap: (value) {
        if (value as Period == Period.custom) {
          showDateRangePicker(
            context: context,
            firstDate: DateTime(1990),
            lastDate: DateTime.now().add(
              const Duration(days: 365),
            ),
          ).then((dates) {
            if (dates == null) return;

            Provider.of<HomeController>(context, listen: false).changePeriod(
              value,
              begin: dates.start,
              end: dates.end,
            );
          });
        } else {
          Provider.of<HomeController>(context, listen: false)
              .changePeriod(value);
        }
      },
    );
  }
}
