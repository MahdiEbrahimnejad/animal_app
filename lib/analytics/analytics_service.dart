import '../core/utils/app_logger.dart';

/// Adapter for a concrete analytics backend (e.g. Firebase). Must be
/// configured for child-directed use and must not collect personal data.
abstract interface class AnalyticsProvider {
  Future<void> logEvent(String name, Map<String, Object> parameters);
}

/// Default: collects nothing.
class NoopAnalyticsProvider implements AnalyticsProvider {
  const NoopAnalyticsProvider();

  @override
  Future<void> logEvent(String name, Map<String, Object> parameters) async {}
}

/// Prints events in debug builds only. Handy while developing.
class DebugAnalyticsProvider implements AnalyticsProvider {
  const DebugAnalyticsProvider();

  @override
  Future<void> logEvent(String name, Map<String, Object> parameters) async {
    AppLogger.info('analytics: $name $parameters');
  }
}

/// Optional, failure-proof analytics facade used by the app.
class AnalyticsService {
  AnalyticsService({
    AnalyticsProvider provider = const NoopAnalyticsProvider(),
    this.enabled = false,
  }) : _provider = provider;

  final AnalyticsProvider _provider;
  bool enabled;

  /// Only simple, non-personal values are allowed as parameters.
  Future<void> log(
    String name, [
    Map<String, Object> parameters = const {},
  ]) async {
    if (!enabled) return;
    try {
      await _provider.logEvent(name, parameters);
    } catch (e) {
      AppLogger.warn('Analytics failed (ignored)', e);
    }
  }
}

/// Event names in one place.
abstract final class AnalyticsEvents {
  static const animalViewed = 'animal_viewed';
  static const slideShowStarted = 'slide_show_started';
  static const premiumPurchased = 'premium_purchased';
}
