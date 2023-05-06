import 'dart:collection';

import 'rect.dart';
import 'vec.dart';

/// Utility class for handling simple rasterized circles of a relatively small
/// radius.
///
/// Used for lighting, ball spells, etc. Optimized to generate "nice" looking
/// circles at small sizes.
class Circle extends IterableBase<Vec> {
  /// The position of the center of the circle.
  final Vec center;

  /// The radius of this Circle.
  final int radius;

  Circle(this.center, this.radius) {
    if (radius < 0) throw ArgumentError("The radius cannot be negative.");
  }

  /// Whether [pos] is within the circle.
  @override
  bool contains(covariant Vec pos) => _contains(center, radius, pos);

  /// Whether [pos] is in the outermost edge of the circle.
  bool isEdge(Vec pos) {
    // Must be within the circle.
    if (!contains(pos)) return false;

    // But not within the next smallest circle inside it.
    if (radius > 0 && _contains(center, radius - 1, pos)) return false;

    return true;
  }

  /// Iterates over all points within the circle.
  @override
  Iterator<Vec> get iterator => _CircleIterator(this, edge: false);

  /// Traces the outside edge of the circle.
  Iterable<Vec> get edge => _CircleIterable(_CircleIterator(this, edge: true));
}

class _CircleIterable extends IterableBase<Vec> {
  @override
  final Iterator<Vec> iterator;

  _CircleIterable(this.iterator);
}

class _CircleIterator implements Iterator<Vec> {
  @override
  Vec get current => _boundsIterator.current;

  final Circle _circle;

  /// Iterator over the rectangle of points containing the circle.
  final Iterator<Vec> _boundsIterator;

  /// Whether we are iterating over just the edge points or all points within
  /// the circle.
  final bool _edge;

  factory _CircleIterator(Circle circle, {required bool edge}) {
    var size = circle.radius + circle.radius + 1;
    var bounds = Rect(circle.center.x - circle.radius,
        circle.center.y - circle.radius, size, size);
    return _CircleIterator._(circle, bounds.iterator, edge: edge);
  }

  _CircleIterator._(this._circle, this._boundsIterator, {required bool edge})
      : _edge = edge;

  @override
  bool moveNext() {
    while (_boundsIterator.moveNext()) {
      // Skip over points that aren't within the what we're iterating over.
      var pos = _boundsIterator.current;
      if (_edge) {
        if (_circle.isEdge(pos)) return true;
      } else {
        if (_circle.contains(pos)) return true;
      }
    }

    return false;
  }
}

bool _contains(Vec center, int radius, Vec pos) {
  var lengthSquared = (pos - center).lengthSquared;

  // If small enough, use the tuned radius to look best.
  const radiiSquared = [0, 2, 5, 10, 18, 26, 38];
  if (radius < radiiSquared.length) {
    return lengthSquared <= radiiSquared[radius];
  }

  // Otherwise, sort of split the difference between the actual squared radius
  // and the radius of a 1-unit larger circle. If we use the actual radius, then
  // the circle only contains the outermost points right at the origins, like:
  //
  // .................
  // ........X........
  // .....*******.....
  // ....*********....
  // ...***********...
  // ..*************..
  // ..*************..
  // ..*************..
  // .X*************X.
  // ..*************..
  // ..*************..
  // ..*************..
  // ...***********...
  // ....*********....
  // .....*******.....
  // ........X........
  // .................
  //
  // By cheating out the radius a bit, we get circles that fill their radius a
  // little better, like:
  //
  // .................
  // ......*****......
  // ....*********....
  // ...***********...
  // ..*************..
  // ..*************..
  // .***************.
  // .***************.
  // .***************.
  // .***************.
  // .***************.
  // ..*************..
  // ..*************..
  // ...***********...
  // ....*********....
  // ......*****......
  // .................
  return lengthSquared <= radius * (radius + 1);
}
