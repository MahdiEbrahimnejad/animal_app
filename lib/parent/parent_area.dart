import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ads/ad_service.dart';
import '../config/app_config.dart';
import '../core/constants/app_constants.dart';
import '../core/errors/app_failure.dart';
import '../localization/l10n.dart';
import '../models/slideshow_speed.dart';
import '../monetization/purchase_service.dart';
import '../settings/settings_service.dart';
import '../theme/app_theme.dart';
import 'privacy_policy_screen.dart';

/// Settings, purchases and information for parents. Reached only through
/// the Parent Gate.
class ParentAreaScreen extends StatelessWidget {
  const ParentAreaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.parentArea)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xl),
          children: [
            _SectionTitle(l10n.sectionLearning),
            const _LanguageTile(),
            const _SpeedTile(),
            const _DelayTile(),
            _SectionTitle(l10n.sectionSound),
            const _VolumeTile(),
            const _MusicTile(),
            _SectionTitle(l10n.sectionPremium),
            const _PremiumCard(),
            const _AdsStatusTile(),
            _SectionTitle(l10n.sectionInfo),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: Text(l10n.privacyPolicy),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const PrivacyPolicyScreen(),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(l10n.about),
                    onTap: () => showAboutDialog(
                      context: context,
                      applicationName: l10n.appTitle,
                      applicationVersion: l10n.version(AppConstants.appVersion),
                      children: [Text(l10n.aboutBody)],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final current = Localizations.localeOf(context).languageCode;
    final settings = context.read<SettingsService>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.language),
            const SizedBox(height: AppSpacing.sm),
            SegmentedButton<String>(
              segments: [
                for (final code in AppConstants.supportedLanguageCodes)
                  ButtonSegment(
                    value: code,
                    label: Text(l10n.languageName(code)),
                  ),
              ],
              selected: {current},
              onSelectionChanged: (s) => settings.setLanguage(s.first),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpeedTile extends StatelessWidget {
  const _SpeedTile();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final speed = context.select<SettingsService, SlideShowSpeed>(
      (s) => s.settings.slideShowSpeed,
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.slideShowSpeed),
            const SizedBox(height: AppSpacing.sm),
            SegmentedButton<SlideShowSpeed>(
              segments: [
                for (final s in SlideShowSpeed.values)
                  ButtonSegment(value: s, label: Text(l10n.speedLabel(s))),
              ],
              selected: {speed},
              onSelectionChanged: (s) =>
                  context.read<SettingsService>().setSlideShowSpeed(s.first),
            ),
          ],
        ),
      ),
    );
  }
}

class _DelayTile extends StatelessWidget {
  const _DelayTile();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final delay = context.select<SettingsService, Duration>(
      (s) => s.settings.nameSoundDelay,
    );
    final seconds = (delay.inMilliseconds / 1000).clamp(
      AppConstants.minNameSoundDelaySeconds,
      AppConstants.maxNameSoundDelaySeconds,
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.nameSoundDelay),
            Slider(
              value: seconds,
              min: AppConstants.minNameSoundDelaySeconds,
              max: AppConstants.maxNameSoundDelaySeconds,
              divisions: 9,
              label: l10n.secondsValue(seconds.toStringAsFixed(1)),
              onChanged: (v) =>
                  context.read<SettingsService>().setNameSoundDelay(
                    Duration(milliseconds: (v * 1000).round()),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VolumeTile extends StatelessWidget {
  const _VolumeTile();

  @override
  Widget build(BuildContext context) {
    final volume = context.select<SettingsService, double>(
      (s) => s.settings.volume,
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            const Icon(Icons.volume_up_rounded),
            const SizedBox(width: AppSpacing.sm),
            Text(context.l10n.soundVolume),
            Expanded(
              child: Slider(
                value: volume,
                onChanged: (v) => context.read<SettingsService>().setVolume(v),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MusicTile extends StatelessWidget {
  const _MusicTile();

  @override
  Widget build(BuildContext context) {
    final enabled = context.select<SettingsService, bool>(
      (s) => s.settings.musicEnabled,
    );
    return Card(
      child: SwitchListTile(
        secondary: const Icon(Icons.music_note_rounded),
        title: Text(context.l10n.music),
        value: enabled,
        onChanged: (v) => context.read<SettingsService>().setMusicEnabled(v),
      ),
    );
  }
}

class _AdsStatusTile extends StatelessWidget {
  const _AdsStatusTile();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final premium = context.select<PurchaseService, bool>((p) => p.isPremium);
    final adsEnabled = context.read<AppConfig>().ads.adsEnabled;
    final text = premium
        ? l10n.adsStatusPremium
        : (adsEnabled ? l10n.adsStatusOn : l10n.adsStatusOff);
    return Card(
      child: ListTile(
        leading: const Icon(Icons.campaign_outlined),
        title: Text(l10n.ads),
        subtitle: Text(text),
      ),
    );
  }
}

class _PremiumCard extends StatefulWidget {
  const _PremiumCard();

  @override
  State<_PremiumCard> createState() => _PremiumCardState();
}

class _PremiumCardState extends State<_PremiumCard> {
  bool _busy = false;

  Future<void> _run(Future<String> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    final message = await action();
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<String> _buy() async {
    final l10n = context.l10n;
    final result = await context.read<PurchaseService>().purchasePremium();
    return switch (result) {
      PurchaseResult.success => l10n.purchaseSuccess,
      PurchaseResult.pending => l10n.purchasePending,
      PurchaseResult.cancelled => l10n.purchaseCancelled,
      PurchaseResult.failed => l10n.purchaseFailed,
      PurchaseResult.unavailable => l10n.purchaseUnavailable,
    };
  }

  Future<String> _restore() async {
    final l10n = context.l10n;
    final result = await context.read<PurchaseService>().restorePurchases();
    return switch (result) {
      RestoreResult.restored => l10n.restoreSuccess,
      RestoreResult.nothingToRestore => l10n.restoreNothing,
      RestoreResult.failed => l10n.restoreFailed,
      RestoreResult.unavailable => l10n.purchaseUnavailable,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final purchases = context.watch<PurchaseService>();
    // Ads listen too, so the banner disappears right after purchase.
    context.watch<AdService>();
    final price = purchases.premiumPrice;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.star_rounded, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  l10n.premium,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              purchases.isPremium
                  ? l10n.premiumActive
                  : l10n.premiumDescription,
            ),
            const SizedBox(height: AppSpacing.md),
            if (!purchases.isPremium)
              FilledButton(
                onPressed: _busy ? null : () => _run(_buy),
                child: Text(
                  price == null
                      ? l10n.buyPremium
                      : l10n.buyPremiumWithPrice(price),
                ),
              ),
            TextButton(
              onPressed: _busy ? null : () => _run(_restore),
              child: Text(l10n.restorePurchases),
            ),
            if (_busy) const LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
