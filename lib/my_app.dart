import 'package:flutter/material.dart';
import 'package:gestor_financeiro/app/core/services/app_preferences_service.dart';
import 'package:gestor_financeiro/app/routes/app_page.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        AppPreferencesService.instance.lightTheme,
        AppPreferencesService.instance.darkTheme,
        AppPreferencesService.instance.themeMode,
      ]),
      builder: (context, _) {
        return GetMaterialApp(
          title: 'Gestor Financeiro',
          theme: AppPreferencesService.instance.lightTheme.value,
          darkTheme: AppPreferencesService.instance.darkTheme.value,
          themeMode: AppPreferencesService.instance.themeMode.value,
          initialRoute: AppPage.initialRoute,
          getPages: AppPage.routes,
        );
      },
    );
  }
}
