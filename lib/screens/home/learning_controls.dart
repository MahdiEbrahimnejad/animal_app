import 'dart:math';

import 'package:flutter/material.dart';

import '../../features/learning/learning_controller.dart';
import '../../localization/l10n.dart';
import '../../theme/app_theme.dart';
import '../../widgets/kid_button.dart';

/// Previous / Play / Slide show / Next (+ Stop while a slide show runs).
class LearningControls extends StatelessWidget {
  const LearningControls({
    super.key,
    required this.slideShowState,
    required this.onPrevious,
    required this.onNext,
    required this.onPlay,
    required this.onToggleSlideShow,
    required this.onStopSlideShow,
  });

  final SlideShowState slideShowState;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onPlay;
  final VoidCallback onToggleSlideShow;
  final VoidCallback onStopSlideShow;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final showStop = slideShowState != SlideShowState.stopped;
    final (slideIcon, slideLabel) = switch (slideShowState) {
      SlideShowState.stopped => (Icons.slideshow_rounded, l10n.slideShow),
      SlideShowState.playing => (Icons.pause_rounded, l10n.pause),
      SlideShowState.paused => (Icons.play_arrow_rounded, l10n.resume),
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        final count = showStop ? 5 : 4;
        final size = min(
          AppSpacing.kidButton,
          (constraints.maxWidth - AppSpacing.md * (count + 1)) / count,
        );
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              KidButton(
                key: const Key('previousButton'),
                icon: Icons.arrow_back_rounded,
                label: l10n.previous,
                onPressed: onPrevious,
                size: size,
              ),
              KidButton(
                key: const Key('playButton'),
                icon: Icons.volume_up_rounded,
                label: l10n.playSound,
                onPressed: onPlay,
                color: AppColors.primary,
                size: size,
              ),
              KidButton(
                key: const Key('slideShowButton'),
                icon: slideIcon,
                label: slideLabel,
                onPressed: onToggleSlideShow,
                color: AppColors.accent,
                size: size,
              ),
              if (showStop)
                KidButton(
                  key: const Key('stopButton'),
                  icon: Icons.stop_rounded,
                  label: l10n.stop,
                  onPressed: onStopSlideShow,
                  color: AppColors.mutedText,
                  size: size,
                ),
              KidButton(
                key: const Key('nextButton'),
                icon: Icons.arrow_forward_rounded,
                label: l10n.next,
                onPressed: onNext,
                size: size,
              ),
            ],
          ),
        );
      },
    );
  }
}
