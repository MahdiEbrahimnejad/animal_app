import 'package:flutter/foundation.dart';

/// Minimal logger. Only prints in debug builds; never sends data anywhere.
abstract final class AppLogger {
  static void info(String message) {
    if (kDebugMode) debugPrint('[info] $message');
  }

  static void warn(String message, [Object? error, StackTrace? stack]) {
    if (kDebugMode) {
      debugPrint('[warn] $message${error != null ? ': $error' : ''}');
      if (stack != null) debugPrint('$stack');
    }
  }
}
