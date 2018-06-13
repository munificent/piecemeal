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

  Iterator<Vec> get iterator => _LineIterator(start, end);

  int get length => throw UnsupportedError("Line iteration is unbounded.");
}

class _LineIterator implements Iterator<Vec> {
  final Vec _start;
  final Vec _end;

  Vec _current;
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

  _LineIterator(this._start, this._end) {
    var delta = _end - _start;

    // Figure which octant the line is in and increment appropriately.
    _primaryStep = Vec(delta.x.sign, 0);
    _secondaryStep = Vec(0, delta.y.sign);

    // Discard the signs now that they are accounted for.
    delta = delta.abs();

    // Assume moving horizontally each step.
    _primary = delta.x;
    _secondary = delta.y;

    // Swap the order if the y magnitude is greater.
    if (delta.y > delta.x) {
      var temp = _primary;
      _primary = _secondary;
      _secondary = temp;

      var tempIncrement = _primaryStep;
      _primaryStep = _secondaryStep;
      _secondaryStep = tempIncrement;
    }

    _current = _start;
    _error = 0;
  }

  /// Always returns `true` to allow a line to overshoot the end point. Make
  /// sure you terminate iteration yourself.
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
