import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../analytics/analytics_service.dart';
import '../../audio/audio_service.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/cancellable_delay.dart';
import '../../models/animal.dart';
import '../../models/slideshow_speed.dart';
import '../../repositories/animal_repository.dart';

enum SlideShowState { stopped, playing, paused }

/// Business logic of the learning screen: current animal, manual navigation,
/// playback and the automatic slide show. Knows nothing about widgets.
///
/// Owned by the screen and disposed with it, which cancels every timer and
/// pending audio sequence.
class LearningController extends ChangeNotifier {
  LearningController({
    required AnimalRepository repository,
    required AudioService audio,
    required String Function() languageCode,
    required SlideShowSpeed Function() slideShowSpeed,
    AnalyticsService? analytics,
    this.transitionPause = AppConstants.pageTransition,
  }) : _repository = repository,
       _audio = audio,
       _languageCode = languageCode,
       _speed = slideShowSpeed,
       _analytics = analytics,
       _animals = repository.getAnimals();

  final AnimalRepository _repository;
  final AudioService _audio;
  final String Function() _languageCode;
  final SlideShowSpeed Function() _speed;
  final AnalyticsService? _analytics;

  /// Time given to the page transition before the next animal is spoken.
  final Duration transitionPause;

  final List<Animal> _animals;
  int _index = 0;
  SlideShowState _slideShow = SlideShowState.stopped;
  int _run = 0;
  CancellableDelay? _delay;
  bool _disposed = false;

  List<Animal> get animals => _animals;
  int get currentIndex => _index;
  Animal get current => _animals[_index];
  SlideShowState get slideShowState => _slideShow;
  bool get isSlideShowPlaying => _slideShow == SlideShowState.playing;
  bool get isDisposed => _disposed;

  // --- Manual navigation -----------------------------------------------------

  void next() => _goTo(_repository.indexOf(_repository.getNextAnimal(current)));

  void previous() =>
      _goTo(_repository.indexOf(_repository.getPreviousAnimal(current)));

  /// Called when the user swipes to another page.
  void onPageChanged(int index) {
    if (index == _index) return;
    _goTo(index);
  }

  void _goTo(int index) {
    if (_disposed || index < 0 || index >= _animals.length) return;
    _setIndex(index);
    if (isSlideShowPlaying) {
      _restartSlideShow();
    } else {
      unawaited(_audio.stop());
    }
  }

  void _setIndex(int index) {
    if (index == _index) return;
    _index = index;
    unawaited(
      _analytics?.log(AnalyticsEvents.animalViewed, {'animal': current.id}),
    );
    notifyListeners();
  }

  // --- Playback --------------------------------------------------------------

  /// Name, short delay, then sound of the current animal.
  Future<void> playCurrent() async {
    if (_disposed) return;
    if (isSlideShowPlaying) {
      _restartSlideShow();
      return;
    }
    if (_slideShow == SlideShowState.paused) {
      _setSlideShow(SlideShowState.stopped);
    }
    await _audio.playAnimal(current, languageCode: _languageCode());
  }

  // --- Slide show ------------------------------------------------------------

  void startSlideShow() {
    if (_disposed || isSlideShowPlaying) return;
    unawaited(_analytics?.log(AnalyticsEvents.slideShowStarted));
    _setSlideShow(SlideShowState.playing);
    _restartSlideShow();
  }

  void pauseSlideShow() {
    if (!isSlideShowPlaying) return;
    _cancelRun();
    _setSlideShow(SlideShowState.paused);
  }

  void resumeSlideShow() {
    if (_disposed || _slideShow != SlideShowState.paused) return;
    _setSlideShow(SlideShowState.playing);
    _restartSlideShow();
  }

  void stopSlideShow() {
    if (_slideShow == SlideShowState.stopped) return;
    _cancelRun();
    _setSlideShow(SlideShowState.stopped);
  }

  void toggleSlideShow() => switch (_slideShow) {
    SlideShowState.stopped => startSlideShow(),
    SlideShowState.playing => pauseSlideShow(),
    SlideShowState.paused => resumeSlideShow(),
  };

  /// App went to background: pause everything.
  void onAppBackground() {
    if (isSlideShowPlaying) {
      pauseSlideShow();
    } else {
      unawaited(_audio.stop());
    }
  }

  void _restartSlideShow() {
    _cancelRun();
    final run = _run;
    unawaited(_slideShowLoop(run));
  }

  Future<void> _slideShowLoop(int run) async {
    bool alive() => !_disposed && run == _run && isSlideShowPlaying;
    while (alive()) {
      await _audio.playAnimal(current, languageCode: _languageCode());
      if (!alive()) return;
      if (!await _sleep(_speed().pauseAfterAnimal) || !alive()) return;
      _setIndex(_repository.indexOf(_repository.getNextAnimal(current)));
      if (!await _sleep(transitionPause) || !alive()) return;
    }
  }

  Future<bool> _sleep(Duration duration) {
    final delay = CancellableDelay(duration);
    _delay = delay;
    return delay.future;
  }

  void _cancelRun() {
    _run++;
    _delay?.cancel();
    _delay = null;
    unawaited(_audio.stop());
  }

  void _setSlideShow(SlideShowState state) {
    if (_slideShow == state) return;
    _slideShow = state;
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _run++;
    _delay?.cancel();
    _delay = null;
    _slideShow = SlideShowState.stopped;
    unawaited(_audio.stop());
    super.dispose();
  }
}
