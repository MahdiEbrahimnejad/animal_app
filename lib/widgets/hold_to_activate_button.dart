import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Small button that only fires after being held for [holdDuration], with a
/// progress ring. Prevents a quick toddler tap from opening parent features.
class HoldToActivateButton extends StatefulWidget {
  const HoldToActivateButton({
    super.key,
    required this.icon,
    required this.label,
    required this.holdDuration,
    required this.onActivated,
  });

  final IconData icon;
  final String label;
  final Duration holdDuration;
  final VoidCallback onActivated;

  @override
  State<HoldToActivateButton> createState() => _HoldToActivateButtonState();
}

class _HoldToActivateButtonState extends State<HoldToActivateButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progress = AnimationController(
    vsync: this,
    duration: widget.holdDuration,
  )..addStatusListener(_onStatus);

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _progress.reset();
      widget.onActivated();
    }
  }

  void _start() => _progress.forward(from: 0);

  void _cancel() {
    if (_progress.isAnimating) _progress.reverse();
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.label,
      onLongPress: widget.onActivated,
      excludeSemantics: true,
      child: Listener(
        onPointerDown: (_) => _start(),
        onPointerUp: (_) => _cancel(),
        onPointerCancel: (_) => _cancel(),
        child: SizedBox.square(
          dimension: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _progress,
                builder: (_, _) => CircularProgressIndicator(
                  value: _progress.value,
                  strokeWidth: 4,
                  color: AppColors.primary,
                  backgroundColor: Colors.transparent,
                ),
              ),
              Icon(widget.icon, color: AppColors.mutedText, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
