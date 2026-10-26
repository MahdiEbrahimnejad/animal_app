import 'package:animal_app/audio/audio_service.dart';
import 'package:animal_app/core/utils/asset_catalog.dart';
import 'package:animal_app/data/animal_data.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fakes.dart';

void main() {
  final dog = animalData.first;
  final allDogAssets = StaticAssetCatalog({
    dog.audioNameFa,
    dog.audioNameEn,
    dog.animalSound,
  });

  test('plays name, waits, then sound in the selected language', () {
    fakeAsync((async) {
      final clips = FakeAudioBackend();
      final audio = AudioService(clips: clips, assets: allDogAssets);
      audio.playAnimal(
        dog,
        languageCode: 'fa',
        delay: const Duration(seconds: 1),
      );
      async.flushMicrotasks();
      expect(clips.played, [dog.audioNameFa]);
      async.elapse(const Duration(milliseconds: 1400)); // clip + part of delay
      expect(clips.played, [dog.audioNameFa]);
      async.elapse(const Duration(milliseconds: 200));
      expect(clips.played, [dog.audioNameFa, dog.animalSound]);
    });
  });

  test('English uses the English name file', () {
    fakeAsync((async) {
      final clips = FakeAudioBackend();
      AudioService(
        clips: clips,
        assets: allDogAssets,
      ).playAnimalName(dog, languageCode: 'en');
      async.flushMicrotasks();
      expect(clips.played, [dog.audioNameEn]);
    });
  });

  test('missing audio files do not crash and fall back to speech', () async {
    final clips = FakeAudioBackend();
    final speech = FakeSpeechBackend();
    final audio = AudioService(
      clips: clips,
      speech: speech,
      assets: const StaticAssetCatalog({}),
      nameSoundDelay: Duration.zero,
    );
    await audio.playAnimal(dog, languageCode: 'fa');
    expect(clips.played, isEmpty);
    expect(speech.spoken, ['fa:سگ', 'fa:هاپ هاپ']);
  });

  test('missing audio without speech completes silently', () async {
    final audio = AudioService(
      clips: FakeAudioBackend(),
      assets: const StaticAssetCatalog({}),
      nameSoundDelay: Duration.zero,
    );
    await expectLater(audio.playAnimal(dog, languageCode: 'en'), completes);
  });

  test('playback errors are swallowed', () async {
    final audio = AudioService(
      clips: FakeAudioBackend(throwOnPlay: true),
      assets: allDogAssets,
      nameSoundDelay: Duration.zero,
    );
    await expectLater(audio.playAnimal(dog, languageCode: 'en'), completes);
  });

  test('a new animal interrupts the previous sequence', () {
    fakeAsync((async) {
      final cat = animalData[1];
      final clips = FakeAudioBackend();
      final audio = AudioService(
        clips: clips,
        assets: StaticAssetCatalog({
          ...allDogAssets.assets,
          cat.audioNameEn,
          cat.animalSound,
        }),
      );
      audio.playAnimal(dog, languageCode: 'en');
      async.flushMicrotasks();
      audio.playAnimal(cat, languageCode: 'en');
      async.elapse(const Duration(seconds: 5));
      expect(clips.played, [dog.audioNameEn, cat.audioNameEn, cat.animalSound]);
    });
  });

  test('stop cancels the pending animal sound', () {
    fakeAsync((async) {
      final clips = FakeAudioBackend();
      final audio = AudioService(clips: clips, assets: allDogAssets);
      audio.playAnimal(dog, languageCode: 'en');
      async.elapse(const Duration(milliseconds: 600));
      audio.stop();
      async.elapse(const Duration(seconds: 5));
      expect(clips.played, [dog.audioNameEn]);
    });
  });

  test('pause holds the sequence until resume', () {
    fakeAsync((async) {
      final clips = FakeAudioBackend();
      final audio = AudioService(clips: clips, assets: allDogAssets);
      audio.playAnimal(dog, languageCode: 'en');
      async.elapse(const Duration(milliseconds: 600));
      audio.pause();
      async.elapse(const Duration(seconds: 5));
      expect(clips.played, [dog.audioNameEn]);
      audio.resume();
      async.flushMicrotasks();
      expect(clips.played, [dog.audioNameEn, dog.animalSound]);
    });
  });

  test('dispose releases the backend', () async {
    final clips = FakeAudioBackend();
    final audio = AudioService(clips: clips, assets: allDogAssets);
    await audio.dispose();
    expect(clips.disposed, isTrue);
  });
}
