import 'dart:collection';

import 'rect.dart';
import 'vec.dart';

/// A two-dimensional fixed-size array of elements of type [T].
///
/// This class doesn't follow matrix notation which tends to put the column
/// index before the row. Instead, it mirrors graphics and games where x --
/// the horizontal component -- comes before y.
///
/// Internally, the elements are stored in a single contiguous list in row-major
/// order.
class Array2D<T> extends IterableBase<T> {
  /// The number of elements in a row of the array.
  int get width => bounds.width;

  /// The number of elements in a column of the array.
  int get height => bounds.height;

  final List<T> _elements;

  /// Creates a new array with [width], [height] elements initialized to [value]
  /// (or `null` if [value] is omitted, which is only allowed if [T] is
  /// nullable).
  Array2D(int width, int height, [T? value])
      : bounds = Rect(0, 0, width, height),
        _elements = List<T>.filled(width * height, value as T);

  /// Creates a new array with [width], [height] elements initialized to the
  /// result of calling [generator] on each element.
  ///
  /// The generator function can either take no parameters, one [Vec]
  /// parameter, or two [int] parameters (`x` and `y`) and returns a value of
  /// type [T].
  Array2D.generated(int width, int height, Function generator)
      : bounds = Rect(0, 0, width, height),
        _elements =
            List<T>.generate(width * height, _makeGenerator(width, generator));

  /// Gets the element at [pos].
  T operator [](Vec pos) => _elements[pos.y * width + pos.x];

  /// Sets the element at [pos].
  void operator []=(Vec pos, T value) {
    _elements[pos.y * width + pos.x] = value;
  }

  /// A [Rect] whose bounds cover the full range of valid element indexes.
  final Rect bounds;
  // Store the bounds rect instead of simply the width and height because this
  // is accessed very frequently and avoids allocating a new Rect each time.

  /// The size of the array.
  Vec get size => bounds.size;

  /// Gets the element in the array at [x], [y].
  T get(int x, int y) => _elements[y * width + x];

  /// Sets the element in the array at [x], [y] to [value].
  void set(int x, int y, T value) {
    _elements[y * width + x] = value;
  }

  /// Sets every element to [value].
  void fill(T value) {
    _elements.fillRange(0, _elements.length, value);
  }

  /// Evaluates [generator] on each position in the array and sets the element
  /// at that position to the result.
  ///
  /// The generator function can either take no parameters, one [Vec]
  /// parameter, or two [int] parameters (`x` and `y`) and returns a value of
  /// type [T].
  void generate(Function generator) {
    var function = _makeGenerator<T>(width, generator);
    for (var i = 0; i < _elements.length; i++) {
      _elements[i] = function(i);
    }
  }

  Iterator<T> get iterator => _elements.iterator;
}

/// Wrap [generator] in a function with a known typed signature.
T Function(int) _makeGenerator<T>(int width, Function generator) {
  if (generator is T Function()) {
    return (int _) => generator();
  } else if (generator is T Function(Vec)) {
    return (int i) => generator(Vec(i % width, i ~/ width));
  } else if (generator is T Function(int, int)) {
    return (int i) => generator(i % width, i ~/ width);
  } else {
    throw ArgumentError(
        "Generator must take zero arguments, one Vec, or two ints.");
  }
}
