import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../ads/ad_service.dart';
import '../analytics/analytics_service.dart';
import '../audio/audio_service.dart';
import '../config/app_config.dart';
import '../core/utils/asset_catalog.dart';
import '../localization/l10n.dart';
import '../localization/locale_resolver.dart';
import '../monetization/purchase_service.dart';
import '../repositories/animal_repository.dart';
import '../screens/home/home_screen.dart';
import '../settings/settings_service.dart';
import '../theme/app_theme.dart';
import 'app_services.dart';

class AnimalApp extends StatefulWidget {
  const AnimalApp({super.key, required this.services});

  final AppServices services;

  @override
  State<AnimalApp> createState() => _AnimalAppState();
}

class _AnimalAppState extends State<AnimalApp> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    final music = widget.services.music;
    _lifecycle = AppLifecycleListener(
      onHide: music.onBackground,
      onShow: music.onForeground,
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.services;
    return MultiProvider(
      providers: [
        Provider<AppConfig>.value(value: s.config),
        Provider<AssetCatalog>.value(value: s.assets),
        Provider<AnimalRepository>.value(value: s.animals),
        Provider<AudioService>.value(value: s.audio),
        Provider<AnalyticsService>.value(value: s.analytics),
        ChangeNotifierProvider<SettingsService>.value(value: s.settings),
        ChangeNotifierProvider<PurchaseService>.value(value: s.purchases),
        ChangeNotifierProvider<AdService>.value(value: s.ads),
      ],
      child: Selector<SettingsService, String?>(
        selector: (_, settings) => settings.settings.languageCode,
        builder: (context, languageCode, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => context.l10n.appTitle,
          theme: AppTheme.light(),
          locale: LocaleResolver.locale(languageCode),
          supportedLocales: LocaleResolver.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
