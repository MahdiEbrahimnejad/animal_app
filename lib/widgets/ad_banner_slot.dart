import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ads/ad_service.dart';
import '../theme/app_theme.dart';

/// Reserved place for a banner. Talks only to [AdService]; it has no idea
/// which ad network (if any) is behind it. Takes no space when there is no ad.
class AdBannerSlot extends StatefulWidget {
  const AdBannerSlot({super.key});

  @override
  State<AdBannerSlot> createState() => _AdBannerSlotState();
}

class _AdBannerSlotState extends State<AdBannerSlot> {
  late final AdService _ads = context.read<AdService>();

  @override
  void initState() {
    super.initState();
    _ads.showBanner();
  }

  @override
  void dispose() {
    _ads.hideBanner();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _ads,
      builder: (context, _) {
        final banner = _ads.bannerWidget();
        if (banner == null) return const SizedBox.shrink();
        // Extra spacing keeps the ad away from the learning controls to
        // avoid accidental taps.
        return Padding(
          padding: const EdgeInsets.only(top: AppSpacing.lg),
          child: Center(child: banner),
        );
      },
    );
  }
}
