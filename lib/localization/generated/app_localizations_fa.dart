// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'حیوانات کوچولو';

  @override
  String get previous => 'قبلی';

  @override
  String get next => 'بعدی';

  @override
  String get playSound => 'پخش صدا';

  @override
  String get slideShow => 'نمایش خودکار';

  @override
  String get pause => 'مکث';

  @override
  String get resume => 'ادامه';

  @override
  String get stop => 'توقف';

  @override
  String get close => 'بستن';

  @override
  String get cancel => 'انصراف';

  @override
  String get settings => 'تنظیمات';

  @override
  String get parentSettingsHint => 'والدین: نگه دارید';

  @override
  String get parentArea => 'بخش والدین';

  @override
  String get parentGateTitle => 'فقط بزرگ‌ترها';

  @override
  String parentGateQuestion(String a, String b) {
    return 'برای ادامه، جواب را وارد کنید: $a × $b = ?';
  }

  @override
  String get parentGateWrong => 'جواب درست نیست. یک سؤال جدید امتحان کنید.';

  @override
  String get parentGateDelete => 'پاک کردن';

  @override
  String get parentGateConfirm => 'تأیید';

  @override
  String get sectionLearning => 'آموزش';

  @override
  String get sectionSound => 'صدا';

  @override
  String get sectionPremium => 'نسخه ویژه و تبلیغات';

  @override
  String get sectionInfo => 'اطلاعات';

  @override
  String get language => 'زبان';

  @override
  String get languageName_fa => 'فارسی';

  @override
  String get languageName_en => 'English';

  @override
  String get slideShowSpeed => 'سرعت نمایش خودکار';

  @override
  String get speedSlow => 'آهسته';

  @override
  String get speedNormal => 'معمولی';

  @override
  String get speedFast => 'سریع';

  @override
  String get nameSoundDelay => 'مکث بین نام و صدای حیوان';

  @override
  String secondsValue(String value) {
    return '$value ثانیه';
  }

  @override
  String get soundVolume => 'بلندی صدا';

  @override
  String get music => 'موسیقی پس‌زمینه';

  @override
  String get ads => 'تبلیغات';

  @override
  String get adsStatusOn =>
      'این نسخه رایگان یک تبلیغ کوچک و مناسب کودک نمایش می‌دهد.';

  @override
  String get adsStatusOff => 'تبلیغات خاموش است.';

  @override
  String get adsStatusPremium => 'بدون تبلیغات: نسخه ویژه فعال است.';

  @override
  String get premium => 'نسخه ویژه';

  @override
  String get premiumDescription =>
      'حذف کامل تبلیغات و دسترسی به محتوای ویژه آینده.';

  @override
  String get premiumActive => 'نسخه ویژه فعال است. از شما ممنونیم!';

  @override
  String get buyPremium => 'خرید نسخه ویژه';

  @override
  String buyPremiumWithPrice(String price) {
    return 'خرید نسخه ویژه ($price)';
  }

  @override
  String get restorePurchases => 'بازیابی خرید';

  @override
  String get purchaseSuccess => 'خرید با موفقیت انجام شد.';

  @override
  String get purchasePending =>
      'خرید در انتظار تأیید است و پس از تأیید فعال می‌شود.';

  @override
  String get purchaseCancelled => 'خرید لغو شد.';

  @override
  String get purchaseFailed => 'خرید انجام نشد. لطفاً بعداً دوباره تلاش کنید.';

  @override
  String get purchaseUnavailable =>
      'فروشگاه در حال حاضر در دسترس نیست. اتصال اینترنت را بررسی کنید.';

  @override
  String get restoreSuccess => 'خریدها بازیابی شد.';

  @override
  String get restoreNothing => 'خرید قبلی پیدا نشد.';

  @override
  String get restoreFailed =>
      'بازیابی خرید انجام نشد. لطفاً بعداً دوباره تلاش کنید.';

  @override
  String get privacyPolicy => 'حریم خصوصی';

  @override
  String get privacyPolicyBody =>
      '«حیوانات کوچولو» برای کودکان خردسال و خانواده‌هایشان ساخته شده است.\n\n• ما هیچ اطلاعات شخصی از کودک شما درخواست، جمع‌آوری یا ذخیره نمی‌کنیم.\n• همه محتوای آموزشی (تصویر، نام و صدا) روی دستگاه ذخیره شده و بدون اینترنت کار می‌کند.\n• تنظیماتی مانند زبان و بلندی صدا فقط روی همین دستگاه ذخیره می‌شوند.\n• نسخه رایگان ممکن است تبلیغاتی از یک شبکه تبلیغاتی دارای گواهی Google Play Families نمایش دهد. درخواست تبلیغات به‌صورت «مخصوص کودک»، محدود به محتوای مناسب همه سنین (G) و غیرشخصی‌سازی‌شده ارسال می‌شود و از شناسه تبلیغاتی استفاده نمی‌شود.\n• پرداخت‌ها توسط Google Play یا App Store انجام می‌شود و ما هرگز اطلاعات پرداخت شما را نمی‌بینیم.\n• اینترنت فقط برای تبلیغات و خرید استفاده می‌شود.\n\nدر صورت داشتن سؤال، از طریق صفحه برنامه در فروشگاه با ما در تماس باشید.';

  @override
  String get privacyPolicyOnline => 'متن کامل در وب‌سایت:';

  @override
  String get about => 'درباره برنامه';

  @override
  String get aboutBody =>
      '«حیوانات کوچولو» به کودکان زیر ۳ سال کمک می‌کند نام و صدای حیوانات را به فارسی و انگلیسی یاد بگیرند.';

  @override
  String version(String version) {
    return 'نسخه $version';
  }

  @override
  String get imageMissing => 'تصویر به‌زودی';

  @override
  String get category_pets => 'حیوانات خانگی';

  @override
  String get category_farm => 'مزرعه';

  @override
  String get category_wild => 'حیات وحش';

  @override
  String get category_sea => 'دریا';

  @override
  String get category_insects => 'حشرات';

  @override
  String semanticsAnimalImage(String name) {
    return '$name. برای شنیدن لمس کنید.';
  }
}
