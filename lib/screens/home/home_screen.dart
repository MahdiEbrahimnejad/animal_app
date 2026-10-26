import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ads/ad_service.dart';
import '../../analytics/analytics_service.dart';
import '../../audio/audio_service.dart';
import '../../core/constants/app_constants.dart';
import '../../features/learning/learning_controller.dart';
import '../../localization/l10n.dart';
import '../../localization/locale_resolver.dart';
import '../../parent/parent_area.dart';
import '../../parent/parent_gate.dart';
import '../../repositories/animal_repository.dart';
import '../../settings/settings_service.dart';
import '../../widgets/ad_banner_slot.dart';
import '../../widgets/hold_to_activate_button.dart';
import 'animal_page.dart';
import 'learning_controls.dart';

/// The child's screen: one big animal, its name and a few big buttons.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final LearningController _controller;
  late final PageController _pages;
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsService>();
    _controller = LearningController(
      repository: context.read<AnimalRepository>(),
      audio: context.read<AudioService>(),
      analytics: context.read<AnalyticsService>(),
      languageCode: () =>
          LocaleResolver.languageCode(settings.settings.languageCode),
      slideShowSpeed: () => settings.settings.slideShowSpeed,
    )..addListener(_syncPage);
    _pages = PageController(initialPage: _controller.currentIndex);
    _lifecycle = AppLifecycleListener(onHide: _controller.onAppBackground);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _controller
      ..removeListener(_syncPage)
      ..dispose();
    _pages.dispose();
    super.dispose();
  }

  /// Moves the PageView when the controller changes the animal (buttons or
  /// slide show). Neighbours animate, wrap-around jumps.
  void _syncPage() {
    if (!_pages.hasClients) return;
    final shown = _pages.page?.round() ?? _controller.currentIndex;
    final target = _controller.currentIndex;
    if (shown == target) return;
    if ((shown - target).abs() == 1) {
      unawaited(
        _pages.animateToPage(
          target,
          duration: AppConstants.pageTransition,
          curve: Curves.easeInOutCubic,
        ),
      );
    } else {
      _pages.jumpToPage(target);
    }
  }

  Future<void> _openParentArea() async {
    _controller.onAppBackground();
    final passed = await showParentGate(context);
    if (!passed || !mounted) return;
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const ParentAreaScreen()));
  }

  void _stopSlideShow() {
    _controller.stopSlideShow();
    // Natural break: the only place an interstitial may appear (disabled by
    // default, rate limited by AdService).
    unawaited(context.read<AdService>().showInterstitial());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final animals = _controller.animals;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: HoldToActivateButton(
                  key: const Key('parentButton'),
                  icon: Icons.settings_rounded,
                  label: l10n.parentSettingsHint,
                  holdDuration: AppConstants.parentButtonHold,
                  onActivated: _openParentArea,
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pages,
                itemCount: animals.length,
                onPageChanged: _controller.onPageChanged,
                itemBuilder: (context, i) => AnimalPage(
                  animal: animals[i],
                  onTap: _controller.playCurrent,
                ),
              ),
            ),
            ListenableBuilder(
              listenable: _controller,
              builder: (context, _) => LearningControls(
                slideShowState: _controller.slideShowState,
                onPrevious: _controller.previous,
                onNext: _controller.next,
                onPlay: _controller.playCurrent,
                onToggleSlideShow: _controller.toggleSlideShow,
                onStopSlideShow: _stopSlideShow,
              ),
            ),
            const AdBannerSlot(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
