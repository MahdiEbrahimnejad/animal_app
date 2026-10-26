/// Slide show speed chosen in the Parent Area.
enum SlideShowSpeed {
  slow(Duration(seconds: 4)),
  normal(Duration(milliseconds: 2500)),
  fast(Duration(milliseconds: 1200));

  const SlideShowSpeed(this.pauseAfterAnimal);

  /// Pause after an animal's name and sound finished, before the next one.
  final Duration pauseAfterAnimal;

  static SlideShowSpeed fromName(String? name) => SlideShowSpeed.values
      .firstWhere((s) => s.name == name, orElse: () => SlideShowSpeed.normal);
}
