import 'dart:async';

/// A [Future.delayed] that can be cancelled. Cancelling completes the future
/// with `false` so awaiting code can bail out; finishing normally gives `true`.
class CancellableDelay {
  CancellableDelay(Duration duration) {
    _timer = Timer(duration, () {
      if (!_completer.isCompleted) _completer.complete(true);
    });
  }

  final Completer<bool> _completer = Completer<bool>();
  late final Timer _timer;

  Future<bool> get future => _completer.future;

  void cancel() {
    _timer.cancel();
    if (!_completer.isCompleted) _completer.complete(false);
  }
}
