import 'dart:convert';
import 'dart:isolate';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gestor_financeiro/app/core/services/app_preferences_service.dart';
import 'package:gestor_financeiro/app/domain/models/category_model.dart';
import 'package:gestor_financeiro/app/domain/models/finance_model.dart';
import 'package:gestor_financeiro/app/domain/repositories/category_repository_interface.dart';
import 'package:gestor_financeiro/app/domain/repositories/finance_repository_interface.dart';
import 'package:get/get.dart';

class AppPreferencesController extends GetxController {
  final AppPreferencesService _appPreferencesService =
      AppPreferencesService.instance;
  final IFinanceRepository _financeRepository = Get.find();
  final ICategoryRepository _categoryRepository = Get.find();
  Rx<Color> pickerColor = Theme.of(Get.context!).primaryColor.obs;
  Rx<Color> currentColor = Theme.of(Get.context!).primaryColor.obs;
  final TextEditingController colorController = TextEditingController();
  RxBool isDarkMode = AppPreferencesService.instance.isDarkMode.obs;
  RxBool isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _appPreferencesService.isDarkMode;
  }

  Future<void> changeThemeMode(bool isDark) async {
    _appPreferencesService.themeMode.value = isDark
        ? ThemeMode.dark
        : ThemeMode.light;
    isDarkMode.value = isDark;
    if (isDark) {
      pickerColor.value = _appPreferencesService.darkTheme.value.primaryColor;
    } else {
      pickerColor.value = _appPreferencesService.lightTheme.value.primaryColor;
    }
  }

  Future<void> changeColor(Color color) async {
    pickerColor.value = color;
    colorController.text = pickerColor.value.toHexString();
    if (isDarkMode.value) {
      _appPreferencesService.darkTheme.value = _appPreferencesService
          .darkTheme
          .value
          .copyWith(
            primaryColor: pickerColor.value,
            colorScheme: _appPreferencesService.darkTheme.value.colorScheme
                .copyWith(primary: pickerColor.value),
          );
    } else {
      _appPreferencesService.lightTheme.value = _appPreferencesService
          .lightTheme
          .value
          .copyWith(
            primaryColor: pickerColor.value,
            colorScheme: _appPreferencesService.lightTheme.value.colorScheme
                .copyWith(primary: pickerColor.value),
          );
    }
  }

  Future<void> exportarDatabase() async {
    isLoading.value = true;
    try {
      final finances = await _financeRepository.exportDatabase();
      final categories = await _categoryRepository.exportDatabase();
      final data = {
        'finances': await Isolate.run(
          () => finances.map((e) => e.toMap()).toList(),
        ),
        'categories': await Isolate.run(
          () => categories.map((e) => e.toMap()).toList(),
        ),
      };
      await Clipboard.setData(ClipboardData(text: json.encode(data)));
      Get.snackbar(
        'Sucesso',
        'Database exportada para a área de transferência!',
      );
    } catch (e, stc) {
      debugPrint(e.toString());
      debugPrint(stc.toString());
      Get.snackbar('Erro', 'Falha ao exportar database: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> importarDatabase() async {
    isLoading.value = true;
    try {
      FilePickerResult? result = await FilePicker.pickFiles();
      if (result == null) return;
      final bytes = await result.xFiles.first.readAsBytes();
      String fileContent = utf8.decode(bytes);
      final Map<String, dynamic> data = json.decode(fileContent);
      final finances = await Isolate.run(
        () => List<Map<String, dynamic>>.from(
          data['finances'],
        ).map((e) => FinanceModel.fromMap(e)).toList(),
      );
      final categories = await Isolate.run(
        () => List<Map<String, dynamic>>.from(
          data['categories'],
        ).map((e) => CategoryModel.fromMap(e)).toList(),
      );

      await _categoryRepository.importDatabase(categories);
      await _financeRepository.importDatabase(finances);
      Get.snackbar('Sucesso', 'Database importada com sucesso!');
    } catch (e, stc) {
      debugPrint(e.toString());
      debugPrint(stc.toString());
      Get.snackbar('Erro', 'Falha ao importar database: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
