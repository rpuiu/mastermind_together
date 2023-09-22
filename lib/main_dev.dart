import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mastermind_together/app.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:url_strategy/url_strategy.dart';

import 'src/get_bindings.dart';

Future<void> main() async {
  setPathUrlStrategy(); //Remove # from web
  await dotenv.load(fileName: ".env.dev");
  await GetBindings.init();
  tz.initializeTimeZones();
  runApp(MyApp());
}