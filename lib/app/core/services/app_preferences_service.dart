import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppPreferencesService {
  AppPreferencesService._();
  static final AppPreferencesService instance = AppPreferencesService._();

  ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.system);
  bool get isDarkMode => Theme.of(Get.context!).brightness == Brightness.dark;
  ValueNotifier<ThemeData> lightTheme = ValueNotifier(
    ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.all(Colors.grey[300]),
        thumbColor: WidgetStateProperty.all(Colors.grey[600]),
        materialTapTargetSize: MaterialTapTargetSize.padded,
        overlayColor: WidgetStateProperty.all(Colors.black),
        splashRadius: .2,
        trackOutlineWidth: WidgetStateProperty.all(1.5),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          return Colors.grey[600]; // mesma borda ligado/desligado
        }),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 19, 78, 204),
        brightness: Brightness.light,
      ),
    ),
  );
  ValueNotifier<ThemeData> darkTheme = ValueNotifier(
    ThemeData(
      scaffoldBackgroundColor: Colors.grey[900],
      cardColor: Colors.grey[700],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      brightness: Brightness.dark,
      iconTheme: IconThemeData(color: Colors.grey[200]),
      primaryColor: Color.fromARGB(255, 56, 30, 202),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: Colors.grey[850],
        headerBackgroundColor: Colors.grey[900],
        headerForegroundColor: Colors.white,
        dayStyle: TextStyle(color: Colors.white),
        yearStyle: TextStyle(color: Colors.white),
      ),
      textTheme: TextTheme(
        bodyMedium: TextStyle(color: Colors.grey[300]),
        bodyLarge: TextStyle(color: Colors.grey[300]),
        bodySmall: TextStyle(color: Colors.grey[300]),
        titleMedium: TextStyle(color: Colors.grey[300]),
        titleLarge: TextStyle(color: Colors.grey[300]),
        titleSmall: TextStyle(color: Colors.grey[300]),
        displayLarge: TextStyle(color: Colors.grey[300]),
        displayMedium: TextStyle(color: Colors.grey[300]),
        displaySmall: TextStyle(color: Colors.grey[300]),
        labelLarge: TextStyle(color: Colors.grey[300]),
        labelMedium: TextStyle(color: Colors.grey[300]),
        labelSmall: TextStyle(color: Colors.grey[300]),
        headlineLarge: TextStyle(color: Colors.grey[300]),
        headlineMedium: TextStyle(color: Colors.grey[300]),
        headlineSmall: TextStyle(color: Colors.grey[300]),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.all(Colors.grey[300]),
        thumbColor: WidgetStateProperty.all(Colors.grey[600]),
        materialTapTargetSize: MaterialTapTargetSize.padded,
        overlayColor: WidgetStateProperty.all(Colors.black),
        splashRadius: .2,
        trackOutlineWidth: WidgetStateProperty.all(1.5),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          return Colors.grey[600]; // mesma borda ligado/desligado
        }),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 4, 43, 128),
        brightness: Brightness.dark,
      ),
    ),
  );
}
