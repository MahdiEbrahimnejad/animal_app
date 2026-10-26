import '../settings/key_value_store.dart';

/// Caches the premium entitlement on the device so premium works offline.
/// The store remains the source of truth: "Restore purchases" re-syncs it.
class EntitlementStore {
  EntitlementStore(this._store);

  final KeyValueStore _store;
  static const _kPremium = 'entitlement.premium';

  bool get isPremium {
    try {
      return _store.getBool(_kPremium) ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> setPremium(bool value) async {
    try {
      await _store.setBool(_kPremium, value);
    } catch (_) {
      // Cache only; the store can be queried again via restore.
    }
  }
}
