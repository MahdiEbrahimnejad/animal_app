import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/utils/app_logger.dart';
import '../monetization/premium_status.dart';
import 'ad_config.dart';
import 'ad_provider.dart';

/// The only advertising API the app uses.
///
/// App UI -> AdService -> AdProvider -> specific ad network SDK.
///
/// Guarantees:
/// * premium users never see ads (checked on every call);
/// * no ad at app start (banner waits [AdConfig.bannerDelay]);
/// * interstitials are off by default and rate limited when enabled;
/// * any failure just means "no ad", never a crash.
class AdService extends ChangeNotifier {
  AdService({
    required AdConfig config,
    required AdProviderRegistry registry,
    required PremiumStatus premium,
    TargetPlatform? platform,
    DateTime Function()? clock,
  }) : _config = config,
       _registry = registry,
       _premium = premium,
       _platform = platform ?? defaultTargetPlatform,
       _now = clock ?? DateTime.now {
    _startedAt = _now();
    _premium.addListener(_onPremiumChanged);
  }

  final AdConfig _config;
  final AdProviderRegistry _registry;
  final PremiumStatus _premium;
  final TargetPlatform _platform;
  final DateTime Function() _now;

  late final DateTime _startedAt;
  AdProvider? _provider;
  bool _initialized = false;
  bool _bannerRequested = false;
  bool _bannerLoaded = false;
  bool _bannerLoading = false;
  Timer? _bannerTimer;
  DateTime? _lastInterstitial;
  bool _disposed = false;

  AdConfig get config => _config;

  bool isPremiumUser() => _premium.isPremium;

  /// Whether ads may be shown at all right now.
  bool get adsActive =>
      _config.adsEnabled && !_premium.isPremium && _initialized && !_disposed;

  Future<void> initialize() async {
    if (_initialized || _disposed) return;
    if (!_config.adsEnabled || _premium.isPremium) return;
    try {
      final provider = _registry.create(_config.provider);
      _provider = provider;
      _initialized = await provider.initialize();
    } catch (e, s) {
      AppLogger.warn('Ad provider init failed', e, s);
      _initialized = false;
    }
    if (_initialized) {
      if (_bannerRequested) _scheduleBanner();
      unawaited(_preloadInterstitial());
    }
  }

  bool isAdAvailable({bool interstitial = false}) {
    if (!adsActive) return false;
    return interstitial
        ? (_provider?.isInterstitialReady ?? false)
        : _bannerLoaded;
  }

  /// A screen that has a banner slot calls this when it appears.
  void showBanner() {
    _bannerRequested = true;
    _scheduleBanner();
  }

  /// Called when the banner slot goes away.
  void hideBanner() {
    _bannerRequested = false;
    _bannerTimer?.cancel();
    _dropBanner();
  }

  /// Opaque banner widget for the slot, or `null` when no ad should show.
  Widget? bannerWidget() {
    if (!adsActive || !_bannerRequested || !_bannerLoaded) return null;
    try {
      return _provider?.buildBanner();
    } catch (e) {
      AppLogger.warn('Banner build failed', e);
      return null;
    }
  }

  /// Shows an interstitial at a natural break if allowed. Returns whether
  /// one was shown.
  Future<bool> showInterstitial() async {
    if (!adsActive || !_config.interstitialEnabled) return false;
    final now = _now();
    if (now.difference(_startedAt) < _config.interstitialMinInterval) {
      return false;
    }
    final last = _lastInterstitial;
    if (last != null &&
        now.difference(last) < _config.interstitialMinInterval) {
      return false;
    }
    final provider = _provider;
    if (provider == null || !provider.isInterstitialReady) return false;
    try {
      final shown = await provider.showInterstitial();
      if (shown) _lastInterstitial = _now();
      unawaited(_preloadInterstitial());
      return shown;
    } catch (e) {
      AppLogger.warn('Interstitial failed', e);
      return false;
    }
  }

  // ---------------------------------------------------------------------------

  void _scheduleBanner() {
    if (!adsActive || !_config.bannerEnabled) return;
    if (_bannerLoaded || _bannerLoading || (_bannerTimer?.isActive ?? false)) {
      return;
    }
    final elapsed = _now().difference(_startedAt);
    final wait = _config.bannerDelay - elapsed;
    _bannerTimer = Timer(wait.isNegative ? Duration.zero : wait, _loadBanner);
  }

  Future<void> _loadBanner() async {
    final id = _config.bannerIdFor(_platform);
    final provider = _provider;
    if (id == null || provider == null || !adsActive || !_bannerRequested) {
      return;
    }
    _bannerLoading = true;
    try {
      final loaded = await provider.loadBanner(id);
      if (_disposed) return;
      _bannerLoaded = loaded && adsActive && _bannerRequested;
      if (!_bannerLoaded) provider.disposeBanner();
    } catch (e) {
      AppLogger.warn('Banner load failed', e);
      _bannerLoaded = false;
    } finally {
      _bannerLoading = false;
    }
    if (!_disposed) notifyListeners();
  }

  Future<void> _preloadInterstitial() async {
    if (!adsActive || !_config.interstitialEnabled) return;
    final id = _config.interstitialIdFor(_platform);
    if (id == null) return;
    try {
      await _provider?.loadInterstitial(id);
    } catch (e) {
      AppLogger.warn('Interstitial preload failed', e);
    }
  }

  void _dropBanner() {
    final hadBanner = _bannerLoaded;
    _bannerLoaded = false;
    try {
      _provider?.disposeBanner();
    } catch (e) {
      AppLogger.warn('Banner dispose failed', e);
    }
    if (hadBanner && !_disposed) notifyListeners();
  }

  void _onPremiumChanged() {
    if (_premium.isPremium) {
      _bannerTimer?.cancel();
      _dropBanner();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _bannerTimer?.cancel();
    _premium.removeListener(_onPremiumChanged);
    try {
      _provider?.dispose();
    } catch (_) {}
    super.dispose();
  }
}
