import 'dart:math';

import 'package:flutter/material.dart';

import '../../localization/l10n.dart';
import '../../models/animal.dart';
import '../../theme/app_theme.dart';
import '../../widgets/animal_image.dart';

/// One animal: big picture (tap to hear) and its name.
class AnimalPage extends StatelessWidget {
  const AnimalPage({super.key, required this.animal, required this.onTap});

  final Animal animal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final name = animal.nameFor(lang);
    return LayoutBuilder(
      builder: (context, constraints) {
        const nameHeight = 72.0;
        final size = max(
          0.0,
          min(
            constraints.maxWidth * 0.82,
            constraints.maxHeight - nameHeight - AppSpacing.lg,
          ),
        );
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Semantics(
              button: true,
              label: context.l10n.semanticsAnimalImage(name),
              child: _TapBounce(
                onTap: onTap,
                child: AnimalImage(animal: animal, size: size),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: nameHeight,
              child: FittedBox(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Gentle press feedback. Cheap: one implicit animation.
class _TapBounce extends StatefulWidget {
  const _TapBounce({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  State<_TapBounce> createState() => _TapBounceState();
}

class _TapBounceState extends State<_TapBounce> {
  bool _pressed = false;

  void _set(bool v) {
    if (_pressed != v) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1,
        duration: const Duration(milliseconds: 150),
        child: widget.child,
      ),
    );
  }
}
