import 'dart:convert';

import 'package:flutter/services.dart';

import '../core/utils/app_logger.dart';
import 'app_config.dart';

/// A source of configuration values (data only, never code).
abstract interface class ConfigSource {
  /// Returns a JSON object, or `null` if nothing is available.
  Future<Map<String, Object?>?> fetch();
}

/// Reads the bundled `assets/config/app_config.json`. Works offline.
class AssetConfigSource implements ConfigSource {
  const AssetConfigSource({
    this.path = 'assets/config/app_config.json',
    this.bundle,
  });

  final String path;
  final AssetBundle? bundle;

  @override
  Future<Map<String, Object?>?> fetch() async {
    final raw = await (bundle ?? rootBundle).loadString(path);
    final decoded = jsonDecode(raw);
    return decoded is Map<String, Object?> ? decoded : null;
  }
}

/// Builds [AppConfig] from defaults plus each source in order. A failing
/// source (offline, malformed JSON, ...) is skipped, never fatal.
///
/// To add remote config later, implement [ConfigSource] (e.g. with Firebase
/// Remote Config) and append it after the asset source.
class ConfigService {
  const ConfigService(this.sources);

  final List<ConfigSource> sources;

  Future<AppConfig> load({AppConfig? defaults}) async {
    var config = defaults ?? AppConfig.defaults();
    for (final source in sources) {
      try {
        final json = await source.fetch().timeout(const Duration(seconds: 5));
        if (json != null) config = config.applyJson(json);
      } catch (e) {
        AppLogger.warn('Config source ${source.runtimeType} failed', e);
      }
    }
    return config;
  }
}
