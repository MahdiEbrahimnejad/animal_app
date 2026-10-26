import 'package:animal_app/models/slideshow_speed.dart';
import 'package:animal_app/settings/key_value_store.dart';
import 'package:animal_app/settings/settings_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('settings persist across instances', () async {
    final store = InMemoryStore();
    final a = SettingsService(store);
    await a.setLanguage('en');
    await a.setSlideShowSpeed(SlideShowSpeed.slow);
    await a.setVolume(0.4);
    await a.setMusicEnabled(true);
    await a.setNameSoundDelay(const Duration(milliseconds: 900));

    final b = SettingsService(store).settings;
    expect(b.languageCode, 'en');
    expect(b.slideShowSpeed, SlideShowSpeed.slow);
    expect(b.volume, 0.4);
    expect(b.musicEnabled, isTrue);
    expect(b.nameSoundDelay, const Duration(milliseconds: 900));
  });

  test('unsupported language is ignored', () async {
    final s = SettingsService(InMemoryStore());
    await s.setLanguage('xx');
    expect(s.settings.languageCode, isNull);
  });

  test('corrupt values fall back to defaults', () async {
    final store = InMemoryStore();
    await store.setString('settings.slideShowSpeed', 'warp');
    await store.setDouble('settings.volume', 7);
    final s = SettingsService(store).settings;
    expect(s.slideShowSpeed, SlideShowSpeed.normal);
    expect(s.volume, 1.0);
  });
}
