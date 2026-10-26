import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';

import '../core/constants/app_constants.dart';
import '../core/utils/app_logger.dart';
import 'audio_backend.dart';

/// [SpeechBackend] using the device's offline text-to-speech engine.
/// Only used when a recorded audio file is missing.
class FlutterTtsBackend implements SpeechBackend {
  FlutterTts? _tts;
  double _volume = 1.0;
  final Map<String, bool> _languageAvailable = {};

  static const Map<String, String> _locales = {'fa': 'fa-IR', 'en': 'en-US'};

  Future<FlutterTts> _engine() async {
    final existing = _tts;
    if (existing != null) return existing;
    final tts = FlutterTts();
    await tts.awaitSpeakCompletion(true);
    await tts.setSpeechRate(0.4);
    _tts = tts;
    return tts;
  }

  @override
  Future<bool> speak(String text, String languageCode) async {
    if (text.isEmpty) return false;
    try {
      final tts = await _engine();
      final locale = _locales[languageCode] ?? languageCode;
      final available = _languageAvailable[locale] ??=
          (await tts.isLanguageAvailable(locale)) == true;
      if (!available) return false;
      await tts.setLanguage(locale);
      await tts.setVolume(_volume);
      final result = await tts
          .speak(text)
          .timeout(AppConstants.maxClipDuration, onTimeout: () => 0);
      return result == 1;
    } catch (e) {
      AppLogger.warn('Text-to-speech unavailable', e);
      return false;
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _tts?.stop();
    } catch (e) {
      AppLogger.warn('TTS stop failed', e);
    }
  }

  @override
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
  }

  @override
  Future<void> dispose() => stop();
}
