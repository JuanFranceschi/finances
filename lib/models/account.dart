import 'package:flutter/material.dart';

class Account {
  final id = 1;
  String owner;
  double value;
  ThemeMode theme;

  Account({required this.owner, required this.value, this.theme = ThemeMode.system});

  Map<String, dynamic> toMap() {
    return {'id': id, 'owner': owner, 'value': value, 'theme': theme.toString()};
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      owner: map['owner'],
      value: map['value'],
      theme: ThemeMode.values.firstWhere(
        (obj) => obj.toString() == map['theme'],
      ),
    );
  }
}
