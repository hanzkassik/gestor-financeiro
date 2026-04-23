import 'package:gestor_financeiro/app/domain/datasources/category_datasource_interface.dart';
import 'package:gestor_financeiro/app/domain/models/category_model.dart';
import 'package:gestor_financeiro/app/domain/models/create_category_model.dart';
import 'package:gestor_financeiro/app/domain/repositories/category_repository_interface.dart';

class CategoryRepositoryImpl implements ICategoryRepository {
  final ICategoryDatasource _datasource;
  CategoryRepositoryImpl(this._datasource);
  @override
  Future<CategoryModel> createCategory(CreateCategoryModel category) {
    return _datasource.createCategory(category);
  }

  @override
  Future<void> deleteCategory(String id) async {
    return await _datasource.deleteCategory(id);
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    return await _datasource.getCategories();
  }

  @override
  Future<CategoryModel?> getCategoryById(String id) async {
    return await _datasource.getCategoryById(id);
  }

  @override
  Future<CategoryModel> updateCategory(CategoryModel category) async {
    return await _datasource.updateCategory(category);
  }
}
