import 'package:gestor_financeiro/app/modules/finance/bindings/add_finance_binding.dart';
import 'package:gestor_financeiro/app/modules/finance/bindings/list_finance_binding.dart';
import 'package:gestor_financeiro/app/modules/finance/pages/add_finance_page.dart';
import 'package:gestor_financeiro/app/modules/finance/pages/list_finance_page.dart';
import 'package:gestor_financeiro/app/routes/app_routes.dart';
import 'package:get/get.dart';

class AppPage {
  AppPage._();
  static const initialRoute = AppRoutes.listFinance;
  static final routes = [
    GetPage(
      name: AppRoutes.addFinance,
      page: () => AddFinancePage(),
      binding: AddFinanceBinding(),
    ),
    GetPage(
      name: AppRoutes.listFinance,
      page: () => ListFinancePage(),
      binding: ListFinanceBinding(),
    ),
  ];
}
