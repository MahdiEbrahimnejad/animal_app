import 'dart:async';

import 'package:flutter/foundation.dart';

import '../ads/ad_provider.dart';
import '../ads/ad_service.dart';
import '../ads/admob_provider.dart';
import '../analytics/analytics_service.dart';
import '../audio/audio_service.dart';
import '../audio/audioplayers_backend.dart';
import '../audio/flutter_tts_backend.dart';
import '../audio/music_service.dart';
import '../config/config_service.dart';
import '../core/utils/app_logger.dart';
import '../core/utils/asset_catalog.dart';
import '../data/animal_data.dart';
import '../monetization/entitlement_store.dart';
import '../monetization/store_purchase_service.dart';
import '../repositories/animal_repository.dart';
import '../settings/key_value_store.dart';
import '../settings/settings_service.dart';
import 'app_services.dart';

/// Ad networks compiled into this build. Remote config can only choose
/// between these keys; adding a network means shipping a new app version.
const AdProviderRegistry adProviders = AdProviderRegistry({
  'admob': AdMobProvider.new,
  'none': NoAdProvider.new,
});

/// Composition root: the only place that picks concrete implementations.
Future<AppServices> bootstrap() async {
  final config = await const ConfigService([AssetConfigSource()]).load();
  final assets = await BundleAssetCatalog.load();

  KeyValueStore store;
  try {
    store = await SharedPreferencesStore.create();
  } catch (e) {
    AppLogger.warn('Preferences unavailable, settings will not persist', e);
    store = InMemoryStore();
  }

  final settings = SettingsService(store);
  final purchases = StorePurchaseService(
    premiumProductId: config.premiumProductId,
    entitlements: EntitlementStore(store),
  );

  final services = AppServices(
    config: config,
    assets: assets,
    settings: settings,
    animals: LocalAnimalRepository(animalData),
    audio: AudioService(
      clips: AudioplayersBackend(),
      speech: FlutterTtsBackend(),
      assets: assets,
    ),
    music: MusicService(
      backend: AudioplayersBackend(mixWithOthers: true),
      assets: assets,
    ),
    purchases: purchases,
    ads: AdService(
      config: config.ads,
      registry: adProviders,
      premium: purchases,
    ),
    analytics: AnalyticsService(
      provider: kDebugMode
          ? const DebugAnalyticsProvider()
          : const NoopAnalyticsProvider(),
      enabled: config.analyticsEnabled,
    ),
  )..start();

  // Network-dependent services start in the background; the learning
  // experience never waits for them.
  unawaited(purchases.initialize().then((_) => services.ads.initialize()));
  return services;
}
