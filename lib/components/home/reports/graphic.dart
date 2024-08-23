import 'package:finances/controllers/home_controller.dart';
import 'package:finances/models/transactions.dart';
import 'package:finances/utils/enums.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ColumnGroup {
  final String label;
  final double value;

  _ColumnGroup({required this.label, required this.value});
}

class GraphicWidget extends StatefulWidget {
  final List<Transactions> transactions;
  final Period period;

  const GraphicWidget({
    super.key,
    required this.transactions,
    required this.period,
  });

  @override
  State<GraphicWidget> createState() => _GraphicWidgetState();
}

class _GraphicWidgetState extends State<GraphicWidget> {
  List<_ColumnGroup> get groups {
    List<_ColumnGroup> result = List.empty(growable: true);

    foldFunction(double previous, Transactions element) {
      return previous + element.value;
    }

    switch (widget.period) {
      case Period.weekly:
        bool valid(Transactions t, int i) {
          return t.dateTime.weekday == i;
        }

        result.addAll([
          _ColumnGroup(
            label: 'D',
            value: widget.transactions.where((t) => valid(t, 7)).fold(0.0, foldFunction),
          ),
          _ColumnGroup(
            label: 'S',
            value: widget.transactions.where((t) => valid(t, 1)).fold(0.0, foldFunction),
          ),
          _ColumnGroup(
            label: 'T',
            value: widget.transactions.where((t) => valid(t, 2)).fold(0.0, foldFunction),
          ),
          _ColumnGroup(
            label: 'Q',
            value: widget.transactions.where((t) => valid(t, 3)).fold(0.0, foldFunction),
          ),
          _ColumnGroup(
            label: 'Q',
            value: widget.transactions.where((t) => valid(t, 4)).fold(0.0, foldFunction),
          ),
          _ColumnGroup(
            label: 'S',
            value: widget.transactions.where((t) => valid(t, 5)).fold(0.0, foldFunction),
          ),
          _ColumnGroup(
            label: 'S',
            value: widget.transactions.where((t) => valid(t, 6)).fold(0.0, foldFunction),
          ),
        ]);
      case Period.monthly:
        bool valid(Transactions t, int i) {
          return <int>[
            (i * 4) + 1,
            (i * 4) + 2,
            (i * 4) + 3,
            (i * 4) + 4,
          ].contains(t.dateTime.day);
        }

        DateTime now = DateTime.now();
        DateTime firstDayNextMonth;
        if (now.month == 12) {
          firstDayNextMonth = DateTime(now.year + 1, 1, 1);
        } else {
          firstDayNextMonth = DateTime(now.year, now.month + 1, 1);
        }
        DateTime lastDayCurrentMonth = firstDayNextMonth.subtract(const Duration(days: 1));

        result.addAll([
          _ColumnGroup(
            label: '1-4',
            value: widget.transactions.where((t) => valid(t, 0)).fold(0.0, foldFunction),
          ),
          _ColumnGroup(
            label: '5-8',
            value: widget.transactions.where((t) => valid(t, 1)).fold(0.0, foldFunction),
          ),
          _ColumnGroup(
            label: '9-12',
            value: widget.transactions.where((t) => valid(t, 2)).fold(0.0, foldFunction),
          ),
          _ColumnGroup(
            label: '13-16',
            value: widget.transactions.where((t) => valid(t, 3)).fold(0.0, foldFunction),
          ),
          _ColumnGroup(
            label: '17-20',
            value: widget.transactions.where((t) => valid(t, 4)).fold(0.0, foldFunction),
          ),
          _ColumnGroup(
            label: '21-24',
            value: widget.transactions.where((t) => valid(t, 5)).fold(0.0, foldFunction),
          ),
          _ColumnGroup(
            label: '24-${lastDayCurrentMonth.day}',
            value: widget.transactions.where((t) => valid(t, 6)).fold(0.0, foldFunction),
          ),
        ]);
      case Period.custom:
        Map<DateTime, List<Transactions>> groupedByDate = {};

        var provListenFalse = Provider.of<HomeController>(context, listen: false);

        DateTime dateOn = DateTime(
            provListenFalse.begin.year, provListenFalse.begin.month, provListenFalse.begin.day);

        while (dateOn.year != provListenFalse.end.year ||
            dateOn.month != provListenFalse.end.month ||
            dateOn.day != provListenFalse.end.day) {
          groupedByDate[dateOn] = [];

          dateOn = dateOn.add(const Duration(days: 1));
        }

        List<Transactions> transactionsCopy = List.from(widget.transactions);

        transactionsCopy.sort((a, b) => a.dateTime.compareTo(b.dateTime));

        for (var obj in transactionsCopy) {
          DateTime dateOnly = DateTime(obj.dateTime.year, obj.dateTime.month, obj.dateTime.day);

          groupedByDate[dateOnly]!.add(obj);
        }

        List<int> entries = List.filled(7, 0, growable: true);

        int entryIndex = 0;
        for (var i = 0; i < groupedByDate.length; i++) {
          entries[entryIndex]++;

          entryIndex++;

          if (entryIndex == 7) entryIndex = 0;
        }

        entryIndex = 0;

        for (var entry in entries) {
          String label;

          if (entry == 0) {
            label = '-';
          } else if (entry == 1) {
            label = groupedByDate.keys.first.day.toString();
          } else {
            label =
                '${groupedByDate.keys.first.day}-${groupedByDate.keys.elementAt(entry - 1).day}';
          }

          double value = 0;

          for (var i = 0; i < entry; i++) {
            value += groupedByDate.values.first
                .fold(0.0, (previous, element) => previous += element.value);

            groupedByDate.remove(groupedByDate.keys.first);
          }

          result.add(_ColumnGroup(label: label, value: value));
          entryIndex += entry;
        }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    double maxValue = groups.reduce((a, b) => a.value > b.value ? a : b).value;
    maxValue *= 1.2;

    if (maxValue == 0) {
      maxValue = 100;
    }

    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: BarChart(
          BarChartData(
            gridData: const FlGridData(
              drawHorizontalLine: true,
              drawVerticalLine: false,
              show: false,
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  axisNameWidget: Row(
                    children: [
                      const SizedBox(width: 16),
                      for (var entry in groups)
                        Expanded(
                          child: Center(
                            child: Text(entry.label),
                          ),
                        ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
                topTitles: AxisTitles(
                    axisNameSize: 20,
                    axisNameWidget: Row(
                      children: [
                        const SizedBox(width: 16),
                        for (var entry in groups)
                          Expanded(
                            child: Center(
                              child: Text(
                                entry.value.toStringAsFixed(0),
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                          ),
                        const SizedBox(width: 16),
                      ],
                    )),
                rightTitles: const AxisTitles(axisNameSize: 20),
                leftTitles: const AxisTitles(
                  axisNameSize: 20,
                )),
            barGroups: [
              for (var i = 0; i < groups.length; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: groups[i].value,
                      width: 20,
                      color: Theme.of(context).focusColor,
                      backDrawRodData: BackgroundBarChartRodData(
                        toY: maxValue,
                        fromY: 0,
                        color: Theme.of(context).colorScheme.primary.withOpacity(.1),
                        show: true,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
