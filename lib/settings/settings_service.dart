import 'package:flutter/foundation.dart';

import '../core/constants/app_constants.dart';
import '../core/utils/app_logger.dart';
import '../models/app_settings.dart';
import '../models/slideshow_speed.dart';
import 'key_value_store.dart';

/// Loads and saves [AppSettings] and notifies listeners on change.
class SettingsService extends ChangeNotifier {
  SettingsService(this._store) : _settings = _read(_store);

  final KeyValueStore _store;
  AppSettings _settings;

  static const _kLanguage = 'settings.language';
  static const _kSpeed = 'settings.slideShowSpeed';
  static const _kVolume = 'settings.volume';
  static const _kMusic = 'settings.music';
  static const _kDelayMs = 'settings.nameSoundDelayMs';

  AppSettings get settings => _settings;

  static AppSettings _read(KeyValueStore store) {
    try {
      final language = store.getString(_kLanguage);
      final delayMs = store.getInt(_kDelayMs);
      return AppSettings(
        languageCode: AppConstants.supportedLanguageCodes.contains(language)
            ? language
            : null,
        slideShowSpeed: SlideShowSpeed.fromName(store.getString(_kSpeed)),
        volume: (store.getDouble(_kVolume) ?? 1.0).clamp(0.0, 1.0),
        musicEnabled: store.getBool(_kMusic) ?? false,
        nameSoundDelay: delayMs == null
            ? const AppSettings().nameSoundDelay
            : Duration(milliseconds: delayMs),
      );
    } catch (e, s) {
      AppLogger.warn('Settings were unreadable, using defaults', e, s);
      return const AppSettings();
    }
  }

  Future<void> setLanguage(String code) async {
    if (!AppConstants.supportedLanguageCodes.contains(code)) return;
    _update(_settings.copyWith(languageCode: code));
    await _save(() => _store.setString(_kLanguage, code));
  }

  Future<void> setSlideShowSpeed(SlideShowSpeed speed) async {
    _update(_settings.copyWith(slideShowSpeed: speed));
    await _save(() => _store.setString(_kSpeed, speed.name));
  }

  Future<void> setVolume(double volume) async {
    final v = volume.clamp(0.0, 1.0);
    _update(_settings.copyWith(volume: v));
    await _save(() => _store.setDouble(_kVolume, v));
  }

  Future<void> setMusicEnabled(bool enabled) async {
    _update(_settings.copyWith(musicEnabled: enabled));
    await _save(() => _store.setBool(_kMusic, enabled));
  }

  Future<void> setNameSoundDelay(Duration delay) async {
    _update(_settings.copyWith(nameSoundDelay: delay));
    await _save(() => _store.setInt(_kDelayMs, delay.inMilliseconds));
  }

  void _update(AppSettings next) {
    _settings = next;
    notifyListeners();
  }

  Future<void> _save(Future<void> Function() write) async {
    try {
      await write();
    } catch (e, s) {
      AppLogger.warn('Could not persist setting', e, s);
    }
  }
}
