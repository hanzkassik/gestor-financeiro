import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gestor_financeiro/app/core/app_constants.dart';
import 'package:gestor_financeiro/app/shared/helpers/is_color.dart';
import 'package:gestor_financeiro/app/shared/widgets/app_text_field.dart';
import 'package:get/get.dart';
import 'package:gestor_financeiro/app/modules/app_preferences/controllers/app_preferences_controller.dart';

class AppPreferencesPage extends GetView<AppPreferencesController> {
  const AppPreferencesPage({super.key});

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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preferências do App')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.pagePadding,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        'Tema',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Switch(
                        activeTrackColor: Colors.transparent,
                        inactiveTrackColor: Colors.blue[200],
                        thumbColor: WidgetStateProperty.all(Colors.white),
                        thumbIcon: WidgetStateProperty.all(
                          Icon(
                            controller.isDarkMode.value
                                ? Icons.dark_mode
                                : Icons.light_mode,
                            color: controller.isDarkMode.value
                                ? Colors.black87
                                : Colors.amber,
                          ),
                        ),

                        value: controller.isDarkMode.value,
                        onChanged: (value) {
                          controller.changeThemeMode(value);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AppTextField(
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
                      color: Theme.of(context).primaryColor,
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
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controller.exportarDatabase();
                    },
                    child: const Text('Exportar database'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.importarDatabase();
                    },
                    child: const Text('Importar database'),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
