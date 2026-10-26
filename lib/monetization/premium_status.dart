import 'package:flutter/foundation.dart';

/// Read-only view of the user's premium entitlement. Ads and future premium
/// content depend on this, not on a concrete store implementation.
abstract interface class PremiumStatus implements Listenable {
  bool get isPremium;
}
