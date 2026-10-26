import 'package:animal_app/core/errors/app_failure.dart';
import 'package:animal_app/monetization/entitlement_store.dart';
import 'package:animal_app/settings/key_value_store.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fakes.dart';

void main() {
  test('entitlement is cached on the device', () async {
    final store = InMemoryStore();
    expect(EntitlementStore(store).isPremium, isFalse);
    await EntitlementStore(store).setPremium(true);
    expect(EntitlementStore(store).isPremium, isTrue);
  });

  test('successful purchase turns premium on and notifies', () async {
    final service = FakePurchaseService();
    var notified = false;
    service.addListener(() => notified = true);
    expect(await service.purchasePremium(), PurchaseResult.success);
    expect(service.isPremium, isTrue);
    expect(notified, isTrue);
  });

  test('failed or cancelled purchase keeps free version', () async {
    for (final r in [
      PurchaseResult.failed,
      PurchaseResult.cancelled,
      PurchaseResult.unavailable,
    ]) {
      final service = FakePurchaseService(result: r);
      expect(await service.purchasePremium(), r);
      expect(service.isPremium, isFalse);
    }
  });

  test('restore reports nothing for a free user', () async {
    expect(
      await FakePurchaseService().restorePurchases(),
      RestoreResult.nothingToRestore,
    );
    expect(
      await FakePurchaseService(premium: true).restorePurchases(),
      RestoreResult.restored,
    );
  });
}
