import '../ads/ad_service.dart';
import '../analytics/analytics_service.dart';
import '../audio/audio_service.dart';
import '../audio/music_service.dart';
import '../config/app_config.dart';
import '../core/utils/asset_catalog.dart';
import '../monetization/purchase_service.dart';
import '../repositories/animal_repository.dart';
import '../settings/settings_service.dart';

/// Every app-wide service, created once in the composition root
/// (`bootstrap.dart`). Tests build this with fakes.
class AppServices {
  AppServices({
    required this.config,
    required this.assets,
    required this.settings,
    required this.animals,
    required this.audio,
    required this.music,
    required this.purchases,
    required this.ads,
    required this.analytics,
  });

  final AppConfig config;
  final AssetCatalog assets;
  final SettingsService settings;
  final AnimalRepository animals;
  final AudioService audio;
  final MusicService music;
  final PurchaseService purchases;
  final AdService ads;
  final AnalyticsService analytics;

  void _applySettings() {
    final s = settings.settings;
    audio.nameSoundDelay = s.nameSoundDelay;
    audio.setVolume(s.volume);
    music.setVolume(s.volume);
    music.setEnabled(s.musicEnabled);
  }

  /// Keeps audio in sync with settings changes.
  void start() {
    _applySettings();
    settings.addListener(_applySettings);
  }

  Future<void> dispose() async {
    settings.removeListener(_applySettings);
    ads.dispose();
    purchases.dispose();
    await audio.dispose();
    await music.dispose();
    settings.dispose();
  }
}
