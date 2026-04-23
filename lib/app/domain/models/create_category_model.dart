class CreateCategoryModel {
  final String name;
  final String description;
  final String? icon;

  CreateCategoryModel({
    required this.name,
    required this.description,
    this.icon,
  });

  factory CreateCategoryModel.fromMap(Map<String, dynamic> json) {
    return CreateCategoryModel(
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'description': description, 'icon': icon};
  }
}
