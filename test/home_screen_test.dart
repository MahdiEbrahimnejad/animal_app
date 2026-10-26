import 'package:animal_app/app/animal_app.dart';
import 'package:animal_app/parent/parent_area.dart';
import 'package:animal_app/widgets/animal_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fakes.dart';
import 'helpers/test_app.dart';

void main() {
  Future<void> pumpApp(
    WidgetTester tester, {
    String lang = 'en',
    FakeAdProvider? ads,
    FakePurchaseService? purchases,
  }) async {
    final services = buildTestServices(
      languageCode: lang,
      adProvider: ads,
      purchases: purchases,
    );
    await services.ads.initialize();
    await tester.pumpWidget(AnimalApp(services: services));
    await tester.pumpAndSettle();
  }

  testWidgets('missing image shows a placeholder instead of crashing', (
    tester,
  ) async {
    await pumpApp(tester);
    expect(find.byType(AnimalPlaceholder), findsWidgets);
    expect(find.text('Dog'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('next and previous buttons change the animal', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const Key('nextButton')));
    await tester.pumpAndSettle();
    expect(find.text('Cat'), findsOneWidget);
    await tester.tap(find.byKey(const Key('previousButton')));
    await tester.pumpAndSettle();
    expect(find.text('Dog'), findsOneWidget);
  });

  testWidgets('swiping changes the animal', (tester) async {
    await pumpApp(tester);
    await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.text('Cat'), findsOneWidget);
  });

  testWidgets('tapping the animal with no audio files does not crash', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byType(AnimalPlaceholder).first);
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.byKey(const Key('playButton')));
    await tester.pump(const Duration(seconds: 2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('slide show button toggles and shows stop', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const Key('slideShowButton')));
    await tester.pump();
    expect(find.byKey(const Key('stopButton')), findsOneWidget);
    await tester.tap(find.byKey(const Key('stopButton')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('stopButton')), findsNothing);
  });

  testWidgets('Persian UI is right-to-left with Persian names', (tester) async {
    await pumpApp(tester, lang: 'fa');
    expect(find.text('سگ'), findsOneWidget);
    final context = tester.element(find.text('سگ'));
    expect(Directionality.of(context), TextDirection.rtl);
  });

  testWidgets('a quick tap on settings does not open the parent area', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const Key('parentButton')));
    await tester.pumpAndSettle();
    expect(find.text('Grown-ups only'), findsNothing);
  });

  testWidgets('holding settings opens the parent gate', (tester) async {
    await pumpApp(tester);
    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(const Key('parentButton'))),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1600));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(find.text('Grown-ups only'), findsOneWidget);
    expect(find.byType(ParentAreaScreen), findsNothing);
  });

  testWidgets('free user sees the banner, premium user does not', (
    tester,
  ) async {
    await pumpApp(tester, ads: FakeAdProvider());
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('fakeBanner')), findsOneWidget);
  });

  testWidgets('premium user sees no banner', (tester) async {
    await pumpApp(
      tester,
      ads: FakeAdProvider(),
      purchases: FakePurchaseService(premium: true),
    );
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('fakeBanner')), findsNothing);
  });

  testWidgets('ad failure leaves the app usable', (tester) async {
    await pumpApp(tester, ads: FakeAdProvider(throwOnLoad: true));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('fakeBanner')), findsNothing);
    await tester.tap(find.byKey(const Key('nextButton')));
    await tester.pumpAndSettle();
    expect(find.text('Cat'), findsOneWidget);
  });
}
