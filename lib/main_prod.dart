import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mastermind_together/app.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'src/get_bindings.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env.prod");
  await GetBindings.init();
  tz.initializeTimeZones();
  runApp(MyApp());
}
