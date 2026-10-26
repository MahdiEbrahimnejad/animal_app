/// App-wide constants that are not user-visible text.
abstract final class AppConstants {
  static const String appVersion = '1.0.0';

  /// Languages the app ships with. Must match the ARB files.
  static const List<String> supportedLanguageCodes = ['fa', 'en'];
  static const String defaultLanguageCode = 'fa';

  /// How long the settings button must be held before the Parent Gate opens.
  static const Duration parentButtonHold = Duration(milliseconds: 1500);

  static const Duration pageTransition = Duration(milliseconds: 450);

  /// Safety net so a stuck platform player never blocks the slide show.
  static const Duration maxClipDuration = Duration(seconds: 8);

  static const double minNameSoundDelaySeconds = 0.2;
  static const double maxNameSoundDelaySeconds = 2.0;
}
