import 'package:flutter/material.dart';
import 'package:gestor_financeiro/app/data/datasources/category_datasource_impl.dart';
import 'package:gestor_financeiro/app/data/datasources/finance_datasource_impl.dart';
import 'package:gestor_financeiro/app/domain/datasources/category_datasource_interface.dart';
import 'package:gestor_financeiro/app/domain/datasources/finance_datasource_interface.dart';
import 'package:gestor_financeiro/my_app.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final financeDs = await FinanceDatasourceImpl.getInstance();
  final categoryDs = await CategoryDatasourceImpl.getInstance();

  Get.put<IFinanceDatasource>(financeDs, permanent: true);
  Get.put<ICategoryDatasource>(categoryDs, permanent: true);
  runApp(const MyApp());
}
