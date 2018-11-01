import 'dart:math' as math;

import 'direction.dart';

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
  Direction get nearestDirection {
    if (x == 0) {
      if (y < 0) {
        return Direction.n;
      } else if (y == 0) {
        return Direction.none;
      } else {
        return Direction.s;
      }
    }

    var slope = y / x;

    if (x < 0) {
      if (slope >= 2.0) {
        return Direction.n;
      } else if (slope >= 0.5) {
        return Direction.nw;
      } else if (slope >= -0.5) {
        return Direction.w;
      } else if (slope >= -2.0) {
        return Direction.sw;
      } else {
        return Direction.s;
      }
    } else {
      if (slope >= 2.0) {
        return Direction.s;
      } else if (slope >= 0.5) {
        return Direction.se;
      } else if (slope >= -0.5) {
        return Direction.e;
      } else if (slope >= -2.0) {
        return Direction.ne;
      } else {
        return Direction.n;
      }
    }
  }

  /// The eight Vecs surrounding this one to the north, south, east, and west
  /// and points in between.
  List<Vec> get neighbors {
    var result = <Vec>[];
    for (var direction in Direction.all) {
      result.add(this + direction);
    }
    return result;
  }

  /// The four Vecs surrounding this one to the north, south, east, and west.
  List<Vec> get cardinalNeighbors {
    var result = <Vec>[];
    for (var direction in Direction.cardinal) {
      result.add(this + direction);
    }
    return result;
  }

  /// The four Vecs surrounding this one to the northeast, southeast, southwest,
  /// and northwest.
  List<Vec> get intercardinalNeighbors {
    var result = <Vec>[];
    for (var direction in Direction.intercardinal) {
      result.add(this + direction);
    }
    return result;
  }

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
  Vec operator +(Object other) {
    if (other is VecBase) {
      return Vec(x + other.x, y + other.y);
    } else if (other is int) {
      return Vec(x + other, y + other);
    }

    throw ArgumentError("Operand must be an int or VecBase.");
  }

  /// Substracts [other] from this Vec.
  ///
  ///  *  If [other] is a [Vec] or [Direction], subtracts each pair of
  ///     coordinates.
  ///  *  If [other] is an [int], subtracts that value from both coordinates.
  ///
  /// Any other type is an error.
  Vec operator -(Object other) {
    if (other is VecBase) {
      return Vec(x - other.x, y - other.y);
    } else if (other is int) {
      return Vec(x - other, y - other);
    }

    throw ArgumentError("Operand must be an int or VecBase.");
  }

  /// Returns `true` if the magnitude of this vector is greater than [other].
  bool operator >(Object other) {
    if (other is VecBase) {
      return lengthSquared > other.lengthSquared;
    } else if (other is num) {
      return lengthSquared > other * other;
    }

    throw ArgumentError("Operand must be an int or VecBase.");
  }

  /// Returns `true` if the magnitude of this vector is greater than or equal
  /// to [other].
  bool operator >=(Object other) {
    if (other is VecBase) {
      return lengthSquared >= other.lengthSquared;
    } else if (other is num) {
      return lengthSquared >= other * other;
    }

    throw ArgumentError("Operand must be an int or VecBase.");
  }

  /// Returns `true` if the magnitude of this vector is less than [other].
  bool operator <(Object other) {
    if (other is VecBase) {
      return lengthSquared < other.lengthSquared;
    } else if (other is num) {
      return lengthSquared < other * other;
    }

    throw ArgumentError("Operand must be an int or VecBase.");
  }

  /// Returns `true` if the magnitude of this vector is less than or equal to
  /// [other].
  bool operator <=(Object other) {
    if (other is VecBase) {
      return lengthSquared <= other.lengthSquared;
    } else if (other is num) {
      return lengthSquared <= other * other;
    }

    throw ArgumentError("Operand must be an int or VecBase.");
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

  String toString() => '$x, $y';
}

/// A two-dimensional point.
class Vec extends VecBase {
  static const zero = Vec(0, 0);

  int get hashCode => (x ^ y).hashCode;

  const Vec(int x, int y) : super(x, y);

  bool operator ==(Object other) {
    if (other is VecBase) {
      return x == other.x && y == other.y;
    }

    return false;
  }
}
