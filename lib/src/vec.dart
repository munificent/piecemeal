library piecemeal.src.vec;

import 'dart:math' as math;

/// Shared base class of [Vec] and [Direction]. We do this instead of having
/// [Direction] inherit directly from [Vec] so that we can avoid it inheriting
/// an `==` operator, which would prevent it from being used in `switch`
/// statements. Instead, [Direction] uses identity equality.
class VecBase {
  final int x;
  final int y;

  const VecBase(this.x, this.y);

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

  /// Scales this Vec by [other].
  Vec operator *(int other) => new Vec(x * other, y * other);

  /// Scales this Vec by [other].
  Vec operator ~/(int other) => new Vec(x ~/ other, y ~/ other);

  /// Adds [other] to this Vec.
  ///
  ///  *  If [other] is a [Vec] or [Direction], adds each pair of coordinates.
  ///  *  If [other] is an [int], adds that value to both coordinates.
  ///
  /// Any other type is an error.
  Vec operator +(other) {
    if (other is VecBase) {
      return new Vec(x + other.x, y + other.y);
    } else if (other is int) {
      return new Vec(x + other, y + other);
    }

    throw new ArgumentError("Operand must be an int or VecBase.");
  }

  /// Substracts [other] from this Vec.
  ///
  ///  *  If [other] is a [Vec] or [Direction], subtracts each pair of
  ///     coordinates.
  ///  *  If [other] is an [int], subtracts that value from both coordinates.
  ///
  /// Any other type is an error.
  Vec operator -(other) {
    if (other is VecBase) {
      return new Vec(x - other.x, y - other.y);
    } else if (other is int) {
      return new Vec(x - other, y - other);
    }

    throw new ArgumentError("Operand must be an int or VecBase.");
  }

  /// Returns `true` if the magnitude of this vector is greater than [other].
  bool operator >(other) {
    if (other is VecBase) {
      return lengthSquared > other.lengthSquared;
    } else if (other is num) {
      return lengthSquared > other * other;
    }

    throw new ArgumentError("Operand must be an int or VecBase.");
  }

  /// Returns `true` if the magnitude of this vector is greater than or equal
  /// to [other].
  bool operator >=(other) {
    if (other is VecBase) {
      return lengthSquared >= other.lengthSquared;
    } else if (other is num) {
      return lengthSquared >= other * other;
    }

    throw new ArgumentError("Operand must be an int or VecBase.");
  }

  /// Returns `true` if the magnitude of this vector is less than [other].
  bool operator <(other) {
    if (other is VecBase) {
      return lengthSquared < other.lengthSquared;
    } else if (other is num) {
      return lengthSquared < other * other;
    }

    throw new ArgumentError("Operand must be an int or VecBase.");
  }

  /// Returns `true` if the magnitude of this vector is less than or equal to
  /// [other].
  bool operator <=(other) {
    if (other is VecBase) {
      return lengthSquared <= other.lengthSquared;
    } else if (other is num) {
      return lengthSquared <= other * other;
    }

    throw new ArgumentError("Operand must be an int or VecBase.");
  }

  /// Gets whether the given vector is within a rectangle from (0,0) to this
  /// vector (half-inclusive).
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
  Vec abs() => new Vec(x.abs(), y.abs());

  /// Returns a new [Vec] whose coordinates are this one's translated by [x] and
  /// [y].
  Vec offset(int x, int y) => new Vec(this.x + x, this.y + y);

  /// Returns a new [Vec] whose coordinates are this one's but with the X
  /// coordinate translated by [x].
  Vec offsetX(int x) => new Vec(this.x + x, y);

  /// Returns a new [Vec] whose coordinates are this one's but with the Y
  /// coordinate translated by [y].
  Vec offsetY(int y) => new Vec(x, this.y + y);

  String toString() => '$x, $y';
}

/// A two-dimensional point.
class Vec extends VecBase {
  static const ZERO = const Vec(0, 0);

  const Vec(int x, int y) : super(x, y);

  bool operator ==(other) {
    if (other is! VecBase) return false;
    return x == other.x && y == other.y;
  }
}
