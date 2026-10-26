import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Little Animals'**
  String get appTitle;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @playSound.
  ///
  /// In en, this message translates to:
  /// **'Play sound'**
  String get playSound;

  /// No description provided for @slideShow.
  ///
  /// In en, this message translates to:
  /// **'Slide show'**
  String get slideShow;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @parentSettingsHint.
  ///
  /// In en, this message translates to:
  /// **'Parents: press and hold'**
  String get parentSettingsHint;

  /// No description provided for @parentArea.
  ///
  /// In en, this message translates to:
  /// **'Parent area'**
  String get parentArea;

  /// No description provided for @parentGateTitle.
  ///
  /// In en, this message translates to:
  /// **'Grown-ups only'**
  String get parentGateTitle;

  /// No description provided for @parentGateQuestion.
  ///
  /// In en, this message translates to:
  /// **'To continue, enter the answer: {a} × {b} = ?'**
  String parentGateQuestion(String a, String b);

  /// No description provided for @parentGateWrong.
  ///
  /// In en, this message translates to:
  /// **'That\'s not right. Try a new question.'**
  String get parentGateWrong;

  /// No description provided for @parentGateDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get parentGateDelete;

  /// No description provided for @parentGateConfirm.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get parentGateConfirm;

  /// No description provided for @sectionLearning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get sectionLearning;

  /// No description provided for @sectionSound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sectionSound;

  /// No description provided for @sectionPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium & ads'**
  String get sectionPremium;

  /// No description provided for @sectionInfo.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get sectionInfo;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageName_fa.
  ///
  /// In en, this message translates to:
  /// **'فارسی'**
  String get languageName_fa;

  /// No description provided for @languageName_en.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageName_en;

  /// No description provided for @slideShowSpeed.
  ///
  /// In en, this message translates to:
  /// **'Slide show speed'**
  String get slideShowSpeed;

  /// No description provided for @speedSlow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get speedSlow;

  /// No description provided for @speedNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get speedNormal;

  /// No description provided for @speedFast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get speedFast;

  /// No description provided for @nameSoundDelay.
  ///
  /// In en, this message translates to:
  /// **'Pause between name and sound'**
  String get nameSoundDelay;

  /// No description provided for @secondsValue.
  ///
  /// In en, this message translates to:
  /// **'{value} s'**
  String secondsValue(String value);

  /// No description provided for @soundVolume.
  ///
  /// In en, this message translates to:
  /// **'Sound volume'**
  String get soundVolume;

  /// No description provided for @music.
  ///
  /// In en, this message translates to:
  /// **'Background music'**
  String get music;

  /// No description provided for @ads.
  ///
  /// In en, this message translates to:
  /// **'Ads'**
  String get ads;

  /// No description provided for @adsStatusOn.
  ///
  /// In en, this message translates to:
  /// **'This free version shows a small, child-safe ad.'**
  String get adsStatusOn;

  /// No description provided for @adsStatusOff.
  ///
  /// In en, this message translates to:
  /// **'Ads are turned off.'**
  String get adsStatusOff;

  /// No description provided for @adsStatusPremium.
  ///
  /// In en, this message translates to:
  /// **'No ads: Premium is active.'**
  String get adsStatusPremium;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @premiumDescription.
  ///
  /// In en, this message translates to:
  /// **'Remove all ads and unlock future premium content.'**
  String get premiumDescription;

  /// No description provided for @premiumActive.
  ///
  /// In en, this message translates to:
  /// **'Premium is active. Thank you!'**
  String get premiumActive;

  /// No description provided for @buyPremium.
  ///
  /// In en, this message translates to:
  /// **'Get Premium'**
  String get buyPremium;

  /// No description provided for @buyPremiumWithPrice.
  ///
  /// In en, this message translates to:
  /// **'Get Premium ({price})'**
  String buyPremiumWithPrice(String price);

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get restorePurchases;

  /// No description provided for @purchaseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Purchase completed.'**
  String get purchaseSuccess;

  /// No description provided for @purchasePending.
  ///
  /// In en, this message translates to:
  /// **'Purchase is pending. It will activate once confirmed.'**
  String get purchasePending;

  /// No description provided for @purchaseCancelled.
  ///
  /// In en, this message translates to:
  /// **'Purchase cancelled.'**
  String get purchaseCancelled;

  /// No description provided for @purchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed. Please try again later.'**
  String get purchaseFailed;

  /// No description provided for @purchaseUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The store is not available right now. Check your internet connection.'**
  String get purchaseUnavailable;

  /// No description provided for @restoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Purchases restored.'**
  String get restoreSuccess;

  /// No description provided for @restoreNothing.
  ///
  /// In en, this message translates to:
  /// **'No previous purchases were found.'**
  String get restoreNothing;

  /// No description provided for @restoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Restore failed. Please try again later.'**
  String get restoreFailed;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyBody.
  ///
  /// In en, this message translates to:
  /// **'Little Animals is made for young children and their families.\n\n• We do not ask for, collect or store any personal information about your child.\n• All learning content (pictures, names and sounds) is stored on the device and works offline.\n• Settings such as language and volume are saved only on this device.\n• The free version may show ads from a Google Play Families certified ad network. Ads are requested as child-directed, limited to general-audience (G) content, and are not personalized. The advertising ID is not used.\n• Purchases are handled by Google Play or the App Store. We never see your payment details.\n• Internet is only used for ads and purchases.\n\nIf you have questions, please contact us through the store listing.'**
  String get privacyPolicyBody;

  /// No description provided for @privacyPolicyOnline.
  ///
  /// In en, this message translates to:
  /// **'Full policy online:'**
  String get privacyPolicyOnline;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'Little Animals helps children under 3 learn animal names and sounds in Persian and English.'**
  String get aboutBody;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// No description provided for @imageMissing.
  ///
  /// In en, this message translates to:
  /// **'Picture coming soon'**
  String get imageMissing;

  /// No description provided for @category_pets.
  ///
  /// In en, this message translates to:
  /// **'Pets'**
  String get category_pets;

  /// No description provided for @category_farm.
  ///
  /// In en, this message translates to:
  /// **'Farm'**
  String get category_farm;

  /// No description provided for @category_wild.
  ///
  /// In en, this message translates to:
  /// **'Wild'**
  String get category_wild;

  /// No description provided for @category_sea.
  ///
  /// In en, this message translates to:
  /// **'Sea'**
  String get category_sea;

  /// No description provided for @category_insects.
  ///
  /// In en, this message translates to:
  /// **'Insects'**
  String get category_insects;

  /// No description provided for @semanticsAnimalImage.
  ///
  /// In en, this message translates to:
  /// **'{name}. Tap to hear it.'**
  String semanticsAnimalImage(String name);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
