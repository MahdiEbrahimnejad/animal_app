import 'package:animal_app/ads/ad_config.dart';
import 'package:animal_app/ads/ad_provider.dart';
import 'package:animal_app/ads/ad_service.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fakes.dart';

void main() {
  late FakeAdProvider provider;
  late FakePurchaseService purchases;
  var now = DateTime(2026);

  AdService build({
    AdConfig config = const AdConfig(
      bannerDelay: Duration.zero,
      bannerAndroidId: 'banner',
      interstitialAndroidId: 'inter',
    ),
    bool premium = false,
    String provider_ = 'admob',
  }) {
    purchases = FakePurchaseService(premium: premium);
    return AdService(
      config: config,
      registry: AdProviderRegistry({'admob': () => provider}),
      premium: purchases,
      platform: TargetPlatform.android,
      clock: () => now,
    );
  }

  setUp(() {
    provider = FakeAdProvider();
    now = DateTime(2026);
  });

  test('banner is loaded and exposed through AdService only', () async {
    final ads = build();
    await ads.initialize();
    ads.showBanner();
    await pumpEventQueue();
    expect(ads.isAdAvailable(), isTrue);
    expect(ads.bannerWidget(), isNotNull);
    ads.hideBanner();
    expect(ads.bannerWidget(), isNull);
    expect(provider.bannerDisposed, isTrue);
  });

  test('premium users never see ads', () async {
    final ads = build(premium: true);
    await ads.initialize();
    ads.showBanner();
    await pumpEventQueue();
    expect(ads.isPremiumUser(), isTrue);
    expect(ads.bannerWidget(), isNull);
    expect(provider.bannerLoads, 0);
    expect(await ads.showInterstitial(), isFalse);
  });

  test('becoming premium removes the banner immediately', () async {
    final ads = build();
    await ads.initialize();
    ads.showBanner();
    await pumpEventQueue();
    expect(ads.bannerWidget(), isNotNull);
    purchases.premium = true;
    expect(ads.bannerWidget(), isNull);
  });

  test('ad load failure does not crash', () async {
    provider = FakeAdProvider(throwOnLoad: true);
    final ads = build();
    await ads.initialize();
    ads.showBanner();
    await pumpEventQueue();
    expect(ads.bannerWidget(), isNull);
  });

  test('provider init failure (e.g. offline) means no ads', () async {
    provider = FakeAdProvider(initOk: false);
    final ads = build();
    await ads.initialize();
    ads.showBanner();
    await pumpEventQueue();
    expect(ads.adsActive, isFalse);
    expect(ads.bannerWidget(), isNull);
  });

  test('unknown provider falls back to no ads', () async {
    final ads = build(
      config: const AdConfig(provider: 'unknown', bannerDelay: Duration.zero),
    );
    await ads.initialize();
    expect(ads.adsActive, isFalse);
  });

  test('ads disabled in config', () async {
    final ads = build(config: const AdConfig(adsEnabled: false));
    await ads.initialize();
    ads.showBanner();
    expect(ads.bannerWidget(), isNull);
  });

  test('no banner during the first moments after launch', () {
    fakeAsync((async) {
      final ads = AdService(
        config: const AdConfig(
          bannerDelay: Duration(seconds: 30),
          bannerAndroidId: 'b',
        ),
        registry: AdProviderRegistry({'admob': () => provider}),
        premium: FakePurchaseService(),
        platform: TargetPlatform.android,
      );
      ads.initialize();
      ads.showBanner();
      async.elapse(const Duration(seconds: 29));
      expect(provider.bannerLoads, 0);
      async.elapse(const Duration(seconds: 2));
      expect(provider.bannerLoads, 1);
      ads.dispose();
    });
  });

  test('interstitial is off by default', () async {
    final ads = build();
    await ads.initialize();
    expect(await ads.showInterstitial(), isFalse);
  });

  test('interstitial respects minimum interval when enabled', () async {
    final ads = build(
      config: const AdConfig(
        interstitialEnabled: true,
        interstitialAndroidId: 'i',
        interstitialMinInterval: Duration(minutes: 10),
      ),
    );
    await ads.initialize();
    expect(
      await ads.showInterstitial(),
      isFalse,
      reason: 'too soon after start',
    );
    now = now.add(const Duration(minutes: 11));
    expect(await ads.showInterstitial(), isTrue);
    expect(await ads.showInterstitial(), isFalse, reason: 'rate limited');
    now = now.add(const Duration(minutes: 11));
    expect(await ads.showInterstitial(), isTrue);
    expect(provider.interstitialShows, 2);
  });

  test('NoAdProvider is harmless', () async {
    final p = NoAdProvider();
    expect(await p.initialize(), isFalse);
    expect(p.buildBanner(), isNull);
    expect(await p.showInterstitial(), isFalse);
  });
}
