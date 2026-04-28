import 'package:flutter/cupertino.dart';
import 'package:gestor_financeiro/app/domain/models/category_model.dart';
import 'package:gestor_financeiro/app/domain/models/create_finance_model.dart';
import 'package:gestor_financeiro/app/domain/repositories/category_repository_interface.dart';
import 'package:gestor_financeiro/app/domain/repositories/finance_repository_interface.dart';
import 'package:gestor_financeiro/app/shared/helpers/date_format_ddmmyyyy.dart';
import 'package:get/get.dart';

class AddFinanceController extends GetxController {
  final IFinanceRepository _financeRepository;
  final ICategoryRepository _categoryRepository;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  final TextEditingController taxController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);

  AddFinanceController(this._financeRepository, this._categoryRepository);

  @override
  void onInit() {
    super.onInit();
    dateController.text = dateFormatDdmmyyyy.format(DateTime.now());
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final fetchedCategories = await _categoryRepository.getCategories();
      categories.assignAll(fetchedCategories);
      categories.insert(
        0,
        CategoryModel(name: 'Sem categoria', uuid: '', description: ''),
      );
      update();
    } catch (e, stc) {
      debugPrint(e.toString());
      debugPrint(stc.toString());
      Get.snackbar('Erro', 'Falha ao carregar categorias: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveFinance() async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }
      isLoading.value = true;
      final createFinance = CreateFinanceModel(
        value: double.parse(valueController.text.replaceAll(',', '.')),
        date: dateFormatDdmmyyyy.parse(dateController.text),
        description: descriptionController.text,
        tax: taxController.text.isEmpty
            ? null
            : double.parse(taxController.text.replaceAll(',', '.')),
        startDate: startDateController.text.isEmpty
            ? null
            : dateFormatDdmmyyyy.parse(startDateController.text),
        endDate: endDateController.text.isEmpty
            ? null
            : dateFormatDdmmyyyy.parse(endDateController.text),
        categoryUuid: selectedCategory.value?.uuid.isEmpty == true
            ? null
            : selectedCategory.value?.uuid,
      );
      await _financeRepository.createFinance(createFinance);
      Get.back();
      Get.snackbar('Sucesso', 'Finança salva com sucesso!');
    } catch (e, stc) {
      debugPrint(e.toString());
      debugPrint(stc.toString());
      Get.snackbar('Erro', 'Falha ao salvar finança: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
