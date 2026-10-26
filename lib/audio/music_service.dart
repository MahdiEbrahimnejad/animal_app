import '../core/utils/asset_catalog.dart';
import 'audio_backend.dart';

/// Optional, quiet looping background music. Silently does nothing when the
/// music file is not bundled.
class MusicService {
  MusicService({required AudioBackend backend, required AssetCatalog assets})
    : _backend = backend,
      _assets = assets;

  static const String musicAsset = 'assets/audio/music/background.mp3';

  /// Music is kept well below the voice so names stay clear.
  static const double relativeVolume = 0.25;

  final AudioBackend _backend;
  final AssetCatalog _assets;
  bool _enabled = false;
  bool _playing = false;
  bool _inBackground = false;

  bool get isAvailable => _assets.contains(musicAsset);

  Future<void> setEnabled(bool enabled) async {
    _enabled = enabled;
    await _sync();
  }

  Future<void> setVolume(double volume) =>
      _backend.setVolume(volume * relativeVolume);

  Future<void> onBackground() async {
    _inBackground = true;
    if (_playing) await _backend.pause();
  }

  Future<void> onForeground() async {
    _inBackground = false;
    if (_playing) {
      await _backend.resume();
    } else {
      await _sync();
    }
  }

  Future<void> _sync() async {
    final shouldPlay = _enabled && isAvailable && !_inBackground;
    if (shouldPlay && !_playing) {
      _playing = await _backend.playAsset(musicAsset, loop: true);
    } else if (!shouldPlay && _playing) {
      _playing = false;
      await _backend.stop();
    }
  }

  Future<void> dispose() => _backend.dispose();
}
