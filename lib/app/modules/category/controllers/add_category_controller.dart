import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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

  AddCategoryController(this._categoryRepository);

  Future<void> changeColor(Color color) async {
    pickerColor.value = color;
    colorController.text = pickerColor.value.toHexString();
  }

  Future<void> saveCategory() async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }
      isLoading.value = true;
      final createCategory = CreateCategoryModel(
        name: nameController.text,
        description: descriptionController.text,
        color: colorController.text.replaceAll('#', ''),
      );
      await _categoryRepository.createCategory(createCategory);
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
