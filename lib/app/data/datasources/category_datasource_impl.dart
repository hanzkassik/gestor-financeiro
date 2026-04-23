import 'dart:convert';

import 'package:gestor_financeiro/app/core/constants_datasources_keys.dart';
import 'package:gestor_financeiro/app/domain/datasources/category_datasource_interface.dart';
import 'package:gestor_financeiro/app/domain/models/category_model.dart';
import 'package:gestor_financeiro/app/domain/models/create_category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CategoryDatasourceImpl implements ICategoryDatasource {
  List<CategoryModel> _categories = [];
  final _uuid = Uuid();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  CategoryDatasourceImpl._();

  static CategoryDatasourceImpl? _instance;

  static Future<CategoryDatasourceImpl> getInstance() async {
    if (_instance == null) {
      _instance = CategoryDatasourceImpl._();
      await _instance!._loadCategories();
    }
    return _instance!;
  }

  Future<void> _loadCategories() async {
    SharedPreferences prefs = await _prefs;
    final String? categoriesString = prefs.getString(
      ConstantsDatasourcesKeys.categoriesKey,
    );
    if (categoriesString != null) {
      _categories = List<Map<String, dynamic>>.from(
        json.decode(categoriesString),
      ).map((e) => CategoryModel.fromMap(e)).toList();
    }
  }

  Future<void> _saveCategories() async {
    SharedPreferences prefs = await _prefs;
    await prefs.setString(
      ConstantsDatasourcesKeys.categoriesKey,
      json.encode(_categories.map((e) => e.toMap()).toList()),
    );
  }

  @override
  Future<CategoryModel> createCategory(CreateCategoryModel category) async {
    final CategoryModel newCategory = CategoryModel(
      uuid: _uuid.v4(),
      name: category.name,
      description: category.description,
      icon: category.icon,
    );

    _categories.add(newCategory);
    await _saveCategories();
    return newCategory;
  }

  @override
  Future<void> deleteCategory(String id) async {
    final int index = _categories.indexWhere((element) => element.uuid == id);
    if (index == -1) {
      throw Exception('Category not found');
    }
    _categories.removeAt(index);
    await _saveCategories();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    return _categories.map((e) => e.copyWith()).toList();
  }

  @override
  Future<CategoryModel?> getCategoryById(String id) async {
    final indexWhere = _categories.indexWhere((element) => element.uuid == id);
    if (indexWhere == -1) {
      return null;
    }
    return _categories[indexWhere];
  }

  @override
  Future<CategoryModel> updateCategory(CategoryModel category) async {
    final int index = _categories.indexWhere(
      (element) => element.uuid == category.uuid,
    );
    if (index == -1) {
      throw Exception('Category not found');
    }
    _categories[index] = category;
    await _saveCategories();
    return category;
  }
}
