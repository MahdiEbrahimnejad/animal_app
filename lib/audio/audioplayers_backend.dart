import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import '../core/constants/app_constants.dart';
import '../core/utils/app_logger.dart';
import 'audio_backend.dart';

/// [AudioBackend] built on the `audioplayers` package.
class AudioplayersBackend implements AudioBackend {
  AudioplayersBackend({bool mixWithOthers = false}) : _player = AudioPlayer() {
    // Asset paths are passed in full (`assets/audio/...`).
    _player.audioCache.prefix = '';
    _completeSub = _player.onPlayerComplete.listen((_) => _finish(true));
    unawaited(
      _player
          .setAudioContext(
            AudioContextConfig(
              focus: mixWithOthers
                  ? AudioContextConfigFocus.mixWithOthers
                  : AudioContextConfigFocus.gain,
            ).build(),
          )
          .catchError((Object e) => AppLogger.warn('Audio context failed', e)),
    );
  }

  final AudioPlayer _player;
  late final StreamSubscription<void> _completeSub;
  Completer<bool>? _current;
  double _volume = 1.0;
  bool _disposed = false;

  void _finish(bool result) {
    final current = _current;
    _current = null;
    if (current != null && !current.isCompleted) current.complete(result);
  }

  @override
  Future<bool> playAsset(String assetPath, {bool loop = false}) async {
    if (_disposed) return false;
    _finish(false);
    final completer = Completer<bool>();
    _current = completer;
    try {
      await _player.setReleaseMode(loop ? ReleaseMode.loop : ReleaseMode.stop);
      await _player.play(AssetSource(assetPath), volume: _volume);
    } catch (e, s) {
      AppLogger.warn('Could not play $assetPath', e, s);
      _finish(false);
      return false;
    }
    if (loop) {
      _finish(true);
      return true;
    }
    return completer.future.timeout(
      AppConstants.maxClipDuration,
      onTimeout: () {
        _finish(true);
        return true;
      },
    );
  }

  @override
  Future<void> stop() async {
    _finish(false);
    if (_disposed) return;
    try {
      await _player.stop();
    } catch (e) {
      AppLogger.warn('Audio stop failed', e);
    }
  }

  @override
  Future<void> pause() async {
    if (_disposed) return;
    try {
      await _player.pause();
    } catch (e) {
      AppLogger.warn('Audio pause failed', e);
    }
  }

  @override
  Future<void> resume() async {
    if (_disposed) return;
    try {
      await _player.resume();
    } catch (e) {
      AppLogger.warn('Audio resume failed', e);
    }
  }

  @override
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    if (_disposed) return;
    try {
      await _player.setVolume(_volume);
    } catch (e) {
      AppLogger.warn('Set volume failed', e);
    }
  }

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _finish(false);
    _disposed = true;
    await _completeSub.cancel();
    try {
      await _player.dispose();
    } catch (e) {
      AppLogger.warn('Audio dispose failed', e);
    }
  }
}
