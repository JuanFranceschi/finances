import 'package:finances/utils/app_locale.dart';
import 'package:finances/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class AppUtils {
  DateTime get today {
    var now = DateTime.now();

    return DateTime(now.year, now.month, now.day);
  }

  String shortDateTime(DateTime dateTime, BuildContext context, {bool onlyDay = false}) {
    DateTime now = DateTime.now();

    if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
      return onlyDay
          ? AppLocale.today.getString(context)
          : "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    } else if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day - 1) {
      return AppLocale.yesterday.getString(context);
    } else if (dateTime.year == now.year) {
      return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}";
    } else {
      return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year.toString().substring(2)}";
    }
  }

  List<DateTime> getDateRange(Period rangeType, DateTime referenceDate) {
    switch (rangeType) {
      case Period.weekly:
        return _getWeeklyRange(referenceDate);
      case Period.monthly:
        return _getMonthlyRange(referenceDate);
      default:
        throw ArgumentError('Invalid range type');
    }
  }

  List<DateTime> _getWeeklyRange(DateTime referenceDate) {
    DateTime startOfWeek = referenceDate.subtract(Duration(days: referenceDate.weekday % 7));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 7));
    return [startOfWeek, endOfWeek];
  }

  List<DateTime> _getMonthlyRange(DateTime referenceDate) {
    DateTime startOfMonth = DateTime(referenceDate.year, referenceDate.month, 1);
    DateTime endOfMonth = DateTime(referenceDate.year, referenceDate.month + 1, 1);
    return [startOfMonth, endOfMonth];
  }

  String moneyToString(double value) => '\$${value.toStringAsFixed(2).replaceAll('.00', '')}';
}
