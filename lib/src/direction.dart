import 'vec.dart';

enum Direction with VecMixin implements Vec {
  none(0, 0),
  n(0, -1),
  ne(1, -1),
  e(1, 0),
  se(1, 1),
  s(0, 1),
  sw(-1, 1),
  w(-1, 0),
  nw(-1, -1);

  final int x;
  final int y;

  /// The eight cardinal and intercardinal directions.
  static const all = [n, ne, e, se, s, sw, w, nw];

  /// The four cardinal directions: north, south, east, and west.
  static const cardinal = [n, e, s, w];

  /// The four directions between the cardinal ones: northwest, northeast,
  /// southwest and southeast.
  static const intercardinal = [ne, se, sw, nw];

  const Direction(this.x, this.y);

  Direction get rotateLeft45 => switch (this) {
        none => none,
        n => nw,
        ne => n,
        e => ne,
        se => e,
        s => se,
        sw => s,
        w => sw,
        nw => w,
      };

  Direction get rotateRight45 => switch (this) {
        none => none,
        n => ne,
        ne => e,
        e => se,
        se => s,
        s => sw,
        sw => w,
        w => nw,
        nw => n,
      };

  Direction get rotateLeft90 => switch (this) {
        none => none,
        n => w,
        ne => nw,
        e => n,
        se => ne,
        s => e,
        sw => se,
        w => s,
        nw => sw,
      };

  Direction get rotateRight90 => switch (this) {
        none => none,
        n => e,
        ne => se,
        e => s,
        se => sw,
        s => w,
        sw => nw,
        w => n,
        nw => ne,
      };

  Direction get rotate180 => switch (this) {
        none => none,
        n => s,
        ne => sw,
        e => w,
        se => nw,
        s => n,
        sw => ne,
        w => e,
        nw => se,
      };

  @override
  String toString() => switch (this) {
        none => "none",
        n => "n",
        ne => "ne",
        e => "e",
        se => "se",
        s => "s",
        sw => "sw",
        w => "w",
        nw => "nw",
      };
}
