import 'package:flutter/widgets.dart';

/// Contract every ad network adapter implements. Only [AdService] talks to
/// providers; screens and widgets never do.
abstract interface class AdProvider {
  /// Initializes the SDK with child-directed, family-safe settings.
  Future<bool> initialize();

  Future<bool> loadBanner(String adUnitId);

  /// The loaded banner as an opaque widget, or `null` if none is loaded.
  Widget? buildBanner();

  void disposeBanner();

  Future<bool> loadInterstitial(String adUnitId);

  bool get isInterstitialReady;

  /// Shows a loaded interstitial. Completes when it was dismissed.
  Future<bool> showInterstitial();

  void dispose();
}

/// Provider used when ads are off or the configured provider is unknown.
class NoAdProvider implements AdProvider {
  @override
  Future<bool> initialize() async => false;
  @override
  Future<bool> loadBanner(String adUnitId) async => false;
  @override
  Widget? buildBanner() => null;
  @override
  void disposeBanner() {}
  @override
  Future<bool> loadInterstitial(String adUnitId) async => false;
  @override
  bool get isInterstitialReady => false;
  @override
  Future<bool> showInterstitial() async => false;
  @override
  void dispose() {}
}

typedef AdProviderBuilder = AdProvider Function();

/// Maps provider keys (as used in config) to adapters compiled into the app.
/// A new network = new [AdProvider] class + one entry here.
class AdProviderRegistry {
  const AdProviderRegistry(this._builders);

  final Map<String, AdProviderBuilder> _builders;

  AdProvider create(String key) => (_builders[key] ?? NoAdProvider.new)();
}
