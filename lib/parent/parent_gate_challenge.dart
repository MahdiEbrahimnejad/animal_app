import 'dart:math';

/// A question small children cannot answer: multiplication shown as text
/// (toddlers can't read) with a typed, usually two-digit answer, so random
/// tapping has roughly a 1% chance of passing.
class ParentGateChallenge {
  ParentGateChallenge._(this.a, this.b);

  factory ParentGateChallenge.random([Random? random]) {
    final r = random ?? Random();
    return ParentGateChallenge._(3 + r.nextInt(7), 3 + r.nextInt(7));
  }

  /// For tests.
  factory ParentGateChallenge.fixed(int a, int b) =>
      ParentGateChallenge._(a, b);

  final int a;
  final int b;

  int get answer => a * b;

  bool check(String input) => int.tryParse(input) == answer;
}
