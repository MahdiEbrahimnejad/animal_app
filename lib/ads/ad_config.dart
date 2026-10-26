import 'package:flutter/foundation.dart';

/// Google's public AdMob test ad unit ids. Safe to commit; never earn money.
abstract final class AdMobTestIds {
  static const bannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const bannerIos = 'ca-app-pub-3940256099942544/2934735716';
  static const interstitialAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const interstitialIos = 'ca-app-pub-3940256099942544/4411468910';
}

/// Advertising configuration. Contains no widget or SDK code.
///
/// Production ad unit ids are never stored in source: they are injected at
/// build time with `--dart-define` (see README). Without them, debug builds
/// (or builds with `USE_TEST_ADS=true`) use Google test ids and release
/// builds show no ads.
@immutable
class AdConfig {
  const AdConfig({
    this.adsEnabled = true,
    this.provider = 'admob',
    this.bannerEnabled = true,
    this.interstitialEnabled = false,
    this.bannerAndroidId,
    this.bannerIosId,
    this.interstitialAndroidId,
    this.interstitialIosId,
    this.bannerDelay = const Duration(seconds: 30),
    this.interstitialMinInterval = const Duration(minutes: 10),
  });

  final bool adsEnabled;

  /// Key of the provider in the [AdProviderRegistry], e.g. `admob` or `none`.
  final String provider;
  final bool bannerEnabled;
  final bool interstitialEnabled;
  final String? bannerAndroidId;
  final String? bannerIosId;
  final String? interstitialAndroidId;
  final String? interstitialIosId;

  /// No banner is shown during the first moments after launch.
  final Duration bannerDelay;

  /// Interstitials (off by default) are never shown more often than this.
  final Duration interstitialMinInterval;

  factory AdConfig.fromEnvironment() {
    const useTestAds = bool.fromEnvironment('USE_TEST_ADS');
    const allowTestIds = kDebugMode || useTestAds;
    String? pick(String defined, String testId) =>
        defined.isNotEmpty ? defined : (allowTestIds ? testId : null);

    return AdConfig(
      bannerAndroidId: pick(
        const String.fromEnvironment('ADMOB_BANNER_ANDROID'),
        AdMobTestIds.bannerAndroid,
      ),
      bannerIosId: pick(
        const String.fromEnvironment('ADMOB_BANNER_IOS'),
        AdMobTestIds.bannerIos,
      ),
      interstitialAndroidId: pick(
        const String.fromEnvironment('ADMOB_INTERSTITIAL_ANDROID'),
        AdMobTestIds.interstitialAndroid,
      ),
      interstitialIosId: pick(
        const String.fromEnvironment('ADMOB_INTERSTITIAL_IOS'),
        AdMobTestIds.interstitialIos,
      ),
    );
  }

  String? bannerIdFor(TargetPlatform platform) => switch (platform) {
    TargetPlatform.android => bannerAndroidId,
    TargetPlatform.iOS => bannerIosId,
    _ => null,
  };

  String? interstitialIdFor(TargetPlatform platform) => switch (platform) {
    TargetPlatform.android => interstitialAndroidId,
    TargetPlatform.iOS => interstitialIosId,
    _ => null,
  };

  /// Applies values from a config document (local JSON or remote config).
  /// Unknown keys and wrong types are ignored. Ad unit ids are intentionally
  /// not overridable remotely.
  AdConfig applyJson(Map<String, Object?> json) {
    bool? b(String k) => json[k] is bool ? json[k] as bool : null;
    int? i(String k) => json[k] is int ? json[k] as int : null;
    final provider = json['provider'];
    final bannerDelay = i('bannerDelaySeconds');
    final interval = i('interstitialMinIntervalSeconds');
    return AdConfig(
      adsEnabled: b('adsEnabled') ?? adsEnabled,
      provider: provider is String && provider.isNotEmpty
          ? provider
          : this.provider,
      bannerEnabled: b('bannerEnabled') ?? bannerEnabled,
      interstitialEnabled: b('interstitialEnabled') ?? interstitialEnabled,
      bannerAndroidId: bannerAndroidId,
      bannerIosId: bannerIosId,
      interstitialAndroidId: interstitialAndroidId,
      interstitialIosId: interstitialIosId,
      bannerDelay: bannerDelay != null && bannerDelay >= 0
          ? Duration(seconds: bannerDelay)
          : this.bannerDelay,
      interstitialMinInterval: interval != null && interval >= 60
          ? Duration(seconds: interval)
          : interstitialMinInterval,
    );
  }
}
