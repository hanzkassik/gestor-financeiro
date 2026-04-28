class CategoryModel {
  final String uuid;
  final String name;
  String? description;
  String? color;
  final String? icon;

  CategoryModel({
    required this.uuid,
    required this.name,
    this.description,
    this.color,
    this.icon,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> json) {
    return CategoryModel(
      uuid: json['uuid'],
      name: json['name'],
      description: json['description'],
      color: json['color'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
      'description': description,
      'color': color,
      'icon': icon,
    };
  }

  CategoryModel copyWith({
    String? uuid,
    String? name,
    String? description,
    String? color,
    String? icon,
  }) {
    return CategoryModel(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }
}
