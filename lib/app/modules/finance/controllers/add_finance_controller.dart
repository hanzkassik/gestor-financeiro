import 'package:flutter/cupertino.dart';
import 'package:gestor_financeiro/app/domain/models/category_model.dart';
import 'package:gestor_financeiro/app/domain/models/create_finance_model.dart';
import 'package:gestor_financeiro/app/domain/models/finance_model.dart';
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
  final TextEditingController categoryController = TextEditingController();
  final FocusNode categoryFocusNode = FocusNode();
  final RxBool isLoading = false.obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);
  FinanceModel? financeModel;

  AddFinanceController(this._financeRepository, this._categoryRepository);

  @override
  void onInit() {
    super.onInit();
    dateController.text = dateFormatDdmmyyyy.format(DateTime.now());
    fetchCategories();
    fetchFinance();
  }

  Future<void> fetchFinance() async {
    try {
      isLoading.value = true;
      if (Get.arguments != null &&
          Get.arguments is Map<String, dynamic> &&
          Get.arguments['financeid'] != null) {
        final financeId = Get.arguments['financeid'] as String;
        financeModel = await _financeRepository.getFinanceById(financeId);
        if (financeModel != null) {
          descriptionController.text = financeModel!.description ?? '';
          valueController.text = financeModel!.value.toString().replaceAll(
            '.',
            ',',
          );
          taxController.text =
              financeModel!.tax?.toString().replaceAll('.', ',') ?? '';
          dateController.text = dateFormatDdmmyyyy.format(financeModel!.date);
          startDateController.text = financeModel!.startDate != null
              ? dateFormatDdmmyyyy.format(financeModel!.startDate!)
              : '';
          endDateController.text = financeModel!.endDate != null
              ? dateFormatDdmmyyyy.format(financeModel!.endDate!)
              : '';
          selectedCategory.value = financeModel!.category;
          categoryController.text = financeModel!.category?.name ?? '';
          update();
        }
      }
    } catch (e, stc) {
      debugPrint(e.toString());
      debugPrint(stc.toString());
      Get.snackbar('Erro', 'Falha ao carregar finança: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCategories() async {
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

  Future<List<FinanceModel>> getChildrenFinances() async {
    if (financeModel == null) return [];
    try {
      isLoading.value = true;
      final childrenFinances = await _financeRepository.getFinancesByParentId(
        financeModel!.uuid,
      );
      return childrenFinances;
    } catch (e) {
      Get.snackbar('Erro', 'Falha ao carregar parcelas vinculadas');
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveFinance({bool? saveCategoryParents = false}) async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }
      isLoading.value = true;
      if (financeModel == null) {
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
      } else {
        final updatedFinance = financeModel!.copyWith(
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
        await _financeRepository.updateFinance(updatedFinance);
        if (saveCategoryParents == true) {
          final childrenFinances = await getChildrenFinances();
          for (var child in childrenFinances) {
            final updatedChild = child.copyWith(
              categoryUuid: updatedFinance.categoryUuid,
            );
            await _financeRepository.updateFinance(updatedChild);
          }
        }
      }
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

  Future<void> deleteFinance(String uuid) async {
    try {
      isLoading.value = true;
      await _financeRepository.deleteFinance(uuid);
      Get.snackbar('Sucesso', 'Finança deletada com sucesso');
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível deletar a finança');
    } finally {
      isLoading.value = false;
    }
  }
}
