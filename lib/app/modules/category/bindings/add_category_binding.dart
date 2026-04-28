import 'package:gestor_financeiro/app/data/repositories/category_repository_impl.dart';
import 'package:gestor_financeiro/app/domain/datasources/category_datasource_interface.dart';
import 'package:gestor_financeiro/app/domain/repositories/category_repository_interface.dart';
import 'package:gestor_financeiro/app/modules/category/controllers/add_category_controller.dart';
import 'package:get/get.dart';

class AddCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ICategoryRepository>(
      () => CategoryRepositoryImpl(Get.find<ICategoryDatasource>()),
    );
    Get.lazyPut<AddCategoryController>(
      () => AddCategoryController(Get.find<ICategoryRepository>()),
    );
  }
}
