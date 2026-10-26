import 'package:flutter/foundation.dart';

import 'animal_category.dart';

/// A single learnable animal.
///
/// Asset paths are derived from [id] by convention so that adding an animal
/// only needs one record in `data/animal_data.dart` plus its asset files:
///
/// * image:      `assets/images/animals/<id>.webp`
/// * name audio: `assets/audio/<lang>/<id>_name_<lang>.mp3`
/// * sound:      `assets/audio/animals/<id>_sound.mp3`
@immutable
class Animal {
  const Animal({
    required this.id,
    required this.category,
    required this.names,
    this.soundWords = const {},
    this.emoji = '',
    this.isPremium = false,
  });

  final String id;
  final AnimalCategory category;

  /// Display name per language code, e.g. `{'fa': 'سگ', 'en': 'Dog'}`.
  final Map<String, String> names;

  /// Optional spoken sound word per language (e.g. "Woof woof"). Used only as
  /// a text-to-speech fallback when the real animal sound file is missing.
  final Map<String, String> soundWords;

  /// Shown by the image placeholder until a real picture is added.
  final String emoji;

  /// Reserved for future premium content packs.
  final bool isPremium;

  static const String fallbackLanguage = 'en';

  String nameFor(String languageCode) =>
      names[languageCode] ?? names[fallbackLanguage] ?? id;

  String? soundWordFor(String languageCode) => soundWords[languageCode];

  String get nameFa => nameFor('fa');
  String get nameEn => nameFor('en');

  String get imageAsset => 'assets/images/animals/$id.webp';

  String audioNameAsset(String languageCode) =>
      'assets/audio/$languageCode/${id}_name_$languageCode.mp3';

  String get audioNameFa => audioNameAsset('fa');
  String get audioNameEn => audioNameAsset('en');

  String get animalSound => 'assets/audio/animals/${id}_sound.mp3';

  @override
  bool operator ==(Object other) => other is Animal && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Animal($id)';
}
