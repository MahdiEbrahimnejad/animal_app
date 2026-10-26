import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/asset_catalog.dart';
import '../localization/l10n.dart';
import '../models/animal.dart';
import '../theme/app_theme.dart';

/// Animal picture, decoded at display size to save memory. Falls back to a
/// colorful placeholder when the image is missing or broken.
class AnimalImage extends StatelessWidget {
  const AnimalImage({super.key, required this.animal, required this.size});

  final Animal animal;
  final double size;

  @override
  Widget build(BuildContext context) {
    final assets = context.read<AssetCatalog>();
    final placeholder = AnimalPlaceholder(animal: animal, size: size);
    if (!assets.contains(animal.imageAsset)) return placeholder;

    final cacheSize = (size * MediaQuery.devicePixelRatioOf(context)).round();
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      child: Image.asset(
        animal.imageAsset,
        width: size,
        height: size,
        fit: BoxFit.contain,
        cacheWidth: cacheSize,
        gaplessPlayback: true,
        excludeFromSemantics: true,
        errorBuilder: (_, _, _) => placeholder,
      ),
    );
  }
}

class AnimalPlaceholder extends StatelessWidget {
  const AnimalPlaceholder({
    super.key,
    required this.animal,
    required this.size,
  });

  final Animal animal;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.forCategory(animal.category),
        borderRadius: BorderRadius.circular(AppSpacing.radius),
      ),
      child: animal.emoji.isNotEmpty
          ? Text(animal.emoji, style: TextStyle(fontSize: size * 0.55))
          : Icon(
              Icons.pets_rounded,
              size: size * 0.4,
              color: AppColors.mutedText,
              semanticLabel: context.l10n.imageMissing,
            ),
    );
  }
}
