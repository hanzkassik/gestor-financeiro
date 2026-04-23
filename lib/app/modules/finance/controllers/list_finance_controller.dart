import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestor_financeiro/app/domain/models/finance_model.dart';
import 'package:gestor_financeiro/app/domain/repositories/finance_repository_interface.dart';
import 'package:get/get.dart';

class ListFinanceController extends GetxController {
  late final IFinanceRepository _financeRepository;

  final ScrollController scrollController = ScrollController();
  final ScrollController scrollControllerHorizontal = ScrollController();
  var finances = <FinanceModel>[].obs;
  var isLoading = false.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  var months = List.generate(21, (index) {
    final base = DateTime.now();
    final meio = 21 ~/ 2;
    final offset = index - meio;
    final data = DateTime(base.year, base.month + offset);
    return data;
  }).obs;
  var monthKeys = List.generate(21, (_) => GlobalKey());
  ListFinanceController();

  @override
  void onInit() {
    super.onInit();
    _financeRepository = Get.find();
    fetchData();
  }

  @override
  void onReady() {
    super.onReady();
    scrollControllerHorizontal.jumpTo(
      scrollControllerHorizontal.position.maxScrollExtent / 2,
    );
  }

  Future<void> onChangeSelectedDate(DateTime date) async {
    selectedDate.value = date;
    final index = months.indexOf(date);
    final context = monthKeys[index].currentContext;
    if (context == null) return;
    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      alignment: 0.5,
    );
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
    monthKeys = List.generate(qtdMeses, (_) => GlobalKey());
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
