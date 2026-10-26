import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/animal_app.dart';
import 'app/bootstrap.dart';
import 'core/utils/app_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Never crash on an unexpected error; log it (debug only) and carry on.
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    AppLogger.warn('Flutter error', details.exception, details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.warn('Uncaught error', error, stack);
    return true;
  };

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  final services = await bootstrap();
  runApp(AnimalApp(services: services));
}
