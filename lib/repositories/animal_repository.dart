import '../models/animal.dart';
import '../models/animal_category.dart';

/// Read access to the animal catalogue. The UI never touches the raw list.
abstract interface class AnimalRepository {
  List<Animal> getAnimals({AnimalCategory? category});
  Animal? getAnimalById(String id);

  /// Next animal, wrapping around to the first one after the last.
  Animal getNextAnimal(Animal current);

  /// Previous animal, wrapping around to the last one before the first.
  Animal getPreviousAnimal(Animal current);

  int indexOf(Animal animal);
}

/// Repository backed by an in-memory list (the bundled `animalData`).
class LocalAnimalRepository implements AnimalRepository {
  LocalAnimalRepository(List<Animal> animals)
    : assert(animals.isNotEmpty, 'At least one animal is required'),
      _animals = List.unmodifiable(animals),
      _byId = {for (final a in animals) a.id: a} {
    assert(_byId.length == _animals.length, 'Animal ids must be unique');
  }

  final List<Animal> _animals;
  final Map<String, Animal> _byId;

  @override
  List<Animal> getAnimals({AnimalCategory? category}) => category == null
      ? _animals
      : List.unmodifiable(_animals.where((a) => a.category == category));

  @override
  Animal? getAnimalById(String id) => _byId[id];

  @override
  int indexOf(Animal animal) => _animals.indexOf(animal);

  @override
  Animal getNextAnimal(Animal current) {
    final index = indexOf(current);
    return _animals[(index + 1) % _animals.length];
  }

  @override
  Animal getPreviousAnimal(Animal current) {
    final index = indexOf(current);
    if (index < 0) return _animals.last;
    return _animals[(index - 1 + _animals.length) % _animals.length];
  }
}
