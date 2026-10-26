import 'package:flutter/widgets.dart';

import '../core/constants/app_constants.dart';

/// Decides the active language. Adding a language = new ARB file + adding
/// its code to [AppConstants.supportedLanguageCodes]; no logic changes.
abstract final class LocaleResolver {
  static String languageCode(String? saved) =>
      saved != null && AppConstants.supportedLanguageCodes.contains(saved)
      ? saved
      : AppConstants.defaultLanguageCode;

  static Locale locale(String? saved) => Locale(languageCode(saved));

  static List<Locale> get supportedLocales =>
      AppConstants.supportedLanguageCodes.map(Locale.new).toList();
}
