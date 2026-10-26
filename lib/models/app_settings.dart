import 'package:flutter/foundation.dart';

import 'slideshow_speed.dart';

/// User (parent) preferences persisted on the device.
@immutable
class AppSettings {
  const AppSettings({
    this.languageCode,
    this.slideShowSpeed = SlideShowSpeed.normal,
    this.volume = 1.0,
    this.musicEnabled = false,
    this.nameSoundDelay = const Duration(milliseconds: 600),
  });

  /// `null` means "follow the device language".
  final String? languageCode;
  final SlideShowSpeed slideShowSpeed;
  final double volume;
  final bool musicEnabled;
  final Duration nameSoundDelay;

  AppSettings copyWith({
    String? languageCode,
    SlideShowSpeed? slideShowSpeed,
    double? volume,
    bool? musicEnabled,
    Duration? nameSoundDelay,
  }) {
    return AppSettings(
      languageCode: languageCode ?? this.languageCode,
      slideShowSpeed: slideShowSpeed ?? this.slideShowSpeed,
      volume: volume ?? this.volume,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      nameSoundDelay: nameSoundDelay ?? this.nameSoundDelay,
    );
  }
}
