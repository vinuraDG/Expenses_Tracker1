import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final double amount;
  final String type; // 'income' and 'expense'
  final String categoryId;
  final DateTime date;
  final String? note;
  final String? receiptUrl;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    this.note,
    this.receiptUrl,
  });

  factory TransactionModel.fromMap(String id, Map<String, dynamic> map) =>
      TransactionModel(
        id: id,
        amount: (map['amount'] as num).toDouble(),
        type: map['type'] ?? 'expense',
        categoryId: map['categoryId'] ?? '',
        date: (map['date'] as Timestamp).toDate(),
        note: map['note'],
        receiptUrl: map['receiptUrl'],
      );

  Map<String, dynamic> toMap() => {
        'amount': amount,
        'type': type,
        'categoryId': categoryId,
        'date': Timestamp.fromDate(date),
        'note': note,
        'receiptUrl': receiptUrl,
      };

  TransactionModel copyWith({
    String? id,
    double? amount,
    String? type,
    String? categoryId,
    DateTime? date,
    String? note,
    String? receiptUrl,
  }) =>
      TransactionModel(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        type: type ?? this.type,
        categoryId: categoryId ?? this.categoryId,
        date: date ?? this.date,
        note: note ?? this.note,
        receiptUrl: receiptUrl ?? this.receiptUrl,
      );

  bool get isIncome => type == 'income';
  bool get isExpense => type == 'expense';
}