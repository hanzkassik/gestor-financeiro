class CategoryModel {
  final String uuid;
  final String name;
  final String description;
  final String? icon;

  CategoryModel({
    required this.uuid,
    required this.name,
    required this.description,
    this.icon,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> json) {
    return CategoryModel(
      uuid: json['uuid'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
      'description': description,
      'icon': icon,
    };
  }

  CategoryModel copyWith({
    String? uuid,
    String? name,
    String? description,
    String? icon,
  }) {
    return CategoryModel(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
    );
  }
}
