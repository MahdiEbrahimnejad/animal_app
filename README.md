# حیوانات کوچولو (Little Animals)

اپلیکیشن Flutter برای آموزش ۳۰ حیوان به کودکان زیر ۳ سال، به دو زبان فارسی و English.
بخش آموزشی کاملاً Offline کار می‌کند. تبلیغات، خرید Premium و Analytics پشت لایه‌های قابل تعویض قرار دارند.

> این README فارسی است. نام فایل‌ها، دستورها و اصطلاحات فنی عمداً انگلیسی مانده‌اند.

---

## فهرست

0. [ساخت APK بدون Android Studio (پیشنهاد برای شروع)](#0-ساخت-apk-بدون-android-studio)
1. [نصب Flutter](#1-نصب-flutter)
2. [نصب Dependencyها](#2-نصب-dependencyها)
3. [اجرای پروژه](#3-اجرای-پروژه)
4. [ساخت Android](#4-ساخت-android)
5. [ساخت iOS](#5-ساخت-ios)
6. [اضافه کردن حیوان](#6-اضافه-کردن-حیوان)
7. [اضافه کردن تصویر](#7-اضافه-کردن-تصویر)
8. [اضافه کردن Audio](#8-اضافه-کردن-audio)
9. [اضافه کردن زبان](#9-اضافه-کردن-زبان)
10. [تغییر Ad Provider](#10-تغییر-ad-provider)
11. [تغییر Ad Unit ID](#11-تغییر-ad-unit-id)
12. [فعال کردن AdMob](#12-فعال-کردن-admob)
13. [فعال کردن Premium](#13-فعال-کردن-premium)
14. [Restore Purchase](#14-restore-purchase)
15. [تنظیم Remote Configuration](#15-تنظیم-remote-configuration)
16. [انتشار روی Google Play](#16-انتشار-روی-google-play)
- [معماری](#معماری)
- [تست‌ها](#تستها)
- [Dependencyها](#dependencyها)
- [محدودیت‌های فعلی و قدم‌های بعدی](#محدودیتهای-فعلی-و-قدمهای-بعدی)

---

## 0. ساخت APK بدون Android Studio

برای گرفتن فایل APK لازم نیست Android Studio یا Android SDK نصب کنید. GitHub آن را در فضای ابری و به‌صورت رایگان می‌سازد:

1. یک حساب در [github.com](https://github.com) بسازید (رایگان).
2. یک Repository جدید بسازید (مثلاً `animal_app`). می‌تواند Private باشد.
3. همه فایل‌های این پوشه را در آن Repository آپلود کنید:
   - ساده‌ترین راه: در صفحه Repository روی **Add file → Upload files** بزنید و محتوای پوشه را بکشید و رها کنید (پوشه‌های `.github` و `lib` و ... هم باید آپلود شوند).
   - یا با [GitHub Desktop](https://desktop.github.com) که برنامه‌ای ساده و گرافیکی است.
4. به تب **Actions** بروید. Workflow به نام **Build APK** خودکار اجرا می‌شود (حدود ۱۰ دقیقه). اگر اجرا نشد، روی **Build APK → Run workflow** بزنید.
5. وقتی تیک سبز شد، در صفحه اصلی Repository بخش **Releases → Test build (latest)** را باز کنید و فایل `little-animals-test.apk` را مستقیم (حتی با مرورگر گوشی) دانلود کنید. همین فایل در بخش **Artifacts** همان اجرا هم به‌صورت zip هست.
6. APK را روی گوشی اندروید نصب کنید (ممکن است لازم باشد «نصب از منابع ناشناس» را برای مرورگر یا فایل‌منیجر فعال کنید).

این APK فقط **Test Ads** گوگل را نشان می‌دهد و برای تست مناسب است. برای انتشار در Google Play بخش [۱۶](#16-انتشار-روی-google-play) را ببینید.

---

## 1. نصب Flutter

فقط اگر بخواهید روی کامپیوتر خودتان اجرا و توسعه دهید لازم است.

1. Flutter SDK را از [docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install) نصب کنید. این پروژه با **Flutter 3.47.8 (Dart 3.13)** ساخته و تست شده است.
2. برای Android: Android Studio (یا فقط Android command-line tools) و JDK 17.
3. برای iOS: یک Mac با Xcode و CocoaPods.
4. بررسی نصب:

```bash
flutter doctor
```

## 2. نصب Dependencyها

```bash
cd animal_app
flutter pub get
```

فایل‌های Localization (`lib/localization/generated`) هنگام `pub get` به‌صورت خودکار ساخته می‌شوند. برای ساخت دستی: `flutter gen-l10n`.

## 3. اجرای پروژه

```bash
flutter run                    # روی گوشی/شبیه‌ساز متصل
flutter analyze                # بررسی کیفیت کد
flutter test                   # اجرای همه تست‌ها
```

در حالت Debug همیشه Test Ads نمایش داده می‌شود.

## 4. ساخت Android

```bash
# APK تستی (با Test Ads)
flutter build apk --release --dart-define=USE_TEST_ADS=true

# App Bundle برای Google Play (با IDهای واقعی، بخش ۱۱)
export ADMOB_APP_ID=ca-app-pub-XXXX~ZZZZ
flutter build appbundle --release \
  --dart-define=ADMOB_BANNER_ANDROID=ca-app-pub-XXXX/YYYY
```

خروجی: `build/app/outputs/flutter-apk/app-release.apk` و `build/app/outputs/bundle/release/app-release.aab`.

بدون Android Studio: بخش [۰](#0-ساخت-apk-بدون-android-studio).

## 5. ساخت iOS

نیاز به Mac دارد.

1. `ios/Flutter/Debug.xcconfig` و `Release.xcconfig`: مقدار `ADMOB_APP_ID` را با App ID واقعی iOS عوض کنید (فعلاً Test ID است).
2. در Xcode، Bundle Identifier و Team را تنظیم کنید (`open ios/Runner.xcworkspace`).
3. ساخت:

```bash
flutter build ipa --release \
  --dart-define=ADMOB_BANNER_IOS=ca-app-pub-XXXX/YYYY
```

4. برای App Store، بخش Kids Category و قوانین [Apple Kids](https://developer.apple.com/app-store/review/guidelines/#kids) را رعایت کنید (Parent Gate از قبل پیاده شده است).

## 6. اضافه کردن حیوان

فقط **یک Record** و فایل‌های Asset لازم است؛ هیچ Screenی تغییر نمی‌کند.

1. در `lib/data/animal_data.dart` یک Record اضافه کنید:

```dart
Animal(
  id: 'penguin',                       // فقط حروف کوچک انگلیسی و _
  category: AnimalCategory.sea,
  emoji: '🐧',                          // تا وقتی عکس نیامده نمایش داده می‌شود
  names: {'fa': 'پنگوئن', 'en': 'Penguin'},
  soundWords: {'fa': '...', 'en': '...'}, // اختیاری
),
```

2. فایل‌ها را طبق نام‌گذاری اضافه کنید (بخش ۷ و ۸).

ترتیب لیست، همان ترتیب نمایش است. دسته جدید: یک مقدار به `AnimalCategory` و کلید `category_<name>` در فایل‌های ARB اضافه کنید.

## 7. اضافه کردن تصویر

```
assets/images/animals/<id>.webp     مثلاً dog.webp
```

- فرمت پیشنهادی: **WebP**، مربع، حدود **۷۶۸×۷۶۸** پیکسل، زیر ۸۰ کیلوبایت.
- پس‌زمینه شفاف یا ساده و روشن.
- تصویر هنگام نمایش به اندازه صفحه Decode می‌شود (`cacheWidth`) تا حافظه کم مصرف شود.
- اگر تصویر نباشد یا خراب باشد، یک Placeholder رنگی با Emoji نشان داده می‌شود و برنامه Crash نمی‌کند.
- فقط از تصاویری استفاده کنید که حق استفاده تجاری از آن‌ها را دارید.

## 8. اضافه کردن Audio

```
assets/audio/fa/<id>_name_fa.mp3       نام فارسی      (dog_name_fa.mp3)
assets/audio/en/<id>_name_en.mp3       نام انگلیسی    (dog_name_en.mp3)
assets/audio/animals/<id>_sound.mp3    صدای حیوان     (dog_sound.mp3)
assets/audio/music/background.mp3      موسیقی پس‌زمینه (اختیاری)
```

- فرمت پیشنهادی: MP3 مونو، 44.1kHz، 64 تا 96 kbps، کوتاه (نام: ۱ ثانیه، صدا: ۱ تا ۳ ثانیه).
- اگر فایل نام موجود نباشد، برنامه از **Text-to-Speech آفلاین گوشی** استفاده می‌کند (اگر آن زبان روی گوشی نصب باشد). اگر صدای حیوان نباشد، کلمه `soundWords` (مثل «هاپ هاپ») خوانده می‌شود. در غیر این صورت بی‌صدا رد می‌شود و Crash نمی‌کند.
- ترتیب پخش: نام ← مکث (قابل تنظیم در Parent Area) ← صدای حیوان.

## 9. اضافه کردن زبان

مثال: Arabic (`ar`)

1. فایل `lib/localization/arb/app_ar.arb` را از روی `app_en.arb` بسازید و ترجمه کنید.
2. در `lib/core/constants/app_constants.dart`، `'ar'` را به `supportedLanguageCodes` اضافه کنید.
3. کلید `languageName_ar` را در همه ARBها و یک خط در `languageName` در `lib/localization/l10n.dart` اضافه کنید.
4. در `animal_data.dart` به `names` هر حیوان `'ar': '...'` اضافه کنید (اگر نباشد، English نمایش داده می‌شود).
5. فایل‌های صوتی را در `assets/audio/ar/<id>_name_ar.mp3` بگذارید و پوشه را در `pubspec.yaml` اضافه کنید.
6. برای TTS، Locale را در `lib/audio/flutter_tts_backend.dart` (`_locales`) اضافه کنید.

جهت RTL/LTR خودکار است. Business Logic تغییری نمی‌کند.

**تغییر زبان توسط کاربر:** Parent Area ← زبان. زبان پیش‌فرض: فارسی (`AppConstants.defaultLanguageCode`).

## 10. تغییر Ad Provider

```
App UI  →  AdService  →  AdProvider (interface)  →  AdMobProvider / ...
```

هیچ Screen یا Widgetی AdMob را نمی‌شناسد. تنها فایلی که SDK را import می‌کند `lib/ads/admob_provider.dart` است.

برای اضافه کردن شبکه جدید (مثلاً `providerb`):

1. Package شبکه را در `pubspec.yaml` اضافه کنید (مطمئن شوید جزو [Families Self-Certified Ads SDKs](https://support.google.com/googleplay/android-developer/answer/12955212) است).
2. کلاس `lib/ads/providerb_provider.dart` بسازید که `AdProvider` را implement کند (حالت Child-directed و محتوای G را در `initialize` تنظیم کنید).
3. در `lib/app/bootstrap.dart` به `adProviders` اضافه کنید:

```dart
const AdProviderRegistry adProviders = AdProviderRegistry({
  'admob': AdMobProvider.new,
  'providerb': ProviderBProvider.new,
  'none': NoAdProvider.new,
});
```

4. در `assets/config/app_config.json` (یا Remote Config) مقدار `"provider": "providerb"` بدهید.

> Remote Config فقط می‌تواند بین Providerهایی که در همین نسخه Build شده‌اند انتخاب کند. SDK جدید Native همیشه نیاز به نسخه جدید اپ دارد. Mediation هم یک Provider جدید است و بقیه برنامه تغییر نمی‌کند.

## 11. تغییر Ad Unit ID

IDهای واقعی **هرگز در Source Code** قرار نمی‌گیرند. هنگام Build با `--dart-define` داده می‌شوند:

| متغیر | توضیح |
|---|---|
| `ADMOB_BANNER_ANDROID` / `ADMOB_BANNER_IOS` | Banner Unit ID |
| `ADMOB_INTERSTITIAL_ANDROID` / `ADMOB_INTERSTITIAL_IOS` | Interstitial Unit ID |
| `USE_TEST_ADS=true` | استفاده از Test IDهای گوگل در Release |

قواعد (`lib/ads/ad_config.dart`):
- Debug: اگر ID داده نشود، Test ID.
- Release بدون ID و بدون `USE_TEST_ADS`: **هیچ تبلیغی** نمایش داده نمی‌شود (امن).

**App ID** (غیر از Unit ID):
- Android: متغیر محیطی `ADMOB_APP_ID` یا Gradle property با همین نام (در GitHub Actions، Secret به همین نام). اگر نباشد Test App ID استفاده می‌شود.
- iOS: `ios/Flutter/Release.xcconfig`.

## 12. فعال کردن AdMob

1. در [admob.google.com](https://admob.google.com) اپ را ثبت کنید و App ID و یک Banner Unit بسازید.
2. در تنظیمات اپ در AdMob، اپ را **child-directed / Designed for Families** علامت بزنید و در **Blocking controls** حداکثر رتبه محتوا را **G** قرار دهید.
3. IDها را طبق بخش ۱۱ هنگام Build بدهید.
4. در `assets/config/app_config.json`: `"adsEnabled": true` و `"provider": "admob"`.

تنظیمات کودک‌محور که از قبل در کد پیاده شده‌اند:
- `AgeRestrictedTreatment.child` (درخواست Child-directed) و `MaxAdContentRating.g`.
- `nonPersonalizedAds: true`.
- مجوز `AD_ID` در `AndroidManifest.xml` حذف شده است.
- هیچ تبلیغی هنگام شروع برنامه نیست (Banner بعد از ۳۰ ثانیه، `bannerDelaySeconds`).
- Banner با فاصله از دکمه‌های آموزشی قرار گرفته تا کلیک تصادفی کم شود.
- Interstitial پیش‌فرض **خاموش** است. اگر روشن شود، فقط در یک «توقف طبیعی» (توقف Slide Show) و حداکثر هر ۱۰ دقیقه یک‌بار.
- کاربر Premium هیچ تبلیغی نمی‌بیند (`AdService.isPremiumUser()`).

> **مهم:** پیش از انتشار، Policyهای فعلی [Google Play Families](https://support.google.com/googleplay/android-developer/answer/9893335) و [AdMob برای اپ‌های کودک](https://support.google.com/admob/answer/6223431) را دوباره بخوانید؛ این قوانین مرتب به‌روز می‌شوند. برای گروه سنی زیر ۳ سال، گزینه محتاطانه‌تر این است که Banner را خاموش کنید (`"bannerEnabled": false`) یا فقط مدل Premium داشته باشید.

## 13. فعال کردن Premium

1. در Google Play Console: **Monetize → Products → In-app products** یک محصول **یک‌بار خرید** با ID `premium_unlock` بسازید و Active کنید (برای این کار باید یک نسخه از اپ حداقل در Internal testing آپلود شده باشد).
2. برای App Store همین Product ID را به‌صورت Non-Consumable بسازید.
3. اگر ID دیگری می‌خواهید: `premiumProductId` در `assets/config/app_config.json`.
4. خرید از **Parent Area ← نسخه ویژه** انجام می‌شود (پشت Parent Gate).

معماری:
- `PurchaseService` (abstract) ← `StorePurchaseService` (تنها فایلی که `in_app_purchase` را import می‌کند).
- وضعیت Premium روی دستگاه Cache می‌شود تا Offline هم کار کند.
- `PurchaseVerifier`: پیش‌فرض به نتیجه Store اعتماد می‌کند. برای امنیت بیشتر، یک سرور کوچک بسازید که Purchase Token را با Google Play Developer API تأیید کند و آن را در `PurchaseVerifier` پیاده کنید.
- Subscription در آینده: متد و محصول جدید در `PurchaseService`؛ بقیه برنامه فقط به `isPremium` وابسته است.

## 14. Restore Purchase

دکمه **بازیابی خرید** در Parent Area، `PurchaseService.restorePurchases()` را صدا می‌زند. خریدهای قبلی از Store دریافت و تأیید می‌شوند و Premium دوباره فعال می‌شود (مثلاً بعد از نصب مجدد یا گوشی جدید). خطای اینترنت یا Store فقط یک پیام نشان می‌دهد.

## 15. تنظیم Remote Configuration

Configها از چند منبع به ترتیب خوانده می‌شوند (`lib/config/config_service.dart`):

1. مقادیر پیش‌فرض داخل کد
2. `assets/config/app_config.json` (همراه اپ، Offline)
3. (آینده) منبع Remote

```json
{
  "premiumProductId": "premium_unlock",
  "privacyPolicyUrl": "https://example.com/privacy",
  "analyticsEnabled": false,
  "ads": {
    "adsEnabled": true,
    "provider": "admob",
    "bannerEnabled": true,
    "interstitialEnabled": false,
    "bannerDelaySeconds": 30,
    "interstitialMinIntervalSeconds": 600
  }
}
```

برای Remote Config (مثلاً Firebase Remote Config):
1. کلاسی بسازید که `ConfigSource` را implement کند و JSON بالا را برگرداند.
2. در `bootstrap.dart` آن را بعد از `AssetConfigSource()` به لیست اضافه کنید.

Remote Config **فقط داده** است و هرگز کد دانلود یا اجرا نمی‌کند. Ad Unit IDها عمداً از Remote قابل تغییر نیستند. خطا یا نبود اینترنت باعث استفاده از مقادیر قبلی می‌شود.

## 16. انتشار روی Google Play

1. **Application ID** را در `android/app/build.gradle.kts` به ID خودتان تغییر دهید (مثلاً `com.yourname.littleanimals`). بعد از اولین انتشار قابل تغییر نیست.
2. **کلید امضا (Upload Key)** بسازید (یک‌بار، به Java نیاز دارد):
   ```bash
   keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
   این فایل و رمزها را امن نگه دارید و هرگز Commit نکنید.
3. **امضا روی کامپیوتر خودتان:** فایل `android/key.properties`:
   ```
   storeFile=/full/path/upload-keystore.jks
   storePassword=...
   keyAlias=upload
   keyPassword=...
   ```
   **یا در GitHub (بدون ابزار محلی):** در Settings → Secrets and variables → Actions این Secretها را بسازید:
   `ANDROID_KEYSTORE_BASE64` (خروجی `base64 upload-keystore.jks`)، `ANDROID_KEYSTORE_PASSWORD`، `ANDROID_KEY_ALIAS`، `ANDROID_KEY_PASSWORD`، و اختیاری `ADMOB_APP_ID`، `ADMOB_BANNER_ANDROID`، `ADMOB_INTERSTITIAL_ANDROID`. سپس Actions → **Release AAB** → Run workflow و فایل `.aab` را دانلود کنید.
4. شماره نسخه را در `pubspec.yaml` بالا ببرید (`version: 1.0.1+2`؛ عدد بعد از `+` باید همیشه افزایش یابد).
5. در Play Console:
   - **Target audience**: سن ۰ تا ۵ ← برنامه مشمول **Families Policy** می‌شود.
   - **Ads**: اعلام کنید که تبلیغ دارد.
   - **Data safety**: هیچ داده شخصی جمع‌آوری نمی‌شود؛ AdMob و Play Billing را طبق مستندات آن‌ها اعلام کنید.
   - **Privacy policy URL**: الزامی است. متن داخل اپ (`privacyPolicyBody` در ARB) را روی یک صفحه وب منتشر کنید و همان آدرس را در `privacyPolicyUrl` بگذارید.
   - آیکون (512×512)، Feature graphic، اسکرین‌شات‌ها.
6. اول در **Internal testing** منتشر و روی گوشی واقعی تست کنید، سپس Production.

---

## معماری

### لایه‌ها

```
┌──────────────────────────────────────────────────────────────┐
│ UI: screens/ parent/ widgets/ theme/ localization/           │  فقط نمایش
├──────────────────────────────────────────────────────────────┤
│ Logic: features/learning/LearningController                  │  ناوبری، پخش، Slide Show
│        settings/SettingsService                              │
├──────────────────────────────────────────────────────────────┤
│ Services (abstraction):                                      │
│   AudioService   AdService   PurchaseService   Analytics...  │
├──────────────────────────────────────────────────────────────┤
│ Adapters (تنها جای SDKها):                                    │
│   AudioplayersBackend  FlutterTtsBackend  AdMobProvider      │
│   StorePurchaseService  SharedPreferencesStore               │
├──────────────────────────────────────────────────────────────┤
│ Data: models/ data/animal_data.dart repositories/ config/    │
└──────────────────────────────────────────────────────────────┘
```

- **Composition root:** `lib/app/bootstrap.dart` تنها جایی است که پیاده‌سازی‌های واقعی انتخاب می‌شوند. تست‌ها همان `AppServices` را با Fakeها می‌سازند.
- **State management:** `ChangeNotifier` + Package `provider` (ساده، رسمی و کافی برای این اندازه).
- **وابستگی به SDKها:** هر SDK فقط در یک فایل import شده است:

| SDK | تنها فایل |
|---|---|
| google_mobile_ads | `lib/ads/admob_provider.dart` |
| in_app_purchase | `lib/monetization/store_purchase_service.dart` |
| audioplayers | `lib/audio/audioplayers_backend.dart` |
| flutter_tts | `lib/audio/flutter_tts_backend.dart` |
| shared_preferences | `lib/settings/key_value_store.dart` |

### ساختار پوشه‌ها

```
lib/
  main.dart                       ورود، Error handling سراسری
  app/                            AnimalApp، bootstrap (DI)، AppServices
  core/constants|errors|utils/    ثابت‌ها، Resultها، Logger، AssetCatalog، CancellableDelay
  models/                         Animal، AnimalCategory، AppSettings، SlideShowSpeed
  data/animal_data.dart           ۳۰ حیوان (تنها جای محتوا)
  repositories/                   AnimalRepository
  config/                         AppConfig، ConfigService، ConfigSource
  audio/                          AudioService، MusicService، Backendها
  ads/                            AdService، AdProvider، AdMobProvider، AdConfig
  monetization/                   PurchaseService، StorePurchaseService، EntitlementStore
  analytics/                      AnalyticsService، AnalyticsProvider
  settings/                       SettingsService، KeyValueStore
  features/learning/              LearningController (Slide Show و ناوبری)
  parent/                         Parent Gate، Parent Area، Privacy Policy
  screens/home/                   صفحه کودک
  widgets/                        Widgetهای مشترک
  theme/                          رنگ، فاصله، Theme
  localization/                   ARBها و کد تولیدشده
assets/
  images/animals/  audio/fa|en|animals|music/  config/app_config.json
test/                             Unit و Widget تست‌ها
.github/workflows/                ساخت APK و AAB در GitHub
```

### تصمیم‌ها و مشکلات احتمالی که حل شده‌اند

- **Slide Show و Memory Leak:** هر اجرای Slide Show یک شماره (`_run`) دارد؛ Pause/Stop/Dispose شماره را عوض و `CancellableDelay` را لغو می‌کنند، پس هیچ Timer یا Callback قدیمی ادامه نمی‌دهد. `LearningController` متعلق به Screen است و با آن Dispose می‌شود.
- **تداخل صداها:** `AudioService` با Token کار می‌کند؛ پخش جدید، قبلی را قطع می‌کند. هر Clip حداکثر ۸ ثانیه انتظار دارد تا Player گیرکرده Slide Show را متوقف نکند.
- **Lifecycle:** رفتن به Background ← Slide Show Pause و صدا Stop؛ موسیقی Pause و در بازگشت Resume.
- **Parent Gate برای زیر ۳ سال:** دکمه تنظیمات باید ۱.۵ ثانیه نگه داشته شود، سپس یک ضرب (مثلاً ۶ × ۷) با کیبورد عددی. کودک نمی‌تواند بخواند و شانس تصادفی حدود ۱٪ است؛ برای والدین چند ثانیه طول می‌کشد.
- **Offline First:** همه محتوا Asset است؛ تبلیغ، خرید و Config در پس‌زمینه و بدون مسدود کردن UI شروع می‌شوند و شکستشان فقط یعنی «بدون تبلیغ / بدون فروشگاه».
- **Crash نکردن:** `FlutterError.onError` و `PlatformDispatcher.onError` سراسری، `errorBuilder` تصاویر، `try/catch` در همه Adapterها.
- **Rebuild کم:** فقط `ListenableBuilder`/`Selector`های کوچک Rebuild می‌شوند؛ PageView فقط صفحات نزدیک را می‌سازد.

## تست‌ها

```bash
flutter test
```

۶۳ تست، شامل: Animal Repository، Next/Previous و چرخش، Slide Show (شروع، Pause، Resume، Stop، Background، توقف پس از Dispose)، Audio Service (ترتیب، نبود فایل، خطای پخش، قطع، Pause)، AdService (Premium، شکست بارگذاری، نبود اینترنت، Provider نامعتبر، محدودیت Interstitial)، Premium State، Config (منبع خراب/Offline)، Settings، Localization، Parent Gate، و Widget تست صفحه اصلی (نبود تصویر، Swipe، RTL، Banner برای کاربر رایگان و نبود آن برای Premium).

## Dependencyها

| Package | نسخه | کاربرد |
|---|---|---|
| provider | ^6.1.5 | تزریق وابستگی و State |
| shared_preferences | ^2.5.6 | ذخیره تنظیمات |
| audioplayers | ^6.8.1 | پخش Audio |
| flutter_tts | ^4.2.5 | خواندن نام هنگام نبود فایل صوتی |
| google_mobile_ads | ^9.2.0 | AdMob (فقط داخل Adapter) |
| in_app_purchase | ^3.3.1 | Google Play / App Store |
| intl، flutter_localizations | SDK | چندزبانه |
| fake_async (dev) | ^1.3.3 | تست Timerها |

همه آخرین نسخه پایدار در زمان ساخت (اکتبر ۲۰۲۶) هستند. برای بررسی: `flutter pub outdated`.

## محدودیت‌های فعلی و قدم‌های بعدی

- **تصاویر و صداهای واقعی هنوز اضافه نشده‌اند** (عمداً، برای جلوگیری از مشکل Copyright). برنامه با Emoji و Text-to-Speech کار می‌کند. فایل‌ها را طبق بخش ۷ و ۸ اضافه کنید؛ کد تغییری نمی‌خواهد.
- آیکون برنامه پیش‌فرض Flutter است. برای ساخت آیکون می‌توانید از Package `flutter_launcher_icons` استفاده کنید.
- فونت پیش‌فرض سیستم استفاده می‌شود. برای فونت فارسی مثل Vazirmatn (لایسنس OFL) فایل فونت را در `assets/fonts` بگذارید و در `pubspec.yaml` و `AppTheme` تعریف کنید.
- تأیید سمت سرور خرید (بخش ۱۳) برای محافظت بیشتر در برابر دستکاری توصیه می‌شود.
- Build اندروید در محیط ساخت این پروژه اجرا نشد (دسترسی به Android SDK نبود)؛ `flutter analyze` و همه تست‌ها پاس شده‌اند و Workflow گیت‌هاب اولین Build واقعی را انجام می‌دهد. اگر خطایی داد، لاگ آن را بفرستید.
