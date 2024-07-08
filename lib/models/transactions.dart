import 'package:finances/models/category.dart';
import 'package:finances/utils/enums.dart';

class Transactions {
  String id;
  Category category;
  DateTime dateTime;
  String title, description;
  double value;
  TransactionType type;

  Transactions({
    required this.id,
    required this.category,
    required this.dateTime,
    required this.title,
    required this.description,
    required this.value,
    required this.type,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'categoryId': category.id,
      'value': value,
      'type': type.toString(),
    };
  }

  factory Transactions.fromMap(Map<String, Object?> map) {
    return Transactions(
      id: (map['id'] ?? map['idTransaction']) as String,
      category: Category.fromMap(map),
      dateTime: DateTime.parse(map['dateTime'] as String),
      title: map['title'] as String,
      description: map['description'] as String,
      value: map['value'] as double,
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == map['type'],
      ),
    );
  }
}
