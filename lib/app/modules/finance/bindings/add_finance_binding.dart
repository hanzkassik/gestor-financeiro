import 'package:gestor_financeiro/app/data/repositories/category_repository_impl.dart';
import 'package:gestor_financeiro/app/data/repositories/finance_repository_impl.dart';
import 'package:gestor_financeiro/app/domain/repositories/category_repository_interface.dart';
import 'package:gestor_financeiro/app/domain/repositories/finance_repository_interface.dart';
import 'package:gestor_financeiro/app/modules/finance/controllers/add_finance_controller.dart';
import 'package:get/get.dart';

class AddFinanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IFinanceRepository>(
      () => FinanceRepositoryImpl(Get.find(), Get.find()),
    );
    Get.lazyPut<ICategoryRepository>(() => CategoryRepositoryImpl(Get.find()));
    Get.lazyPut(
      () => AddFinanceController(
        Get.find<IFinanceRepository>(),
        Get.find<ICategoryRepository>(),
      ),
    );
  }
}
