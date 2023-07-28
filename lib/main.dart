import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/theme.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'src/get_bindings.dart';

Future<void> main() async {
  await dotenv.load();
  await GetBindings.init();
  tz.initializeTimeZones();
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
      theme: AppTheme.lightTheme,
    );
  }
}
