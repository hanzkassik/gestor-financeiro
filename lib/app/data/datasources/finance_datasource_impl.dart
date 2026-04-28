import 'dart:convert';
import 'dart:isolate';

import 'package:gestor_financeiro/app/core/constants_datasources_keys.dart';
import 'package:gestor_financeiro/app/domain/datasources/finance_datasource_interface.dart';
import 'package:gestor_financeiro/app/domain/models/create_finance_model.dart';
import 'package:gestor_financeiro/app/domain/models/finance_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class FinanceDatasourceImpl implements IFinanceDatasource {
  List<FinanceModel> _finances = [];
  final _uuid = Uuid();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  FinanceDatasourceImpl._();

  static FinanceDatasourceImpl? _instance;

  static Future<FinanceDatasourceImpl> getInstance() async {
    if (_instance == null) {
      _instance = FinanceDatasourceImpl._();
      await _instance!._loadFinances();
    }
    return _instance!;
  }

  Future<void> _loadFinances() async {
    SharedPreferences prefs = await _prefs;
    final String? financesString = prefs.getString(
      ConstantsDatasourcesKeys.financesKey,
    );
    if (financesString != null) {
      _finances = await Isolate.run(
        () => List<Map<String, dynamic>>.from(
          json.decode(financesString),
        ).map((e) => FinanceModel.fromMap(e)).toList(),
      );
    }
  }

  Future<void> _saveFinances() async {
    SharedPreferences prefs = await _prefs;
    await prefs.setString(
      ConstantsDatasourcesKeys.financesKey,
      json.encode(_finances.map((e) => e.toMap()).toList()),
    );
  }

  @override
  Future<FinanceModel> createFinance(CreateFinanceModel finance) async {
    final FinanceModel newFinance = FinanceModel(
      uuid: _uuid.v4(),
      description: finance.description,
      value: finance.value,
      tax: finance.tax,
      categoryUuid: finance.categoryUuid,
      date: finance.date,
      startDate: finance.startDate,
      endDate: finance.endDate,
      installmentNumber: finance.installmentNumber,
      createdAt: DateTime.now(),
      fatherUuid: finance.fatherUuid,
    );
    _finances.add(newFinance);
    await _saveFinances();
    return newFinance;
  }

  @override
  Future<void> deleteFinance(String id) {
    final int index = _finances.indexWhere((element) => element.uuid == id);
    if (index == -1) {
      throw Exception('Finance not found');
    }
    _finances.removeAt(index);
    return _saveFinances();
  }

  @override
  Future<FinanceModel?> getFinanceById(String id) async {
    final indexWhere = _finances.indexWhere((element) => element.uuid == id);
    if (indexWhere == -1) {
      return null;
    }
    return _finances[indexWhere];
  }

  @override
  Future<List<FinanceModel>> getFinances() async {
    return List<FinanceModel>.unmodifiable(_finances);
  }

  @override
  Future<FinanceModel> updateFinance(FinanceModel finance) async {
    final int index = _finances.indexWhere(
      (element) => element.uuid == finance.uuid,
    );

    if (index == -1) {
      throw Exception('Finance not found');
    }
    finance.updatedAt = DateTime.now();
    _finances[index] = finance;
    await _saveFinances();
    return finance;
  }

  @override
  Future<List<FinanceModel>> exportDatabase() async {
    await _loadFinances();
    return _finances.map((e) => e.copyWith()).toList();
  }

  @override
  Future<void> importDatabase(List<FinanceModel> finances) async {
    _finances = finances;
    await _saveFinances();
  }
}
