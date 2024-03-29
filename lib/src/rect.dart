import 'dart:collection';
import 'dart:math' as math;

import 'vec.dart';

/// A two-dimensional immutable rectangle with integer coordinates.
///
/// Many operations treat a [Rect] as a collection of discrete points. In those
/// cases, the boundaries of the rect are two half-open intervals when
/// determining which points are inside the rect. For example, consider the
/// rect whose coordinates are (-1, 1)-(3, 4):
///
///      -2 -1  0  1  2  3  4
///       |  |  |  |  |  |  |
///     0-
///     1-   +-----------+
///     2-   |           |
///     3-   |           |
///     4-   +-----------+
///     5-
///
/// It contains all points within that region except for the ones that lie
/// directly on the right and bottom edges. (It's always right and bottom,
/// even if the rectangle has negative coordinates.) In the above examples,
/// that's these points:
///
///      -2 -1  0  1  2  3  4
///       |  |  |  |  |  |  |
///     0-
///     1-   *--*--*--*--+
///     2-   *  *  *  *  |
///     3-   *  *  *  *  |
///     4-   +-----------+
///     5-
///
/// This seems a bit odd, but does what you want in almost all respects. For
/// example, the width of this rect, determined by subtracting the left
/// coordinate (-1) from the right (3) is 4 and indeed it contains four columns
/// of points.
class Rect extends IterableBase<Vec> {
  /// Gets the empty rectangle.
  static const empty = Rect.posAndSize(Vec.zero, Vec.zero);

  /// Creates a new rectangle that is the intersection of [a] and [b].
  ///
  ///     .----------.
  ///     | a        |
  ///     | .--------+----.
  ///     | | result |  b |
  ///     | |        |    |
  ///     '-+--------'    |
  ///       |             |
  ///       '-------------'
  static Rect intersect(Rect a, Rect b) {
    final left = math.max(a.left, b.left);
    final right = math.min(a.right, b.right);
    final top = math.max(a.top, b.top);
    final bottom = math.min(a.bottom, b.bottom);

    final width = math.max(0, right - left);
    final height = math.max(0, bottom - top);

    return Rect(left, top, width, height);
  }

  static Rect centerIn(Rect toCenter, Rect main) {
    final pos = main.pos + ((main.size - toCenter.size) ~/ 2);
    return Rect.posAndSize(pos, toCenter.size);
  }

  final Vec pos;
  final Vec size;

  int get x => pos.x;
  int get y => pos.y;
  int get width => size.x;
  int get height => size.y;

  // Use min and max to handle negative sizes.

  int get left => math.min(x, x + width);
  int get top => math.min(y, y + height);
  int get right => math.max(x, x + width);
  int get bottom => math.max(y, y + height);

  Vec get topLeft => Vec(left, top);
  Vec get topRight => Vec(right, top);
  Vec get bottomLeft => Vec(left, bottom);
  Vec get bottomRight => Vec(right, bottom);

  Vec get center => Vec((left + right) ~/ 2, (top + bottom) ~/ 2);

  int get area => size.area;

  const Rect.posAndSize(this.pos, this.size);

  Rect.leftTopRightBottom(int left, int top, int right, int bottom)
      : pos = Vec(left, top),
        size = Vec(right - left, bottom - top);

  Rect(int x, int y, int width, int height)
      : pos = Vec(x, y),
        size = Vec(width, height);

  /// Creates a new rectangle a single row in height, as wide as [size],
  /// with its top left corner at [pos].
  Rect.row(int x, int y, int size) : this(x, y, size, 1);

  /// Creates a new rectangle a single column in width, as tall as [size],
  /// with its top left corner at [pos].
  Rect.column(int x, int y, int size) : this(x, y, 1, size);

  @override
  String toString() => '($pos)-($size)';

  Rect inflate(int distance) {
    return Rect(x - distance, y - distance, width + (distance * 2),
        height + (distance * 2));
  }

  Rect offset(int x, int y) => Rect(this.x + x, this.y + y, width, height);

  @override
  bool contains(Object? element) {
    if (element is! Vec) return false;

    if (element.x < pos.x) return false;
    if (element.x >= pos.x + size.x) return false;
    if (element.y < pos.y) return false;
    if (element.y >= pos.y + size.y) return false;

    return true;
  }

  bool containsRect(Rect rect) {
    if (rect.left < left) return false;
    if (rect.right > right) return false;
    if (rect.top < top) return false;
    if (rect.bottom > bottom) return false;

    return true;
  }

  /// Returns a new [Vec] that is as near to [vec] as possible while being in
  /// bounds.
  Vec clamp(Vec vec) {
    var x = vec.x.clamp(left, right).toInt();
    var y = vec.y.clamp(top, bottom).toInt();
    return Vec(x, y);
  }

  @override
  RectIterator get iterator => RectIterator(this);

  /// Returns the distance between this Rect and [other]. This is minimum
  /// length that a corridor would have to be to go from one Rect to the other.
  /// If the two Rects are adjacent, returns zero. If they overlap, returns -1.
  int distanceTo(Rect other) {
    var vertical = switch (null) {
      _ when top >= other.bottom => top - other.bottom,
      _ when bottom <= other.top => other.top - bottom,
      _ => -1
    };

    var horizontal = switch (null) {
      _ when left >= other.right => left - other.right,
      _ when right <= other.left => other.left - right,
      _ => -1,
    };

    if (vertical == -1 && horizontal == -1) return -1;
    if (vertical == -1) return horizontal;
    if (horizontal == -1) return vertical;
    return horizontal + vertical;
  }

  /// Iterates over the points along the edge of the Rect.
  Iterable<Vec> trace() {
    if (width > 1 && height > 1) {
      // TODO(bob): Implement an iterator class here if building the list is
      // slow.
      // Trace all four sides.
      final result = <Vec>[];

      for (var x = left; x < right; x++) {
        result.add(Vec(x, top));
        result.add(Vec(x, bottom - 1));
      }

      for (var y = top + 1; y < bottom - 1; y++) {
        result.add(Vec(left, y));
        result.add(Vec(right - 1, y));
      }

      return result;
    } else if (width > 1 && height == 1) {
      // A single row.
      return Rect.row(left, top, width);
    } else if (height >= 1 && width == 1) {
      // A single column, or one unit
      return Rect.column(left, top, height);
    }

    // Otherwise, the rect doesn't have a positive size, so there's nothing to
    // trace.
    return const [];
  }

  // TODO: Equality operator and hashCode.
}

class RectIterator implements Iterator<Vec> {
  final Rect _rect;
  int _x;
  int _y;

  RectIterator(this._rect)
      : _x = _rect.x - 1,
        _y = _rect.y;

  @override
  Vec get current => Vec(_x, _y);

  @override
  bool moveNext() {
    _x++;
    if (_x >= _rect.right) {
      _x = _rect.x;
      _y++;
    }

    return _y < _rect.bottom;
  }
}
