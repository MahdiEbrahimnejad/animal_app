import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Large round button for small hands. The label is used for accessibility
/// (screen readers, long-press tooltip), the icon is what children see.
class KidButton extends StatelessWidget {
  const KidButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color = AppColors.secondary,
    this.size = AppSpacing.kidButton,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Tooltip(
        message: label,
        child: SizedBox.square(
          dimension: size,
          child: Material(
            color: color,
            shape: const CircleBorder(),
            elevation: 3,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPressed,
              child: Icon(icon, size: size * 0.5, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
