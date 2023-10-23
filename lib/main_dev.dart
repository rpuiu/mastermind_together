import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mastermind_together/app.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_web_plugins/url_strategy.dart';


import 'src/get_bindings.dart';

Future<void> main() async {
  usePathUrlStrategy();
  await dotenv.load(fileName: ".env.dev");
  await GetBindings.init();
  tz.initializeTimeZones();
  runApp(const MyApp());
}