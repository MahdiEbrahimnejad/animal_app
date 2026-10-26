import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../core/utils/app_logger.dart';
import 'ad_provider.dart';

/// AdMob adapter. The only file in the app that imports the AdMob SDK.
///
/// Configured for a Designed for Families app aimed at children:
/// child-directed age treatment, G-rated content only, non-personalized ads.
class AdMobProvider implements AdProvider {
  static const AdRequest _request = AdRequest(nonPersonalizedAds: true);

  BannerAd? _banner;
  bool _bannerLoaded = false;
  InterstitialAd? _interstitial;

  @override
  Future<bool> initialize() async {
    try {
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(
          ageRestrictedTreatment: AgeRestrictedTreatment.child,
          maxAdContentRating: MaxAdContentRating.g,
        ),
      );
      await MobileAds.instance.initialize();
      return true;
    } catch (e, s) {
      AppLogger.warn('AdMob init failed', e, s);
      return false;
    }
  }

  @override
  Future<bool> loadBanner(String adUnitId) {
    disposeBanner();
    final completer = Completer<bool>();
    final banner = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,
      request: _request,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          _bannerLoaded = true;
          if (!completer.isCompleted) completer.complete(true);
        },
        onAdFailedToLoad: (ad, error) {
          AppLogger.warn('Banner failed: ${error.message}');
          ad.dispose();
          if (identical(_banner, ad)) _banner = null;
          if (!completer.isCompleted) completer.complete(false);
        },
      ),
    );
    _banner = banner;
    unawaited(
      banner.load().catchError((Object e) {
        if (!completer.isCompleted) completer.complete(false);
      }),
    );
    return completer.future;
  }

  @override
  Widget? buildBanner() {
    final banner = _banner;
    if (banner == null || !_bannerLoaded) return null;
    return SizedBox(
      width: banner.size.width.toDouble(),
      height: banner.size.height.toDouble(),
      child: AdWidget(ad: banner),
    );
  }

  @override
  void disposeBanner() {
    _bannerLoaded = false;
    _banner?.dispose();
    _banner = null;
  }

  @override
  Future<bool> loadInterstitial(String adUnitId) {
    final completer = Completer<bool>();
    unawaited(
      InterstitialAd.load(
        adUnitId: adUnitId,
        request: _request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitial?.dispose();
            _interstitial = ad;
            if (!completer.isCompleted) completer.complete(true);
          },
          onAdFailedToLoad: (error) {
            AppLogger.warn('Interstitial failed: ${error.message}');
            if (!completer.isCompleted) completer.complete(false);
          },
        ),
      ).catchError((Object e) {
        if (!completer.isCompleted) completer.complete(false);
      }),
    );
    return completer.future;
  }

  @override
  bool get isInterstitialReady => _interstitial != null;

  @override
  Future<bool> showInterstitial() async {
    final ad = _interstitial;
    if (ad == null) return false;
    _interstitial = null;
    final completer = Completer<bool>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        if (!completer.isCompleted) completer.complete(true);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        if (!completer.isCompleted) completer.complete(false);
      },
    );
    try {
      await ad.show();
    } catch (e) {
      unawaited(ad.dispose());
      return false;
    }
    return completer.future;
  }

  @override
  void dispose() {
    disposeBanner();
    _interstitial?.dispose();
    _interstitial = null;
  }
}
