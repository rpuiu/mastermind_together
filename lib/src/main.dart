import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/routes.dart';

import 'get_bindings.dart';

Future<void> main() async {
  await GetBindings.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.login,
      getPages: Routes.routes,
      theme: ThemeData(
          // primaryColor: const Color(0xFF23FF87),
          ),
    );
  }
}
