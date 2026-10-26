import 'package:flutter/services.dart';

import 'app_logger.dart';

/// Knows which asset files are actually bundled, so missing images or audio
/// can be skipped cheaply instead of failing at load time.
abstract interface class AssetCatalog {
  bool contains(String assetPath);
}

class BundleAssetCatalog implements AssetCatalog {
  BundleAssetCatalog._(this._assets);

  final Set<String> _assets;

  static Future<BundleAssetCatalog> load([AssetBundle? bundle]) async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(
        bundle ?? rootBundle,
      );
      return BundleAssetCatalog._(manifest.listAssets().toSet());
    } catch (e, s) {
      AppLogger.warn('Could not read asset manifest', e, s);
      return BundleAssetCatalog._(<String>{});
    }
  }

  @override
  bool contains(String assetPath) => _assets.contains(assetPath);
}

/// Test/helper catalog with an explicit set of paths.
class StaticAssetCatalog implements AssetCatalog {
  const StaticAssetCatalog(this.assets);

  final Set<String> assets;

  @override
  bool contains(String assetPath) => assets.contains(assetPath);
}
