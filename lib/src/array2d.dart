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

  /// Creates a new array with [width], [height] elements initialized to
  /// [value].
  Array2D(int width, int height, T value)
      : bounds = Rect(0, 0, width, height),
        _elements = List<T>.filled(width * height, value);

  /// Creates a new array with [width], [height] elements initialized to the
  /// result of calling [generator] on each element.
  Array2D.generated(int width, int height, T Function(Vec) generator)
      : bounds = Rect(0, 0, width, height),
        _elements = width * height > 0
            ? List<T>.filled(width * height, generator(Vec.zero))
            : List<T>.empty() {
    // Don't call generator() on the first cell twice.
    for (var x = 1; x < width; x++) {
      set(x, 0, generator(Vec(x, 0)));
    }

    for (var y = 1; y < height; y++) {
      for (var x = 0; x < width; x++) {
        set(x, y, generator(Vec(x, y)));
      }
    }
  }

  /// Gets the element at [pos].
  T operator [](Vec pos) => get(pos.x, pos.y);

  /// Sets the element at [pos].
  void operator []=(Vec pos, T value) => set(pos.x, pos.y, value);

  /// A [Rect] whose bounds cover the full range of valid element indexes.
  final Rect bounds;
  // Store the bounds rect instead of simply the width and height because this
  // is accessed very frequently and avoids allocating a new Rect each time.

  /// The size of the array.
  Vec get size => bounds.size;

  /// Gets the element in the array at [x], [y].
  T get(int x, int y) {
    _checkBounds(x, y);
    return _elements[y * width + x];
  }

  /// Sets the element in the array at [x], [y] to [value].
  void set(int x, int y, T value) {
    _checkBounds(x, y);
    _elements[y * width + x] = value;
  }

  /// Sets every element to [value].
  void fill(T value) {
    _elements.fillRange(0, _elements.length, value);
  }

  /// Evaluates [generator] on each position in the array and sets the element
  /// at that position to the result.
  void generate(T Function(Vec) generator) {
    for (var pos in bounds) this[pos] = generator(pos);
  }

  Iterator<T> get iterator => _elements.iterator;

  void _checkBounds(int x, int y) {
    if (x < 0 || x >= width) throw RangeError.value(x, "x");
    if (y < 0 || y >= height) throw RangeError.value(y, "y");
  }
}
