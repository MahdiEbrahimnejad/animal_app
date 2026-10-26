import 'dart:async';

import '../core/utils/app_logger.dart';
import '../core/utils/asset_catalog.dart';
import '../core/utils/cancellable_delay.dart';
import '../models/animal.dart';
import 'audio_backend.dart';

/// Plays animal names and sounds. Independent of UI and of any audio SDK.
///
/// Only one sequence plays at a time: starting a new one (or calling [stop])
/// interrupts the previous one. Missing files and playback errors are
/// swallowed so learning can always continue.
class AudioService {
  AudioService({
    required AudioBackend clips,
    required AssetCatalog assets,
    SpeechBackend? speech,
    this.nameSoundDelay = const Duration(milliseconds: 600),
  }) : _clips = clips,
       _speech = speech,
       _assets = assets;

  final AudioBackend _clips;
  final SpeechBackend? _speech;
  final AssetCatalog _assets;

  /// Default delay between an animal's name and its sound.
  Duration nameSoundDelay;

  int _token = 0;
  CancellableDelay? _delay;
  Completer<void>? _resumeGate;
  bool _disposed = false;

  bool get isPaused => _resumeGate != null;

  /// Name, short delay, then the animal's sound. Completes when finished or
  /// interrupted.
  Future<void> playAnimal(
    Animal animal, {
    required String languageCode,
    Duration? delay,
  }) async {
    final token = await _begin();
    await _playName(animal, languageCode, token);
    if (!await _wait(delay ?? nameSoundDelay, token)) return;
    await _playSound(animal, languageCode, token);
  }

  Future<void> playAnimalName(
    Animal animal, {
    required String languageCode,
  }) async {
    final token = await _begin();
    await _playName(animal, languageCode, token);
  }

  Future<void> playAnimalSound(
    Animal animal, {
    required String languageCode,
  }) async {
    final token = await _begin();
    await _playSound(animal, languageCode, token);
  }

  Future<void> stop() async {
    _token++;
    _cancelPending();
    await _safe(_clips.stop);
    final speech = _speech;
    if (speech != null) await _safe(speech.stop);
  }

  Future<void> pause() async {
    _resumeGate ??= Completer<void>();
    await _safe(_clips.pause);
    final speech = _speech;
    if (speech != null) await _safe(speech.stop);
  }

  Future<void> resume() async {
    _openResumeGate();
    await _safe(_clips.resume);
  }

  Future<void> setVolume(double volume) async {
    await _safe(() => _clips.setVolume(volume));
    final speech = _speech;
    if (speech != null) await _safe(() => speech.setVolume(volume));
  }

  Future<void> dispose() async {
    if (_disposed) return;
    await stop();
    _disposed = true;
    await _safe(_clips.dispose);
    final speech = _speech;
    if (speech != null) await _safe(speech.dispose);
  }

  // ---------------------------------------------------------------------------

  Future<int> _begin() async {
    await stop();
    return _token;
  }

  bool _alive(int token) => !_disposed && token == _token;

  Future<bool> _playName(Animal animal, String lang, int token) {
    return _playClipOrSpeak(
      asset: animal.audioNameAsset(lang),
      fallbackText: animal.nameFor(lang),
      lang: lang,
      token: token,
    );
  }

  Future<bool> _playSound(Animal animal, String lang, int token) {
    return _playClipOrSpeak(
      asset: animal.animalSound,
      fallbackText: animal.soundWordFor(lang),
      lang: lang,
      token: token,
    );
  }

  Future<bool> _playClipOrSpeak({
    required String asset,
    required String? fallbackText,
    required String lang,
    required int token,
  }) async {
    await _waitIfPaused();
    if (!_alive(token)) return false;
    try {
      if (_assets.contains(asset)) {
        return await _clips.playAsset(asset);
      }
      final speech = _speech;
      if (speech != null && fallbackText != null && fallbackText.isNotEmpty) {
        return await speech.speak(fallbackText, lang);
      }
      AppLogger.info('Audio missing, skipped: $asset');
      return false;
    } catch (e, s) {
      AppLogger.warn('Playback error for $asset', e, s);
      return false;
    }
  }

  Future<bool> _wait(Duration duration, int token) async {
    if (!_alive(token)) return false;
    final delay = CancellableDelay(duration);
    _delay = delay;
    final finished = await delay.future;
    if (identical(_delay, delay)) _delay = null;
    await _waitIfPaused();
    return finished && _alive(token);
  }

  Future<void> _waitIfPaused() async {
    final gate = _resumeGate;
    if (gate != null) await gate.future;
  }

  void _cancelPending() {
    _delay?.cancel();
    _delay = null;
    _openResumeGate();
  }

  void _openResumeGate() {
    final gate = _resumeGate;
    _resumeGate = null;
    if (gate != null && !gate.isCompleted) gate.complete();
  }

  Future<void> _safe(Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      AppLogger.warn('Audio backend error', e);
    }
  }
}
