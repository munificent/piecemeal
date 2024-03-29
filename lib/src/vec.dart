import 'dart:math' as math;

import 'direction.dart';

/// Shared functionality between [Vec] and [Direction].
mixin VecMixin {
  int get x;
  int get y;

  /// Gets the area of a [Rect] whose corners are (0, 0) and this Vec.
  ///
  /// Returns a negative area if one of the Vec's coordinates are negative.
  int get area => x * y;

  /// Gets the rook length of the Vec, which is the number of squares a rook on
  /// a chessboard would need to move from (0, 0) to reach the endpoint of the
  /// Vec. Also known as Manhattan or taxicab distance.
  int get rookLength => x.abs() + y.abs();

  /// Gets the king length of the Vec, which is the number of squares a king on
  /// a chessboard would need to move from (0, 0) to reach the endpoint of the
  /// Vec. Also known as Chebyshev distance.
  int get kingLength => math.max(x.abs(), y.abs());

  int get lengthSquared => x * x + y * y;

  /// The Cartesian length of the vector.
  ///
  /// If you just need to compare the magnitude of two vectors, prefer using
  /// the comparison operators or [lengthSquared], both of which are faster
  /// than this.
  num get length => math.sqrt(lengthSquared);

  /// The [Direction] that most closely approximates the angle of this Vec.
  ///
  /// In cases where two directions are equally close, chooses the one that is
  /// clockwise from this Vec's angle.
  ///
  /// In other words, it figures out which octant the vector's angle lies in
  /// (the dotted lines) and chooses the corresponding direction:
  ///
  ///               n
  ///      nw   2.0  -2.0  ne
  ///         \  '  |  '  /
  ///          \    |    /
  ///      0.5  \ ' | ' /   -0.5
  ///         '  \  |  /  '
  ///           ' \'|'/ '
  ///             '\|/'
  ///       w ------0------ e
  ///             '/|\'
  ///           ' /'|'\ '
  ///         '  /  |  \  '
  ///     -0.5  / ' | ' \   0.5
  ///          /    |    \
  ///         /  '  |  '  \
  ///       sw -2.0   2.0  se
  ///               s
  Direction get nearestDirection => switch ((x, y)) {
        (< 0, _) when y / x >= 2.0 => Direction.n,
        (< 0, _) when y / x >= 0.5 => Direction.nw,
        (< 0, _) when y / x >= -0.5 => Direction.w,
        (< 0, _) when y / x >= -2.0 => Direction.sw,
        (< 0, _) => Direction.s,
        (> 0, _) when y / x >= 2.0 => Direction.s,
        (> 0, _) when y / x >= 0.5 => Direction.se,
        (> 0, _) when y / x >= -0.5 => Direction.e,
        (> 0, _) when y / x >= -2.0 => Direction.ne,
        (> 0, _) => Direction.n,
        (_, < 0) => Direction.n,
        (_, > 0) => Direction.s,
        (_, _) => Direction.none,
      };

  /// The eight Vecs surrounding this one to the north, south, east, and west
  /// and points in between.
  List<Vec> get neighbors =>
      [for (var direction in Direction.all) this + direction];

  /// The four Vecs surrounding this one to the north, south, east, and west.
  List<Vec> get cardinalNeighbors =>
      [for (var direction in Direction.cardinal) this + direction];

  /// The four Vecs surrounding this one to the northeast, southeast, southwest,
  /// and northwest.
  List<Vec> get intercardinalNeighbors =>
      [for (var direction in Direction.intercardinal) this + direction];

  /// Scales this Vec by [other].
  Vec operator *(int other) => Vec(x * other, y * other);

  /// Scales this Vec by [other].
  Vec operator ~/(int other) => Vec(x ~/ other, y ~/ other);

  /// Adds [other] to this Vec.
  ///
  ///  *  If [other] is a [Vec] or [Direction], adds each pair of coordinates.
  ///  *  If [other] is an [int], adds that value to both coordinates.
  ///
  /// Any other type is an error.
  Vec operator +(Object other) => switch (other) {
        Vec _ => Vec(x + other.x, y + other.y),
        int _ => Vec(x + other, y + other),
        _ => throw ArgumentError("Operand must be an int or Vec.")
      };

  /// Substracts [other] from this Vec.
  ///
  ///  *  If [other] is a [Vec] or [Direction], subtracts each pair of
  ///     coordinates.
  ///  *  If [other] is an [int], subtracts that value from both coordinates.
  ///
  /// Any other type is an error.
  Vec operator -(Object other) => switch (other) {
        Vec _ => Vec(x - other.x, y - other.y),
        int _ => Vec(x - other, y - other),
        _ => throw ArgumentError("Operand must be an int or Vec.")
      };

  /// Returns `true` if the magnitude of this vector is greater than [other].
  bool operator >(Object other) => switch (other) {
        Vec _ => lengthSquared > other.lengthSquared,
        num _ => lengthSquared > other * other,
        _ => throw ArgumentError("Operand must be a number or Vec.")
      };

  /// Returns `true` if the magnitude of this vector is greater than or equal
  /// to [other].
  bool operator >=(Object other) => switch (other) {
        Vec _ => lengthSquared >= other.lengthSquared,
        num _ => lengthSquared >= other * other,
        _ => throw ArgumentError("Operand must be a number or Vec.")
      };

  /// Returns `true` if the magnitude of this vector is less than [other].
  bool operator <(Object other) => switch (other) {
        Vec _ => lengthSquared < other.lengthSquared,
        num _ => lengthSquared < other * other,
        _ => throw ArgumentError("Operand must be a number or Vec.")
      };

  /// Returns `true` if the magnitude of this vector is less than or equal to
  /// [other].
  bool operator <=(Object other) => switch (other) {
        Vec _ => lengthSquared <= other.lengthSquared,
        num _ => lengthSquared <= other * other,
        _ => throw ArgumentError("Operand must be a number or Vec.")
      };

  /// Returns `true` if [pos] is within a rectangle from (0,0) to this vector
  /// (half-inclusive).
  bool contains(Vec pos) {
    var left = math.min(0, x);
    if (pos.x < left) return false;

    var right = math.max(0, x);
    if (pos.x >= right) return false;

    var top = math.min(0, y);
    if (pos.y < top) return false;

    var bottom = math.max(0, y);
    if (pos.y >= bottom) return false;

    return true;
  }

  /// Returns a new [Vec] with the absolute value of the coordinates of this
  /// one.
  Vec abs() => Vec(x.abs(), y.abs());

  /// Returns a new [Vec] whose coordinates are this one's translated by [x] and
  /// [y].
  Vec offset(int x, int y) => Vec(this.x + x, this.y + y);

  /// Returns a new [Vec] whose coordinates are this one's but with the X
  /// coordinate translated by [x].
  Vec offsetX(int x) => Vec(this.x + x, y);

  /// Returns a new [Vec] whose coordinates are this one's but with the Y
  /// coordinate translated by [y].
  Vec offsetY(int y) => Vec(x, this.y + y);

  @override
  String toString() => '$x, $y';
}

/// A two-dimensional point with integer coordinates.
class Vec with VecMixin {
  final int x;
  final int y;

  static const zero = Vec(0, 0);

  const Vec(this.x, this.y);

  @override
  bool operator ==(Object other) {
    if (other is! Vec) return false;
    return x == other.x && y == other.y;
  }

  @override
  int get hashCode {
    // Map negative coordinates to positive and spread out the positive ones to
    // make room for them.
    var a = x >= 0 ? 2 * x : -2 * x - 1;
    var b = y >= 0 ? 2 * y : -2 * y - 1;

    // Cantor pairing function.
    // https://en.wikipedia.org/wiki/Pairing_function
    return (a + b) * (a + b + 1) ~/ 2 + b;
  }
}
