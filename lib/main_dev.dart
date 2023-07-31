import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mastermind_together/app.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'src/get_bindings.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env.dev");
  await GetBindings.init();
  tz.initializeTimeZones();

  FlutterError.onError = (details, {bool forceReport = false}) {
    Zone.current.handleUncaughtError(details.exception, details.stack!);
  };

  await SentryFlutter.init(
    (options) {
      options.dsn = dotenv.env['SENTRY_DSN']; // Load the DSN from .env.dev
      options.tracesSampleRate = 1.0;
      options.debug = true; // Debug mode is enabled in development
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
