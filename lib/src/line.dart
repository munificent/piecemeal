import 'dart:collection';

import 'vec.dart';

/// Traces a line of integer coordinates from a [start] point to and through an
/// [end] point using Bresenham's line drawing algorithm.
///
/// Useful for line-of-sight calculation, tracing missile paths, etc.
class Line extends IterableBase<Vec> {
  final Vec start;
  final Vec end;

  Line(this.start, this.end);

  @override
  Iterator<Vec> get iterator => _LineIterator(start, end);

  @override
  int get length => throw UnsupportedError("Line iteration is unbounded.");
}

class _LineIterator implements Iterator<Vec> {
  Vec _current;
  @override
  Vec get current => _current;

  /// Accumulated "error".
  int _error;

  int _primary;

  int _secondary;

  /// Unit vector for the primary direction the line is moving. It advances one
  /// unit this direction each step.
  Vec _primaryStep;

  /// Unit vector for the primary direction the line is moving. It advances one
  /// unit this direction when the accumulated error overflows.
  Vec _secondaryStep;

  factory _LineIterator(Vec start, Vec end) {
    var delta = end - start;

    // Figure which octant the line is in and increment appropriately.
    var primaryStep = Vec(delta.x.sign, 0);
    var secondaryStep = Vec(0, delta.y.sign);

    // Discard the signs now that they are accounted for.
    delta = delta.abs();

    // Assume moving horizontally each step.
    var primary = delta.x;
    var secondary = delta.y;

    // Swap the order if the y magnitude is greater.
    if (delta.y > delta.x) {
      var temp = primary;
      primary = secondary;
      secondary = temp;

      var tempIncrement = primaryStep;
      primaryStep = secondaryStep;
      secondaryStep = tempIncrement;
    }

    return _LineIterator._(
        start, 0, primary, secondary, primaryStep, secondaryStep);
  }

  _LineIterator._(this._current, this._error, this._primary, this._secondary,
      this._primaryStep, this._secondaryStep);

  /// Always returns `true` to allow a line to overshoot the end point. Make
  /// sure you terminate iteration yourself.
  @override
  bool moveNext() {
    _current += _primaryStep;

    // See if we need to step in the secondary direction.
    _error += _secondary;
    if (_error * 2 >= _primary) {
      _current += _secondaryStep;
      _error -= _primary;
    }

    return true;
  }
}
