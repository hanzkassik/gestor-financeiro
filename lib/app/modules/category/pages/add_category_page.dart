import 'package:flutter/material.dart';
import 'package:gestor_financeiro/app/core/app_constants.dart';
import 'package:gestor_financeiro/app/modules/category/controllers/add_category_controller.dart';
import 'package:gestor_financeiro/app/shared/helpers/is_color.dart';
import 'package:gestor_financeiro/app/shared/widgets/app_text_field.dart';
import 'package:get/get.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddCategoryPage extends GetView<AddCategoryController> {
  const AddCategoryPage({super.key});

  _dialogChangeColor() {
    Get.dialog(
      AlertDialog(
        title: const Text('Pick a color!'),
        content: ColorPicker(
          pickerColor: controller.currentColor.value,
          onColorChanged: (color) {
            controller.currentColor.value = color;
          },
        ),
        actions: [
          ElevatedButton(
            child: const Text('Salvar'),
            onPressed: () {
              controller.changeColor(controller.currentColor.value);
              Get.back();
            },
          ),
        ],
        // Use Material color picker:
        //
        // child: MaterialPicker(
        //   pickerColor: pickerColor,
        //   onColorChanged: changeColor,
        //   showLabel: true, // only on portrait mode
        // ),
        //
        // Use Block color picker:
        //
        // child: BlockPicker(
        //   pickerColor: currentColor,
        //   onColorChanged: changeColor,
        // ),
        //
        // child: MultipleChoiceBlockPicker(
        //   pickerColors: currentColors,
        //   onColorsChanged: changeColors,
        // ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adicionar Categoria')),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.pagePadding,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Nome',
                  controller: controller.nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O nome é obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Descrição',
                  controller: controller.descriptionController,
                ),
                const SizedBox(height: 16),
                Obx(() {
                  return AppTextField(
                    label: 'Cor (hexadecimal)',
                    controller: controller.colorController,
                    prefixIcon: IconButton(
                      onPressed: () {
                        _dialogChangeColor();
                      },
                      icon: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.pickerColor.value,
                        ),
                      ),
                    ),
                    onChanged: (text) {
                      if (isHexColor(text)) {
                        controller.pickerColor.value = Color(
                          int.parse('0xff${text.replaceAll('#', '')}'),
                        );
                      }
                    },
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          isHexColor(value) == false) {
                        return 'Por favor, insira um valor hexadecimal válido';
                      }
                      return null;
                    },
                  );
                }),
                const SizedBox(height: 16),
                GetBuilder<AddCategoryController>(
                  builder: (controller) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (controller.categoryModel != null)
                          ElevatedButton(
                            onPressed: () async {
                              final result =
                                  await _showPopupConfirmationDelete();
                              if (result == true) {
                                await controller.deleteCategory();
                                Get.back();
                              }
                            },
                            child: const Text('Deletar'),
                          ),
                        ElevatedButton(
                          onPressed: () async {
                            await controller.saveCategory();
                          },
                          child: const Text('Salvar'),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showPopupConfirmationDelete() async {
    return await Get.dialog(
      AlertDialog(
        title: const Text('Confirmação'),
        content: const Text('Tem certeza que deseja deletar esta categoria?'),
        actions: [
          ElevatedButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Get.back(result: false);
            },
          ),
          ElevatedButton(
            child: const Text('Deletar'),
            onPressed: () {
              Get.back(result: true);
            },
          ),
        ],
      ),
    );
  }
}
