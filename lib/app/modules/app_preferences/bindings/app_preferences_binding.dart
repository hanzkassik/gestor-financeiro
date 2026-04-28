import 'package:gestor_financeiro/app/data/repositories/category_repository_impl.dart';
import 'package:gestor_financeiro/app/data/repositories/finance_repository_impl.dart';
import 'package:gestor_financeiro/app/domain/repositories/category_repository_interface.dart';
import 'package:gestor_financeiro/app/domain/repositories/finance_repository_interface.dart';
import 'package:gestor_financeiro/app/modules/app_preferences/controllers/app_preferences_controller.dart';
import 'package:get/get.dart';

class AppPreferencesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IFinanceRepository>(
      () => FinanceRepositoryImpl(Get.find(), Get.find()),
    );
    Get.lazyPut<ICategoryRepository>(() => CategoryRepositoryImpl(Get.find()));
    Get.lazyPut<AppPreferencesController>(
      () => AppPreferencesController(),
      fenix: true,
    );
  }
}
