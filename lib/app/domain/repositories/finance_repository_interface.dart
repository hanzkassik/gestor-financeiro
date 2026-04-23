import 'package:gestor_financeiro/app/domain/models/create_finance_model.dart';
import 'package:gestor_financeiro/app/domain/models/finance_model.dart';

abstract class IFinanceRepository {
  Future<List<FinanceModel>> getFinances();
  Future<FinanceModel?> getFinanceById(String id);
  Future<FinanceModel> createFinance(CreateFinanceModel finance);
  Future<FinanceModel> updateFinance(FinanceModel finance);
  Future<void> deleteFinance(String id);
}
