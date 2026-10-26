/// Low-level clip player. Implementations wrap an audio SDK so that
/// [AudioService] (and everything above it) never depends on one directly.
abstract interface class AudioBackend {
  /// Plays a bundled asset. Completes with `true` when the clip finished and
  /// `false` when it failed or was interrupted by [stop] or another play.
  /// With [loop] the future completes as soon as playback has started.
  Future<bool> playAsset(String assetPath, {bool loop = false});

  Future<void> stop();
  Future<void> pause();
  Future<void> resume();
  Future<void> setVolume(double volume);
  Future<void> dispose();
}

/// Text-to-speech used as a fallback when a recorded name/sound is missing.
abstract interface class SpeechBackend {
  /// Speaks [text]. Completes with `false` if the language is unavailable or
  /// speaking failed.
  Future<bool> speak(String text, String languageCode);

  Future<void> stop();
  Future<void> setVolume(double volume);
  Future<void> dispose();
}
