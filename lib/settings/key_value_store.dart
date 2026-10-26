import 'package:shared_preferences/shared_preferences.dart';

/// Small persistence abstraction so services don't depend on a storage SDK.
abstract interface class KeyValueStore {
  String? getString(String key);
  bool? getBool(String key);
  double? getDouble(String key);
  int? getInt(String key);
  Future<void> setString(String key, String value);
  Future<void> setBool(String key, bool value);
  Future<void> setDouble(String key, double value);
  Future<void> setInt(String key, int value);
}

class SharedPreferencesStore implements KeyValueStore {
  SharedPreferencesStore._(this._prefs);

  final SharedPreferencesWithCache _prefs;

  static Future<SharedPreferencesStore> create() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
    return SharedPreferencesStore._(prefs);
  }

  @override
  String? getString(String key) => _prefs.getString(key);
  @override
  bool? getBool(String key) => _prefs.getBool(key);
  @override
  double? getDouble(String key) => _prefs.getDouble(key);
  @override
  int? getInt(String key) => _prefs.getInt(key);
  @override
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);
  @override
  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);
  @override
  Future<void> setDouble(String key, double value) =>
      _prefs.setDouble(key, value);
  @override
  Future<void> setInt(String key, int value) => _prefs.setInt(key, value);
}

/// Volatile store used as a fallback if the platform store fails, and in tests.
class InMemoryStore implements KeyValueStore {
  final Map<String, Object> _values = {};

  @override
  String? getString(String key) => _values[key] as String?;
  @override
  bool? getBool(String key) => _values[key] as bool?;
  @override
  double? getDouble(String key) => _values[key] as double?;
  @override
  int? getInt(String key) => _values[key] as int?;
  @override
  Future<void> setString(String key, String value) async =>
      _values[key] = value;
  @override
  Future<void> setBool(String key, bool value) async => _values[key] = value;
  @override
  Future<void> setDouble(String key, double value) async =>
      _values[key] = value;
  @override
  Future<void> setInt(String key, int value) async => _values[key] = value;
}
