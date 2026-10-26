import 'package:flutter/widgets.dart';

import '../models/animal_category.dart';
import '../models/slideshow_speed.dart';
import 'generated/app_localizations.dart';

export 'generated/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Mapping of enums to localized labels, kept out of the widgets.
extension L10nLabels on AppLocalizations {
  String categoryLabel(AnimalCategory c) => switch (c) {
    AnimalCategory.pets => category_pets,
    AnimalCategory.farm => category_farm,
    AnimalCategory.wild => category_wild,
    AnimalCategory.sea => category_sea,
    AnimalCategory.insects => category_insects,
  };

  String speedLabel(SlideShowSpeed s) => switch (s) {
    SlideShowSpeed.slow => speedSlow,
    SlideShowSpeed.normal => speedNormal,
    SlideShowSpeed.fast => speedFast,
  };

  /// Native name of a language, used in the language picker.
  String languageName(String code) => switch (code) {
    'fa' => languageName_fa,
    'en' => languageName_en,
    _ => code,
  };
}
