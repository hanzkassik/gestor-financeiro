import 'package:gestor_financeiro/app/domain/datasources/category_datasource_interface.dart';
import 'package:gestor_financeiro/app/domain/datasources/finance_datasource_interface.dart';
import 'package:gestor_financeiro/app/domain/models/create_finance_model.dart';
import 'package:gestor_financeiro/app/domain/models/finance_model.dart';
import 'package:gestor_financeiro/app/domain/repositories/finance_repository_interface.dart';
import 'package:get/get.dart';

class FinanceRepositoryImpl implements IFinanceRepository {
  final IFinanceDatasource _datasource;
  final ICategoryDatasource _categoryDatasource;
  FinanceRepositoryImpl(this._datasource, this._categoryDatasource);

  @override
  Future<FinanceModel> createFinance(CreateFinanceModel finance) async {
    if (finance.startDate != null) {
      finance.date = finance.startDate!;
    }
    final newFinance = await _datasource.createFinance(finance);
    if (finance.startDate != null && finance.endDate != null) {
      int meses =
          (finance.endDate!.year - finance.startDate!.year) * 12 +
          (finance.endDate!.month - finance.startDate!.month);
      if (finance.endDate!.day < finance.startDate!.day) meses--;
      if (meses > 0) {
        for (int i = 1; i <= meses; i++) {
          final novaFinance = CreateFinanceModel(
            description: finance.description,
            value: finance.value,
            tax: finance.tax,
            categoryUuid: finance.categoryUuid,
            date: DateTime(
              finance.startDate!.year,
              finance.startDate!.month + i,
              finance.startDate!.day,
            ),
            startDate: finance.startDate,
            endDate: finance.endDate,
            installmentNumber: i + 1,
            fatherUuid: newFinance.uuid,
          );
          await _datasource.createFinance(novaFinance);
        }
      }
    }
    return newFinance;
  }

  @override
  Future<void> deleteFinance(String id) async {
    final finances = await _datasource.getFinances();
    for (var finance in finances) {
      if (finance.fatherUuid != null && finance.fatherUuid == id) {
        await _datasource.deleteFinance(finance.uuid);
      }
    }
    return await _datasource.deleteFinance(id);
  }

  @override
  Future<FinanceModel?> getFinanceById(String id) async {
    final finance = await _datasource.getFinanceById(id);
    if (finance != null) {
      if (finance.categoryUuid == null) {
        return finance;
      }
      final category = await _categoryDatasource.getCategoryById(
        finance.categoryUuid!,
      );
      finance.category = category;
      return finance;
    }
    return null;
  }

  @override
  Future<List<FinanceModel>> getFinances() async {
    final finances = await _datasource.getFinances();
    final financesCopy = List<FinanceModel>.from(
      finances.map((e) => e.copyWith()),
    );
    final categories = await _categoryDatasource.getCategories();
    for (var finance in financesCopy) {
      if (finance.categoryUuid != null) {
        finance.category = categories.firstWhereOrNull(
          (category) => category.uuid == finance.categoryUuid,
        );
      }
      if (finance.financeFather != null) {
        finance.financeFather = financesCopy.firstWhereOrNull(
          (f) => f.uuid == finance.financeFather!.uuid,
        );
      }
    }
    return financesCopy;
  }

  @override
  Future<FinanceModel> updateFinance(FinanceModel finance) async {
    return await _datasource.updateFinance(finance);
  }
}
