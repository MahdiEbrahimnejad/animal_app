import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

import '../core/errors/app_failure.dart';
import '../core/utils/app_logger.dart';
import 'entitlement_store.dart';
import 'purchase_service.dart';

/// [PurchaseService] for Google Play Billing / App Store via `in_app_purchase`.
/// The only file that imports the purchase SDK.
class StorePurchaseService extends PurchaseService {
  StorePurchaseService({
    required this.premiumProductId,
    required EntitlementStore entitlements,
    PurchaseVerifier verifier = const StoreTrustingVerifier(),
    InAppPurchase? iap,
  }) : _entitlements = entitlements,
       _verifier = verifier,
       _iapOverride = iap,
       _isPremium = entitlements.isPremium;

  final String premiumProductId;
  final EntitlementStore _entitlements;
  final PurchaseVerifier _verifier;
  final InAppPurchase? _iapOverride;

  InAppPurchase get _iap => _iapOverride ?? InAppPurchase.instance;

  bool _isPremium;
  bool _available = false;
  ProductDetails? _product;
  StreamSubscription<List<PurchaseDetails>>? _sub;
  Completer<PurchaseResult>? _purchaseCompleter;
  bool _restoring = false;
  bool _restoredSomething = false;

  static const Duration _restoreWindow = Duration(seconds: 4);

  @override
  bool get isPremium => _isPremium;

  @override
  bool get isStoreAvailable => _available && _product != null;

  @override
  String? get premiumPrice => _product?.price;

  @override
  Future<void> initialize() async {
    try {
      _sub ??= _iap.purchaseStream.listen(
        _onPurchases,
        onError: (Object e) => AppLogger.warn('Purchase stream error', e),
      );
      _available = await _iap.isAvailable();
      if (!_available) return;
      final response = await _iap.queryProductDetails({premiumProductId});
      _product = response.productDetails.isEmpty
          ? null
          : response.productDetails.first;
      if (response.notFoundIDs.isNotEmpty) {
        AppLogger.warn('Product not found in store: ${response.notFoundIDs}');
      }
    } catch (e, s) {
      AppLogger.warn('Store unavailable', e, s);
      _available = false;
    }
    notifyListeners();
  }

  @override
  Future<PurchaseResult> purchasePremium() async {
    if (_isPremium) return PurchaseResult.success;
    if (!isStoreAvailable) {
      await initialize();
      if (!isStoreAvailable) return PurchaseResult.unavailable;
    }
    final completer = Completer<PurchaseResult>();
    _purchaseCompleter = completer;
    try {
      final started = await _iap.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: _product!),
      );
      if (!started) return _finishPurchase(PurchaseResult.failed);
    } catch (e, s) {
      AppLogger.warn('Purchase failed to start', e, s);
      return _finishPurchase(PurchaseResult.failed);
    }
    return completer.future.timeout(
      const Duration(minutes: 3),
      onTimeout: () => _finishPurchase(PurchaseResult.pending),
    );
  }

  @override
  Future<RestoreResult> restorePurchases() async {
    try {
      _available = await _iap.isAvailable();
      if (!_available) return RestoreResult.unavailable;
      _restoring = true;
      _restoredSomething = false;
      await _iap.restorePurchases();
      // Restored purchases arrive asynchronously on the purchase stream.
      await Future<void>.delayed(_restoreWindow);
      return _restoredSomething || _isPremium
          ? RestoreResult.restored
          : RestoreResult.nothingToRestore;
    } catch (e, s) {
      AppLogger.warn('Restore failed', e, s);
      return RestoreResult.failed;
    } finally {
      _restoring = false;
    }
  }

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final p in purchases) {
      try {
        await _handle(p);
      } catch (e, s) {
        AppLogger.warn('Purchase handling failed', e, s);
      }
    }
  }

  Future<void> _handle(PurchaseDetails p) async {
    if (p.productID != premiumProductId) {
      if (p.pendingCompletePurchase) await _iap.completePurchase(p);
      return;
    }
    switch (p.status) {
      case PurchaseStatus.pending:
        _finishPurchase(PurchaseResult.pending);
      case PurchaseStatus.purchased:
      case PurchaseStatus.restored:
        final valid = await _verifier.verify(
          productId: p.productID,
          verificationData: p.verificationData.serverVerificationData,
        );
        if (valid) {
          await _grantPremium();
          if (_restoring) _restoredSomething = true;
          _finishPurchase(PurchaseResult.success);
        } else {
          _finishPurchase(PurchaseResult.failed);
        }
      case PurchaseStatus.error:
        _finishPurchase(PurchaseResult.failed);
      case PurchaseStatus.canceled:
        _finishPurchase(PurchaseResult.cancelled);
    }
    if (p.pendingCompletePurchase) await _iap.completePurchase(p);
  }

  PurchaseResult _finishPurchase(PurchaseResult result) {
    final completer = _purchaseCompleter;
    _purchaseCompleter = null;
    if (completer != null && !completer.isCompleted) completer.complete(result);
    return result;
  }

  Future<void> _grantPremium() async {
    if (_isPremium) return;
    _isPremium = true;
    await _entitlements.setPremium(true);
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_sub?.cancel());
    _finishPurchase(PurchaseResult.cancelled);
    super.dispose();
  }
}
