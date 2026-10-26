import 'package:animal_app/core/constants/app_constants.dart';
import 'package:animal_app/localization/l10n.dart';
import 'package:animal_app/localization/locale_resolver.dart';
import 'package:animal_app/models/animal_category.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every supported language has translations', () async {
    for (final code in AppConstants.supportedLanguageCodes) {
      final l10n = await AppLocalizations.delegate.load(Locale(code));
      expect(l10n.appTitle, isNotEmpty);
      for (final c in AnimalCategory.values) {
        expect(l10n.categoryLabel(c), isNotEmpty);
      }
    }
  });

  test('Persian and English strings differ', () async {
    final fa = await AppLocalizations.delegate.load(const Locale('fa'));
    final en = await AppLocalizations.delegate.load(const Locale('en'));
    expect(en.next, 'Next');
    expect(fa.next, 'بعدی');
    expect(fa.slideShow, isNot(en.slideShow));
  });

  test('saved language wins, otherwise the default', () {
    expect(LocaleResolver.languageCode('en'), 'en');
    expect(LocaleResolver.languageCode(null), AppConstants.defaultLanguageCode);
    expect(LocaleResolver.languageCode('xx'), AppConstants.defaultLanguageCode);
  });
}
