import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mastermind_together/app.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'src/get_bindings.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env.prod");
  await GetBindings.init();
  tz.initializeTimeZones();

  FlutterError.onError = (details, {bool forceReport = false}) {
    Zone.current.handleUncaughtError(details.exception, details.stack!);
  };

  await SentryFlutter.init(
    (options) {
      options.dsn = dotenv.env['SENTRY_DSN']; // Load the DSN from .env.prod
      options.tracesSampleRate = 1.0;
      options.debug = false; // Debug mode is disabled in production
    },
    appRunner: () => runZonedGuarded(() {
      runApp(MyApp());
    }, (error, stackTrace) {
      Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
    }),
  );
}
