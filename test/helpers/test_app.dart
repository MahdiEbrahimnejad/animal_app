import 'package:animal_app/ads/ad_config.dart';
import 'package:animal_app/ads/ad_provider.dart';
import 'package:animal_app/ads/ad_service.dart';
import 'package:animal_app/analytics/analytics_service.dart';
import 'package:animal_app/app/app_services.dart';
import 'package:animal_app/audio/audio_service.dart';
import 'package:animal_app/audio/music_service.dart';
import 'package:animal_app/config/app_config.dart';
import 'package:animal_app/core/utils/asset_catalog.dart';
import 'package:animal_app/data/animal_data.dart';
import 'package:animal_app/repositories/animal_repository.dart';
import 'package:animal_app/settings/key_value_store.dart';
import 'package:animal_app/settings/settings_service.dart';

import 'fakes.dart';

/// Builds [AppServices] with fakes: no plugins, no network, no assets.
AppServices buildTestServices({
  FakeAudioBackend? clips,
  FakePurchaseService? purchases,
  AdProvider? adProvider,
  AssetCatalog assets = const StaticAssetCatalog({}),
  String? languageCode,
}) {
  final store = InMemoryStore();
  if (languageCode != null) store.setString('settings.language', languageCode);
  final p = purchases ?? FakePurchaseService();
  final provider = adProvider ?? NoAdProvider();
  return AppServices(
    config: const AppConfig(ads: AdConfig(bannerDelay: Duration.zero)),
    assets: assets,
    settings: SettingsService(store),
    animals: LocalAnimalRepository(animalData),
    audio: AudioService(clips: clips ?? FakeAudioBackend(), assets: assets),
    music: MusicService(backend: FakeAudioBackend(), assets: assets),
    purchases: p,
    ads: AdService(
      config: const AdConfig(
        bannerDelay: Duration.zero,
        bannerAndroidId: 'test',
      ),
      registry: AdProviderRegistry({'admob': () => provider}),
      premium: p,
    ),
    analytics: AnalyticsService(),
  );
}
