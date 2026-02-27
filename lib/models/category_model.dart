class CategoryModel {
  final String id;
  final String name;
  final String icon;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory CategoryModel.fromMap(String id, Map<String, dynamic> map) =>
      CategoryModel(
        id: id,
        name: map['name'] ?? '',
        icon: map['icon'] ?? '📁',
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'icon': icon,
      };

  CategoryModel copyWith({String? id, String? name, String? icon}) =>
      CategoryModel(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon ?? this.icon,
      );
}