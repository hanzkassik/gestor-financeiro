class CreateCategoryModel {
  final String name;
  String? description;
  String? color;
  final String? icon;

  CreateCategoryModel({
    required this.name,
    this.description,
    this.color,
    this.icon,
  });

  factory CreateCategoryModel.fromMap(Map<String, dynamic> json) {
    return CreateCategoryModel(
      name: json['name'],
      description: json['description'],
      color: json['color'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'color': color,
      'icon': icon,
    };
  }
}
