class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final String type; // 'income' or 'expense'

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    this.type = 'expense',
  });

  factory CategoryModel.fromMap(String id, Map<String, dynamic> map) =>
      CategoryModel(
        id: id,
        name: map['name'] ?? '',
        icon: map['icon'] ?? '📁',
        type: map['type'] ?? 'expense',
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'icon': icon,
        'type': type,
      };

  CategoryModel copyWith({String? id, String? name, String? icon, String? type}) =>
      CategoryModel(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        type: type ?? this.type,
      );

  bool get isIncome => type == 'income';
  bool get isExpense => type == 'expense';
}