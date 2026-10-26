import 'package:animal_app/data/animal_data.dart';
import 'package:animal_app/models/animal_category.dart';
import 'package:animal_app/repositories/animal_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final repo = LocalAnimalRepository(animalData);

  test('contains the 30 version-one animals with unique ids', () {
    final animals = repo.getAnimals();
    expect(animals, hasLength(30));
    expect(animals.map((a) => a.id).toSet(), hasLength(30));
  });

  test('every animal has Persian and English names', () {
    for (final a in repo.getAnimals()) {
      expect(a.nameFa, isNotEmpty, reason: a.id);
      expect(a.nameEn, isNotEmpty, reason: a.id);
    }
  });

  test('getAnimalById', () {
    expect(repo.getAnimalById('dog')?.nameEn, 'Dog');
    expect(repo.getAnimalById('unicorn'), isNull);
  });

  test('next animal and wrap-around', () {
    final first = repo.getAnimals().first;
    final last = repo.getAnimals().last;
    expect(repo.getNextAnimal(first).id, 'cat');
    expect(repo.getNextAnimal(last), first);
  });

  test('previous animal and wrap-around', () {
    final first = repo.getAnimals().first;
    final last = repo.getAnimals().last;
    expect(repo.getPreviousAnimal(repo.getAnimalById('cat')!), first);
    expect(repo.getPreviousAnimal(first), last);
  });

  test('filters by category', () {
    final sea = repo.getAnimals(category: AnimalCategory.sea);
    expect(sea.map((a) => a.id), ['dolphin', 'whale', 'shark', 'octopus']);
  });

  test('asset paths follow the naming convention', () {
    final dog = repo.getAnimalById('dog')!;
    expect(dog.imageAsset, 'assets/images/animals/dog.webp');
    expect(dog.audioNameFa, 'assets/audio/fa/dog_name_fa.mp3');
    expect(dog.audioNameEn, 'assets/audio/en/dog_name_en.mp3');
    expect(dog.animalSound, 'assets/audio/animals/dog_sound.mp3');
  });

  test('unknown language falls back to English name', () {
    expect(repo.getAnimalById('cat')!.nameFor('de'), 'Cat');
  });
}
