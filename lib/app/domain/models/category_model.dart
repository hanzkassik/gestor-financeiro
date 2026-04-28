import 'package:flutter/material.dart';
import 'package:gestor_financeiro/app/shared/helpers/color_from_hex.dart';
import 'package:gestor_financeiro/app/shared/helpers/is_color.dart';

class CategoryModel {
  final String uuid;
  final String name;
  String? description;
  String? _color;
  final String? icon;

  CategoryModel({
    required this.uuid,
    required this.name,
    this.description,
    String? color,
    this.icon,
  }) : _color = color;

  factory CategoryModel.fromMap(Map<String, dynamic> json) {
    return CategoryModel(
      uuid: json['uuid'],
      name: json['name'],
      description: json['description'],
      color: json['color'],
      icon: json['icon'],
    );
  }

  Color? get color =>
      _color != null && _color!.isNotEmpty && isHexColor(_color!)
      ? colorFromHex(_color!)
      : null;
  String? get strColor => _color;

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
      'description': description,
      'color': _color,
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
      color: color ?? this._color,
      icon: icon ?? this.icon,
    );
  }
}
