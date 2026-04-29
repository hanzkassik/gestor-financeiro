import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gestor_financeiro/app/core/enums/export_database_type.dart';
import 'package:gestor_financeiro/app/core/services/app_preferences_service.dart';
import 'package:gestor_financeiro/app/domain/models/category_model.dart';
import 'package:gestor_financeiro/app/domain/models/finance_model.dart';
import 'package:gestor_financeiro/app/domain/repositories/category_repository_interface.dart';
import 'package:gestor_financeiro/app/domain/repositories/finance_repository_interface.dart';
import 'package:gestor_financeiro/app/shared/helpers/date_format_ddmmyyyy.dart';
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

  Future<Map<String, dynamic>> _buildExportDatabaseJson(
    List<FinanceModel> finances,
    List<CategoryModel> categories,
  ) async {
    return {
      'finances': await Isolate.run(
        () => finances.map((e) => e.toMap()).toList(),
      ),
      'categories': await Isolate.run(
        () => categories.map((e) => e.toMap()).toList(),
      ),
    };
  }

  Future<String?> _getDirectoryPath() async {
    String? selectedDirectory = await FilePicker.getDirectoryPath();
    return selectedDirectory;
  }

  Future<void> exportarDatabase(ExportDatabaseType type) async {
    isLoading.value = true;
    try {
      final finances = await _financeRepository.exportDatabase();
      final categories = await _categoryRepository.exportDatabase();
      final data = await _buildExportDatabaseJson(finances, categories);
      switch (type) {
        case ExportDatabaseType.csv:
          String? selectedDirectory = await _getDirectoryPath();
          if (selectedDirectory == null) return;
          for (final table in data.keys) {
            if (data[table] is! List ||
                data[table] == null ||
                (data[table] is List && data[table].isEmpty)) {
              continue;
            }
            final filePath =
                '$selectedDirectory/db_${table}_${dateFormatDdmmyyyy.format(DateTime.now()).replaceAll('/', '')}_${DateTime.now().millisecondsSinceEpoch}.csv';
            final List<Map<String, dynamic>> tableData =
                List<Map<String, dynamic>>.from(data[table]);
            final headers = tableData.first.keys.toList().join(';');
            final content = tableData.map((e) => e.values.join(';')).join('\n');
            final file = File(filePath);
            final csvData = '$headers\n$content';
            await file.writeAsString(
              csvData,
              flush: true,
              encoding: Utf8Codec(allowMalformed: true),
            );
          }
          break;
        case ExportDatabaseType.json:
          String? selectedDirectory = await _getDirectoryPath();
          if (selectedDirectory == null) return;
          final filePath =
              '$selectedDirectory/db_${dateFormatDdmmyyyy.format(DateTime.now()).replaceAll('/', '')}_${DateTime.now().millisecondsSinceEpoch}.json';
          final file = File(filePath);
          await file.writeAsString(
            json.encode(data),
            flush: true,
            encoding: Utf8Codec(allowMalformed: true),
          );
          break;
        case ExportDatabaseType.copy:
          await Clipboard.setData(ClipboardData(text: json.encode(data)));
          break;
      }
      Get.snackbar('Sucesso', 'Database exportada com sucesso!');
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
