import 'package:animal_app/localization/l10n.dart';
import 'package:animal_app/parent/parent_gate.dart';
import 'package:animal_app/parent/parent_gate_challenge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('challenge checks the product', () {
    final c = ParentGateChallenge.fixed(7, 8);
    expect(c.check('56'), isTrue);
    expect(c.check('5'), isFalse);
    expect(c.check(''), isFalse);
  });

  test('random challenges use factors 3..9', () {
    for (var i = 0; i < 200; i++) {
      final c = ParentGateChallenge.random();
      expect(c.a, inInclusiveRange(3, 9));
      expect(c.b, inInclusiveRange(3, 9));
    }
  });

  /// Opens the gate with a fixed 6 × 7 question; returns the dialog result.
  Future<bool? Function()> openGate(WidgetTester tester) async {
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await showDialog<bool>(
                context: context,
                builder: (_) => ParentGateDialog(
                  challengeFactory: () => ParentGateChallenge.fixed(6, 7),
                ),
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return () => result;
  }

  testWidgets('correct answer opens the gate', (tester) async {
    final result = await openGate(tester);
    await tester.tap(find.byKey(const Key('parentGateKey4')));
    await tester.tap(find.byKey(const Key('parentGateKey2')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('parentGateConfirm')));
    await tester.pumpAndSettle();
    expect(result(), isTrue);
  });

  testWidgets('wrong answer keeps the gate closed', (tester) async {
    await openGate(tester);
    await tester.tap(find.byKey(const Key('parentGateKey1')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('parentGateConfirm')));
    await tester.pumpAndSettle();
    expect(find.text("That's not right. Try a new question."), findsOneWidget);
    expect(find.byType(ParentGateDialog), findsOneWidget);
  });
}
