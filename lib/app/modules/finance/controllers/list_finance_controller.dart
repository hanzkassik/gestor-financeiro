import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestor_financeiro/app/domain/models/finance_model.dart';
import 'package:gestor_financeiro/app/domain/repositories/finance_repository_interface.dart';
import 'package:get/get.dart';

class ListFinanceController extends GetxController {
  late final IFinanceRepository _financeRepository;

  final ScrollController listTileScrollController = ScrollController();
  final ScrollController calendarHorizontalScrollController =
      ScrollController();
  final ScrollController calendarVerticalScrollController = ScrollController();
  var finances = <FinanceModel>[].obs;
  var isLoading = false.obs;
  final calendarIsVisible = false.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  var months = List.generate(21, (index) {
    final base = DateTime.now();
    final meio = 21 ~/ 2;
    final offset = index - meio;
    final data = DateTime(base.year, base.month + offset);
    return data;
  }).obs;
  ListFinanceController();

  @override
  void onInit() {
    super.onInit();
    _financeRepository = Get.find();
    fetchData();
  }

  Future<void> onChangeSelectedDate(DateTime date) async {
    selectedDate.value = date;
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final data = await _financeRepository.getFinances();
      data.sort((a, b) => a.date.compareTo(b.date));
      finances.value = data;
      _recalcularMoths();
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível carregar as finanças');
    } finally {
      isLoading.value = false;
    }
  }

  void _recalcularMoths() {
    final lastEndDate = finances.last.date;
    final hoje = DateTime.now();
    final qtdMeses =
        (((lastEndDate.year - hoje.year) * 12 +
                (lastEndDate.month - hoje.month)) *
            2) +
        1;
    months.value = List.generate(qtdMeses, (index) {
      final base = selectedDate.value;
      final meio = qtdMeses ~/ 2;
      final offset = index - meio;
      final data = DateTime(base.year, base.month + offset);
      return data;
    });
  }

  Future<void> deleteFinance(String uuid) async {
    try {
      isLoading.value = true;
      await _financeRepository.deleteFinance(uuid);
      await fetchData();
      Get.snackbar('Sucesso', 'Finança deletada com sucesso');
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível deletar a finança');
    } finally {
      isLoading.value = false;
    }
  }
}
