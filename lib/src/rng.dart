import 'dart:math' as math;

import 'rect.dart';
import 'vec.dart';

/// A singleton instance of Rng globally available.
final Rng rng = Rng(DateTime.now().millisecondsSinceEpoch);

/// The Random Number God: deliverer of good and ill fortune alike.
class Rng {
  math.Random _random;

  Rng(int seed) : _random = math.Random(seed);

  /// Resets the random number generator's internal state to [seed].
  void setSeed(int seed) {
    _random = math.Random(seed);
  }

  /// Gets a random int within a given range. If [max] is given, then it is
  /// in the range `[minOrMax, max)`. Otherwise, it is `[0, minOrMax)`. In
  /// other words, `range(3)` returns a `0`, `1`, or `2`, and `range(2, 5)`
  /// returns `2`, `3`, or `4`.
  int range(int minOrMax, [int? max]) {
    if (max == null) {
      max = minOrMax;
      minOrMax = 0;
    }

    return _random.nextInt(max - minOrMax) + minOrMax;
  }

  /// Gets a random int within a given range. If [max] is given, then it is
  /// in the range `[minOrMax, max]`. Otherwise, it is `[0, minOrMax]`. In
  /// other words, `inclusive(2)` returns a `0`, `1`, or `2`, and
  /// `inclusive(2, 4)` returns `2`, `3`, or `4`.
  int inclusive(int minOrMax, [int? max]) {
    if (max == null) {
      max = minOrMax;
      minOrMax = 0;
    }

    max++;
    return _random.nextInt(max - minOrMax) + minOrMax;
  }

  /// Gets a random floating-point value within the given range.
  double float([double? minOrMax, double? max]) {
    if (minOrMax == null) {
      return _random.nextDouble();
    } else if (max == null) {
      return _random.nextDouble() * minOrMax;
    } else {
      return _random.nextDouble() * (max - minOrMax) + minOrMax;
    }
  }

  /// Gets a random integer count within the given floating point [range].
  ///
  /// The decimal portion of the range is treated as a fractional chance of
  /// returning the next higher integer value. For example:
  ///
  ///     countFromFloat(10.2);
  ///
  /// This has an 80% chance of returning 10 and a 20% chance of returning 11.
  ///
  /// This is particularly useful when the range is less than one, because it
  /// gives you some chance of still producing one instead of always rounding
  /// down to zero.
  int countFromFloat(double range) {
    var count = range.floor();
    if (rng.float(1.0) < range - count) count++;
    return count;
  }

  /// Calculate a random number with a normal distribution.
  ///
  /// Note that this means results may be less than -1.0 or greater than 1.0.
  ///
  /// Uses https://en.wikipedia.org/wiki/Marsaglia_polar_method.
  double normal() {
    double u, v, lengthSquared;

    do {
      u = rng.float(-1.0, 1.0);
      v = rng.float(-1.0, 1.0);
      lengthSquared = u * u + v * v;
    } while (lengthSquared >= 1.0);

    return u * math.sqrt(-2.0 * math.log(lengthSquared) / lengthSquared);
  }

  /// Returns `true` if a random int chosen between 1 and chance was 1.
  bool oneIn(int chance) => range(chance) == 0;

  /// Returns `true` [chance] percent of the time.
  bool percent(int chance) => range(100) < chance;

  /// Rounds [value] to a nearby integer, randomly rounding up or down based
  /// on the fractional value.
  ///
  /// For example, `round(3.2)` has a 20% chance of returning 3, and an 80%
  /// chance of returning 4.
  int round(double value) {
    var result = value.floor();
    if (float(1.0) < value - result) result++;
    return result;
  }

  /// Gets a random item from the given list.
  T item<T>(List<T> items) => items[range(items.length)];

  /// Removes a random item from the given list.
  ///
  /// This may not preserve the order of items in the list, but is faster than
  /// [takeOrdered].
  T take<T>(List<T> items) {
    var index = rng.range(items.length);
    var result = items[index];

    // Replace the removed item with the last item in the list and then discard
    // the last.
    items[index] = items.last;
    items.removeLast();

    return result;
  }

  /// Removes a random item from the given list, preserving the order of the
  /// remaining items.
  ///
  /// This is O(n) because it must shift forward items after the removed one.
  /// If you don't need to preserve order, use [take].
  T takeOrdered<T>(List<T> items) => items.removeAt(range(items.length));

  /// Randomly re-orders elements in [items].
  void shuffle<T>(List<T> items) {
    items.shuffle(_random);
  }

  /// Gets a random [Vec] within the given [Rect] (half-inclusive).
  Vec vecInRect(Rect rect) {
    return Vec(range(rect.left, rect.right), range(rect.top, rect.bottom));
  }

  /// Gets a random number centered around [center] with [range] (inclusive)
  /// using a triangular distribution. For example `triangleInt(8, 4)` will
  /// return values between 4 and 12 (inclusive) with greater distribution
  /// towards 8.
  ///
  /// This means output values will range from `(center - range)` to
  /// `(center + range)` inclusive, with most values near the center, but not
  /// with a normal distribution. Think of it as a poor man's bell curve.
  ///
  /// The algorithm works essentially by choosing a random point inside the
  /// triangle, and then calculating the x coordinate of that point. It works
  /// like this:
  ///
  /// Consider Center 4, Range 3:
  ///
  ///             *
  ///           * | *
  ///         * | | | *
  ///       * | | | | | *
  ///     --+-----+-----+--
  ///     0 1 2 3 4 5 6 7 8
  ///      -r     c     r
  ///
  /// Now flip the left half of the triangle (from 1 to 3) vertically and move
  /// it over to the right so that we have a square.
  ///
  ///         .-------.
  ///         |       V
  ///         |
  ///         |   R L L L
  ///         | . R R L L
  ///         . . R R R L
  ///       . . . R R R R
  ///     --+-----+-----+--
  ///     0 1 2 3 4 5 6 7 8
  ///
  /// Choose a point in that square. Figure out which half of the triangle the
  /// point is in, and then remap the point back out to the original triangle.
  /// The result is the *x* coordinate of the point in the original triangle.
  int triangleInt(int center, int range) {
    if (range < 0) {
      throw ArgumentError("The argument \"range\" must be zero or greater.");
    }

    // Pick a point in the square.
    int x = inclusive(range);
    int y = inclusive(range);

    // Figure out which triangle we are in.
    if (x <= y) {
      // Larger triangle.
      return center + x;
    } else {
      // Smaller triangle.
      return center - range - 1 + x;
    }
  }

  int taper(int start, int chanceOfIncrement) {
    while (oneIn(chanceOfIncrement)) start++;
    return start;
  }
}
