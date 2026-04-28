import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gestor_financeiro/app/domain/models/category_model.dart';
import 'package:gestor_financeiro/app/domain/models/create_category_model.dart';
import 'package:gestor_financeiro/app/domain/repositories/category_repository_interface.dart';
import 'package:get/get.dart';

class AddCategoryController extends GetxController {
  final ICategoryRepository _categoryRepository;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  Rx<Color> pickerColor = Theme.of(Get.context!).primaryColor.obs;
  Rx<Color> currentColor = Theme.of(Get.context!).primaryColor.obs;
  RxBool isLoading = false.obs;
  CategoryModel? categoryModel;

  AddCategoryController(this._categoryRepository);

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      if (Get.arguments != null &&
          Get.arguments is Map<String, dynamic> &&
          Get.arguments['categoryid'] != null) {
        isLoading.value = true;
        final categoryid = Get.arguments['categoryid'];
        categoryModel = await _categoryRepository.getCategoryById(categoryid);
        nameController.text = categoryModel!.name;
        descriptionController.text = categoryModel!.description ?? '';
        colorController.text = categoryModel!.strColor ?? '';
        if (categoryModel?.color != null) {
          currentColor.value = categoryModel!.color!;
          pickerColor.value = currentColor.value;
        }
      }
      update();
    } catch (e, stc) {
      debugPrint(e.toString());
      debugPrint(stc.toString());
      Get.snackbar('Erro', 'Falha ao carregar categoria: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeColor(Color color) async {
    pickerColor.value = color;
    colorController.text = pickerColor.value.toHexString();
  }

  Future<void> deleteCategory() async {
    try {
      if (categoryModel == null) return;
      isLoading.value = true;
      await _categoryRepository.deleteCategory(categoryModel!.uuid);
      Get.back();
      Get.snackbar('Sucesso', 'Categoria deletada com sucesso!');
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar('Erro', 'Falha ao deletar categoria: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveCategory() async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }
      isLoading.value = true;
      if (categoryModel == null) {
        final createCategory = CreateCategoryModel(
          name: nameController.text,
          description: descriptionController.text,
          color: colorController.text.replaceAll('#', '').isEmpty
              ? null
              : colorController.text.replaceAll('#', ''),
        );
        await _categoryRepository.createCategory(createCategory);
      } else {
        final updatedCategory = categoryModel!.copyWith(
          name: nameController.text,
          description: descriptionController.text,
          color: colorController.text.replaceAll('#', ''),
        );
        await _categoryRepository.updateCategory(updatedCategory);
      }
      Get.back();
      Get.snackbar('Sucesso', 'Categoria salva com sucesso!');
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar('Erro', 'Falha ao salvar categoria: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
