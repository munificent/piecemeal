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

  /// Gets whether [pos] is in the outermost edge of the circle.
  bool isEdge(Vec pos) {
    var leadingEdge = true;
    if (radius > 0) {
      leadingEdge = (pos - center) > _radiusSquared(radius - 1);
    }

    return leadingEdge;
  }

  Iterator<Vec> get iterator => _CircleIterator(this, edge: false);

  /// Traces the outside edge of the circle.
  Iterable<Vec> get edge => _CircleIterable(_CircleIterator(this, edge: true));
}

class _CircleIterable extends IterableBase<Vec> {
  final Iterator<Vec> iterator;

  _CircleIterable(this.iterator);
}

class _CircleIterator implements Iterator<Vec> {
  Vec get current => _boundsIterator.current + _circle.center;

  final Circle _circle;
  final Iterator<Vec> _boundsIterator;
  final bool _edge;

  factory _CircleIterator(Circle circle, {required bool edge}) {
    var size = circle.radius + circle.radius + 1;
    var bounds = Rect(-circle.radius, -circle.radius, size, size);
    return _CircleIterator._(circle, bounds.iterator, edge: edge);
  }

  _CircleIterator._(this._circle, this._boundsIterator, {required bool edge})
      : _edge = edge;

  bool moveNext() {
    while (true) {
      if (!_boundsIterator.moveNext()) return false;
      var length = _boundsIterator.current.lengthSquared;

      if (length > _radiusSquared(_circle.radius)) continue;
      if (_edge &&
          _circle.radius > 0 &&
          length < _radiusSquared(_circle.radius - 1)) continue;

      break;
    }

    return true;
  }
}

const _radiiSquared = [0, 2, 5, 10, 18, 26, 38];

int _radiusSquared(int radius) {
  // If small enough, use the tuned radius to look best.
  if (radius < _radiiSquared.length) return _radiiSquared[radius];

  return radius * radius;
}
