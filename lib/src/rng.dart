library piecemeal.src.rng;

import 'dart:math' as math;

import 'rect.dart';
import 'vec.dart';

/// A singleton instance of Rng globally available.
final rng = new Rng(new DateTime.now().millisecondsSinceEpoch);

/// The Random Number God: deliverer of good and ill fortune alike.
class Rng {
  final math.Random _random;

  Rng(int seed)
      : _random = new math.Random(seed);

  /// Gets a random int within a given range. If [max] is given, then it is
  /// in the range `[minOrMax, max)`. Otherwise, it is `[0, minOrMax)`. In
  /// other words, `range(3)` returns a `0`, `1`, or `2`, and `range(2, 5)`
  /// returns `2`, `3`, or `4`.
  int range(int minOrMax, [int max]) {
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
  int inclusive(int minOrMax, [int max]) {
    if (max == null) {
      max = minOrMax;
      minOrMax = 0;
    }

    max++;
    return _random.nextInt(max - minOrMax) + minOrMax;
  }

  /// Returns `true` if a random int chosen between 1 and chance was 1.
  bool oneIn(int chance) => range(chance) == 0;

  /// Gets a random item from the given list.
  item(List items) => items[range(items.length)];

  /// Removes a random item from the given list.
  take(List items) {
    final index = range(items.length);
    final item = items[index];
    items.removeRange(index, 1);
    return item;
  }

  /// Gets a random [Vec] within the given [Rect] (half-inclusive).
  Vec vecInRect(Rect rect) {
    return new Vec(range(rect.left, rect.right), range(rect.top, rect.bottom));
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
  ///         +-------+
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
    if (range < 0) throw new ArgumentError(
        "The argument \"range\" must be zero or greater.");

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