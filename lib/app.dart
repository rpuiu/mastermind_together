import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermind_together/src/routes.dart';
import 'package:mastermind_together/src/ui/theme/theme.dart';
import 'package:mastermind_together/src/ui/widgets/drawer/custom_navigation_observer.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.noTransition,
      initialRoute: Routes.login,
      getPages: Routes.routes,
      theme: AppTheme.lightTheme,
      navigatorObservers: [CustomNavigatorObserver()],
    );
  }
}
