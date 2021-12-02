import 'dart:async';

class Ticker {
  Stream<int> tickIncrement({
    required Duration interval,
    required int initialValue,
    required int maxValue,
  }) {
    return Stream.periodic(
      interval,
      (x) => initialValue + 1 + x,
    ).takeWhile(
      (value) => value <= maxValue,
    );
  }

  Stream<int> tickDecrement({
    required Duration interval,
    required int initialValue,
    required int minValue,
  }) {
    return Stream.periodic(
      interval,
      (x) => initialValue - 1 - x,
    ).takeWhile(
      (value) => value >= minValue,
    );
  }
}
