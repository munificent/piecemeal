library piecemeal.src.array2d;

import 'dart:collection';

import 'rect.dart';
import 'vec.dart';

typedef T _NullaryGenerator<T>();
typedef T _VecGenerator<T>(Vec pos);
typedef T _CoordGenerator<T>(int x, int y);

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
  final int width;

  /// The number of elements in a column of the array.
  final int height;

  final List<T> _elements;

  /// Creates a new array with [width], [height] elements initialized to [value]
  /// (or `null` if [value] is omitted).
  Array2D(width, height, [T value])
      : width = width,
        height = height,
        _elements = new List<T>.filled(width * height, value);

  /// Creates a new array with [width], [height] elements initialized to the
  /// result of calling [generator] on each element.
  ///
  /// The generator function can either take no parameters, one [Vec]
  /// parameter, or two [int] parameters (`x` and `y`) and returns a value of
  /// type [T].
  Array2D.generated(width, height, Function generator)
      : width = width,
        height = height,
        _elements = new List<T>.filled(width * height, null) {
    generate(generator);
  }

  /// Gets the element at [pos].
  T operator[](Vec pos) => _elements[pos.y * width + pos.x];

  /// Sets the element at [pos].
  void operator[]=(Vec pos, T value) {
    _elements[pos.y * width + pos.x] = value;
  }

  /// A [Rect] whose bounds cover the full range of valid element indexes.
  Rect get bounds => new Rect(0, 0, width, height);

  /// The size of the array.
  Vec  get size => new Vec(width, height);

  /// Gets the element in the array at [x], [y].
  T get(int x, int y) => _elements[y * width + x];

  /// Sets the element in the array at [x], [y] to [value].
  void set(int x, int y, T value) {
    _elements[y * width + x] = value;
  }

  /// Evaluates [generator] on each position in the array and sets the element
  /// at that position to the result.
  ///
  /// The generator function can either take no parameters, one [Vec]
  /// parameter, or two [int] parameters (`x` and `y`) and returns a value of
  /// type [T].
  void generate(Function generator) {
    // Wrap the generator in a function with a known signature.
    if (generator is _NullaryGenerator<T>) {
      for (var pos in bounds) this[pos] = generator();
    } else if (generator is _VecGenerator<T>) {
      for (var pos in bounds) this[pos] = generator(pos);
    } else if (generator is _CoordGenerator<T>) {
      for (var pos in bounds) this[pos] = generator(pos.x, pos.y);
    } else {
      throw new ArgumentError(
          "Generator must take zero arguments, one Vec, or two ints.");
    }
  }

  Iterator<T> get iterator => _elements.iterator;
}
