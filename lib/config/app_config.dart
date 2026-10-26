import 'package:flutter/foundation.dart';

import '../ads/ad_config.dart';

/// Runtime configuration (no secrets). Can be overridden by the bundled
/// `assets/config/app_config.json` and, later, by a remote config source.
@immutable
class AppConfig {
  const AppConfig({
    required this.ads,
    this.premiumProductId = 'premium_unlock',
    this.privacyPolicyUrl = '',
    this.analyticsEnabled = false,
  });

  factory AppConfig.defaults() => AppConfig(ads: AdConfig.fromEnvironment());

  final AdConfig ads;

  /// Product id of the one-time premium purchase in Play Console/App Store.
  final String premiumProductId;
  final String privacyPolicyUrl;
  final bool analyticsEnabled;

  AppConfig applyJson(Map<String, Object?> json) {
    final ads = json['ads'];
    final productId = json['premiumProductId'];
    final privacy = json['privacyPolicyUrl'];
    final analytics = json['analyticsEnabled'];
    return AppConfig(
      ads: ads is Map<String, Object?> ? this.ads.applyJson(ads) : this.ads,
      premiumProductId: productId is String && productId.isNotEmpty
          ? productId
          : premiumProductId,
      privacyPolicyUrl: privacy is String ? privacy : privacyPolicyUrl,
      analyticsEnabled: analytics is bool ? analytics : analyticsEnabled,
    );
  }
}
