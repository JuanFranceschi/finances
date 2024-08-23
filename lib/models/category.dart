import 'package:finances/utils/color_to_hex.dart';
import 'package:finances/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

class Category {
  String id;
  String name;
  Color color;
  IconData icon;
  double plannedOutlay;
  TransactionType transactionType;

  Category({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.plannedOutlay,
    required this.transactionType,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color.toHex(),
      'icon': icon.codePoint,
      'plannedOutlay': plannedOutlay,
      'transactionType': transactionType.toString()
    };
  }

  factory Category.fromMap(Map<String, Object?> map) {
    return Category(
      id: (map['id'] ?? map['idCategory']) as String,
      name: map['name'] as String,
      color: Color(
        int.parse(map['color'] as String, radix: 16),
      ),
      icon: IconData(
        map['icon'] as int,
        fontPackage: 'material_symbols_icons',
        fontFamily: 'MaterialSymbolsOutlined',
      ),
      plannedOutlay: map['plannedOutlay'] as double,
      transactionType:
          TransactionType.values.firstWhere((e) => e.toString() == map['transactionType']),
    );
  }
}
