import 'dart:async';

import 'package:animal_app/ads/ad_provider.dart';
import 'package:animal_app/audio/audio_backend.dart';
import 'package:animal_app/core/errors/app_failure.dart';
import 'package:animal_app/monetization/purchase_service.dart';
import 'package:flutter/widgets.dart';

/// Records played clips. Each clip "plays" for [clipDuration].
class FakeAudioBackend implements AudioBackend {
  FakeAudioBackend({
    this.clipDuration = const Duration(milliseconds: 500),
    this.throwOnPlay = false,
  });

  final Duration clipDuration;
  bool throwOnPlay;
  final List<String> played = [];
  int stopCalls = 0;
  bool disposed = false;
  Completer<bool>? _current;
  Timer? _timer;

  @override
  Future<bool> playAsset(String assetPath, {bool loop = false}) {
    if (throwOnPlay) throw Exception('audio device error');
    _finish(false);
    played.add(assetPath);
    final c = Completer<bool>();
    _current = c;
    if (loop) {
      _finish(true);
      return Future.value(true);
    }
    _timer = Timer(clipDuration, () => _finish(true));
    return c.future;
  }

  void _finish(bool v) {
    _timer?.cancel();
    final c = _current;
    _current = null;
    if (c != null && !c.isCompleted) c.complete(v);
  }

  @override
  Future<void> stop() async {
    stopCalls++;
    _finish(false);
  }

  @override
  Future<void> pause() async {}
  @override
  Future<void> resume() async {}
  @override
  Future<void> setVolume(double volume) async {}
  @override
  Future<void> dispose() async {
    disposed = true;
    _finish(false);
  }
}

class FakeSpeechBackend implements SpeechBackend {
  final List<String> spoken = [];
  bool available = true;

  @override
  Future<bool> speak(String text, String languageCode) async {
    if (!available) return false;
    spoken.add('$languageCode:$text');
    return true;
  }

  @override
  Future<void> stop() async {}
  @override
  Future<void> setVolume(double volume) async {}
  @override
  Future<void> dispose() async {}
}

class FakeAdProvider implements AdProvider {
  FakeAdProvider({
    this.initOk = true,
    this.bannerOk = true,
    this.throwOnLoad = false,
  });

  bool initOk;
  bool bannerOk;
  bool throwOnLoad;
  int bannerLoads = 0;
  int interstitialShows = 0;
  bool interstitialReady = true;
  bool bannerDisposed = false;

  @override
  Future<bool> initialize() async => initOk;

  @override
  Future<bool> loadBanner(String adUnitId) async {
    bannerLoads++;
    if (throwOnLoad) throw Exception('network down');
    return bannerOk;
  }

  @override
  Widget? buildBanner() =>
      const SizedBox(key: Key('fakeBanner'), width: 320, height: 50);

  @override
  void disposeBanner() => bannerDisposed = true;

  @override
  Future<bool> loadInterstitial(String adUnitId) async => true;

  @override
  bool get isInterstitialReady => interstitialReady;

  @override
  Future<bool> showInterstitial() async {
    interstitialShows++;
    return true;
  }

  @override
  void dispose() {}
}

class FakePurchaseService extends PurchaseService {
  FakePurchaseService({
    bool premium = false,
    this.result = PurchaseResult.success,
  }) : _premium = premium;

  bool _premium;
  PurchaseResult result;

  @override
  bool get isPremium => _premium;

  set premium(bool v) {
    _premium = v;
    notifyListeners();
  }

  @override
  bool get isStoreAvailable => true;

  @override
  String? get premiumPrice => null;

  @override
  Future<void> initialize() async {}

  @override
  Future<PurchaseResult> purchasePremium() async {
    if (result == PurchaseResult.success) premium = true;
    return result;
  }

  @override
  Future<RestoreResult> restorePurchases() async =>
      _premium ? RestoreResult.restored : RestoreResult.nothingToRestore;
}
