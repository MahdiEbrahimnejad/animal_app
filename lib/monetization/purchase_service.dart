import 'package:flutter/foundation.dart';

import '../core/errors/app_failure.dart';
import 'premium_status.dart';

/// Store-independent purchase API used by the Parent Area.
///
/// One-time "premium" unlock today; subscriptions can be added later as new
/// methods/products without changing callers of [isPremium].
abstract class PurchaseService extends ChangeNotifier implements PremiumStatus {
  @override
  bool get isPremium;

  /// Whether the store can be reached right now.
  bool get isStoreAvailable;

  /// Localized price from the store, if known.
  String? get premiumPrice;

  Future<void> initialize();

  Future<PurchaseResult> purchasePremium();

  Future<RestoreResult> restorePurchases();
}

/// Decides whether a store purchase is genuine before premium is granted.
///
/// The default trusts the store's client-side result. For stronger
/// protection, implement this with a call to your own server that validates
/// the purchase token with Google Play / Apple (see README).
abstract interface class PurchaseVerifier {
  Future<bool> verify({
    required String productId,
    required String verificationData,
  });
}

class StoreTrustingVerifier implements PurchaseVerifier {
  const StoreTrustingVerifier();

  @override
  Future<bool> verify({
    required String productId,
    required String verificationData,
  }) async => true;
}
