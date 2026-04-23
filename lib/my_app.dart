import 'package:flutter/material.dart';
import 'package:gestor_financeiro/app/routes/app_page.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gestor Financeiro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 19, 78, 204),
        ),
      ),
      initialRoute: AppPage.initialRoute,
      getPages: AppPage.routes,
    );
  }
}
