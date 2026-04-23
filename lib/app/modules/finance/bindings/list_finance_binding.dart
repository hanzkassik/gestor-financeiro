import 'package:gestor_financeiro/app/data/repositories/finance_repository_impl.dart';
import 'package:gestor_financeiro/app/domain/datasources/category_datasource_interface.dart';
import 'package:gestor_financeiro/app/domain/datasources/finance_datasource_interface.dart';
import 'package:gestor_financeiro/app/domain/repositories/finance_repository_interface.dart';
import 'package:gestor_financeiro/app/modules/finance/controllers/list_finance_controller.dart';
import 'package:get/get.dart';

class ListFinanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IFinanceRepository>(() {
      final finance = Get.find<IFinanceDatasource>();
      final category = Get.find<ICategoryDatasource>();
      return FinanceRepositoryImpl(finance, category);
    });
    Get.lazyPut<ListFinanceController>(() {
      return ListFinanceController();
    }, fenix: false);
  }
}
