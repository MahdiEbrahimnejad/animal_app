// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Little Animals';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get playSound => 'Play sound';

  @override
  String get slideShow => 'Slide show';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get stop => 'Stop';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get settings => 'Settings';

  @override
  String get parentSettingsHint => 'Parents: press and hold';

  @override
  String get parentArea => 'Parent area';

  @override
  String get parentGateTitle => 'Grown-ups only';

  @override
  String parentGateQuestion(String a, String b) {
    return 'To continue, enter the answer: $a × $b = ?';
  }

  @override
  String get parentGateWrong => 'That\'s not right. Try a new question.';

  @override
  String get parentGateDelete => 'Delete';

  @override
  String get parentGateConfirm => 'OK';

  @override
  String get sectionLearning => 'Learning';

  @override
  String get sectionSound => 'Sound';

  @override
  String get sectionPremium => 'Premium & ads';

  @override
  String get sectionInfo => 'Information';

  @override
  String get language => 'Language';

  @override
  String get languageName_fa => 'فارسی';

  @override
  String get languageName_en => 'English';

  @override
  String get slideShowSpeed => 'Slide show speed';

  @override
  String get speedSlow => 'Slow';

  @override
  String get speedNormal => 'Normal';

  @override
  String get speedFast => 'Fast';

  @override
  String get nameSoundDelay => 'Pause between name and sound';

  @override
  String secondsValue(String value) {
    return '$value s';
  }

  @override
  String get soundVolume => 'Sound volume';

  @override
  String get music => 'Background music';

  @override
  String get ads => 'Ads';

  @override
  String get adsStatusOn => 'This free version shows a small, child-safe ad.';

  @override
  String get adsStatusOff => 'Ads are turned off.';

  @override
  String get adsStatusPremium => 'No ads: Premium is active.';

  @override
  String get premium => 'Premium';

  @override
  String get premiumDescription =>
      'Remove all ads and unlock future premium content.';

  @override
  String get premiumActive => 'Premium is active. Thank you!';

  @override
  String get buyPremium => 'Get Premium';

  @override
  String buyPremiumWithPrice(String price) {
    return 'Get Premium ($price)';
  }

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String get purchaseSuccess => 'Purchase completed.';

  @override
  String get purchasePending =>
      'Purchase is pending. It will activate once confirmed.';

  @override
  String get purchaseCancelled => 'Purchase cancelled.';

  @override
  String get purchaseFailed => 'Purchase failed. Please try again later.';

  @override
  String get purchaseUnavailable =>
      'The store is not available right now. Check your internet connection.';

  @override
  String get restoreSuccess => 'Purchases restored.';

  @override
  String get restoreNothing => 'No previous purchases were found.';

  @override
  String get restoreFailed => 'Restore failed. Please try again later.';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get privacyPolicyBody =>
      'Little Animals is made for young children and their families.\n\n• We do not ask for, collect or store any personal information about your child.\n• All learning content (pictures, names and sounds) is stored on the device and works offline.\n• Settings such as language and volume are saved only on this device.\n• The free version may show ads from a Google Play Families certified ad network. Ads are requested as child-directed, limited to general-audience (G) content, and are not personalized. The advertising ID is not used.\n• Purchases are handled by Google Play or the App Store. We never see your payment details.\n• Internet is only used for ads and purchases.\n\nIf you have questions, please contact us through the store listing.';

  @override
  String get privacyPolicyOnline => 'Full policy online:';

  @override
  String get about => 'About';

  @override
  String get aboutBody =>
      'Little Animals helps children under 3 learn animal names and sounds in Persian and English.';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get imageMissing => 'Picture coming soon';

  @override
  String get category_pets => 'Pets';

  @override
  String get category_farm => 'Farm';

  @override
  String get category_wild => 'Wild';

  @override
  String get category_sea => 'Sea';

  @override
  String get category_insects => 'Insects';

  @override
  String semanticsAnimalImage(String name) {
    return '$name. Tap to hear it.';
  }
}
