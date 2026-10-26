import 'package:animal_app/audio/audio_service.dart';
import 'package:animal_app/core/utils/asset_catalog.dart';
import 'package:animal_app/data/animal_data.dart';
import 'package:animal_app/features/learning/learning_controller.dart';
import 'package:animal_app/models/slideshow_speed.dart';
import 'package:animal_app/repositories/animal_repository.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fakes.dart';

void main() {
  late FakeAudioBackend clips;

  LearningController build() {
    final assets = StaticAssetCatalog({
      for (final a in animalData) ...[a.audioNameEn, a.animalSound],
    });
    clips = FakeAudioBackend(clipDuration: const Duration(milliseconds: 500));
    return LearningController(
      repository: LocalAnimalRepository(animalData),
      audio: AudioService(
        clips: clips,
        assets: assets,
        nameSoundDelay: const Duration(milliseconds: 500),
      ),
      languageCode: () => 'en',
      slideShowSpeed: () => SlideShowSpeed.fast,
      transitionPause: const Duration(milliseconds: 300),
    );
  }

  // One slide-show step: name 0.5 + delay 0.5 + sound 0.5 + fast pause 1.2
  // + transition 0.3 = 3.0 seconds.
  const step = Duration(seconds: 3);

  test('next / previous wrap around', () {
    final c = build();
    expect(c.current.id, 'dog');
    c.previous();
    expect(c.current.id, 'octopus');
    c.next();
    c.next();
    expect(c.current.id, 'cat');
    c.dispose();
  });

  test('swipe updates the current animal', () {
    final c = build();
    c.onPageChanged(4);
    expect(c.current.id, 'sheep');
    c.dispose();
  });

  test('slide show advances and plays each animal', () {
    fakeAsync((async) {
      final c = build();
      c.startSlideShow();
      expect(c.slideShowState, SlideShowState.playing);
      async.elapse(step + const Duration(milliseconds: 50));
      expect(c.current.id, 'cat');
      async.elapse(step);
      expect(c.current.id, 'rabbit');
      expect(clips.played.take(2), [
        'assets/audio/en/dog_name_en.mp3',
        'assets/audio/animals/dog_sound.mp3',
      ]);
      c.dispose();
    });
  });

  test('slide show loops back to the first animal', () {
    fakeAsync((async) {
      final c = build();
      c.onPageChanged(29);
      c.startSlideShow();
      async.elapse(step + const Duration(milliseconds: 50));
      expect(c.current.id, 'dog');
      c.dispose();
    });
  });

  test('pause, resume and stop', () {
    fakeAsync((async) {
      final c = build();
      c.startSlideShow();
      async.elapse(const Duration(seconds: 1));
      c.pauseSlideShow();
      expect(c.slideShowState, SlideShowState.paused);
      async.elapse(const Duration(seconds: 30));
      expect(c.current.id, 'dog');

      c.resumeSlideShow();
      expect(c.slideShowState, SlideShowState.playing);
      async.elapse(step + const Duration(milliseconds: 50));
      expect(c.current.id, 'cat');

      c.stopSlideShow();
      expect(c.slideShowState, SlideShowState.stopped);
      async.elapse(const Duration(seconds: 30));
      expect(c.current.id, 'cat');
      c.dispose();
    });
  });

  test('going to background pauses the slide show', () {
    fakeAsync((async) {
      final c = build();
      c.startSlideShow();
      async.elapse(const Duration(seconds: 1));
      c.onAppBackground();
      expect(c.slideShowState, SlideShowState.paused);
      async.elapse(const Duration(seconds: 30));
      expect(c.current.id, 'dog');
      c.dispose();
    });
  });

  test('slide show does not continue after dispose', () {
    fakeAsync((async) {
      final c = build();
      c.startSlideShow();
      async.elapse(const Duration(seconds: 1));
      final playedBefore = clips.played.length;
      c.dispose();
      async.elapse(const Duration(minutes: 1));
      expect(clips.played.length, playedBefore);
      expect(c.current.id, 'dog');
      expect(async.pendingTimers, isEmpty);
    });
  });
}
