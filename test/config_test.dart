import 'package:animal_app/ads/ad_config.dart';
import 'package:animal_app/config/app_config.dart';
import 'package:animal_app/config/config_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _Source implements ConfigSource {
  _Source(this.result, {this.fail = false});
  final Map<String, Object?>? result;
  final bool fail;

  @override
  Future<Map<String, Object?>?> fetch() async {
    if (fail) throw Exception('offline');
    return result;
  }
}

void main() {
  const defaults = AppConfig(ads: AdConfig(bannerAndroidId: 'secret-id'));

  test('remote-style json changes only configuration values', () async {
    final config = await ConfigService([
      _Source({
        'ads': {
          'adsEnabled': false,
          'provider': 'none',
          'bannerEnabled': false,
          'interstitialEnabled': true,
          'bannerAndroidId': 'evil-id',
        },
      }),
    ]).load(defaults: defaults);
    expect(config.ads.adsEnabled, isFalse);
    expect(config.ads.provider, 'none');
    expect(config.ads.bannerEnabled, isFalse);
    expect(config.ads.interstitialEnabled, isTrue);
    expect(
      config.ads.bannerAndroidId,
      'secret-id',
      reason: 'ids are not remotely overridable',
    );
  });

  test('failing or malformed sources fall back to defaults', () async {
    final config = await ConfigService([
      _Source(null, fail: true),
      _Source({'ads': 'not a map', 'premiumProductId': 42}),
    ]).load(defaults: defaults);
    expect(config.ads.adsEnabled, isTrue);
    expect(config.premiumProductId, 'premium_unlock');
  });

  test('interstitial interval cannot be set below one minute', () {
    final ads = const AdConfig().applyJson({
      'interstitialMinIntervalSeconds': 5,
    });
    expect(
      ads.interstitialMinInterval,
      const AdConfig().interstitialMinInterval,
    );
  });
}
