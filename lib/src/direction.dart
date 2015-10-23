library piecemeal.src.direction;

import 'vec.dart';

class Direction extends VecBase implements Vec {
  static const none = const Direction(0, 0);
  static const n    = const Direction(0, -1);
  static const ne   = const Direction(1, -1);
  static const e    = const Direction(1, 0);
  static const se   = const Direction(1, 1);
  static const s    = const Direction(0, 1);
  static const sw   = const Direction(-1, 1);
  static const w    = const Direction(-1, 0);
  static const nw   = const Direction(-1, -1);

  /// The eight cardinal and intercardinal directions.
  static const all = const [n, ne, e, se, s, sw, w, nw];

  /// The four cardinal directions: north, south, east, and west.
  static const cardinal = const [n, e, s, w];

  /// The four directions between the cardinal ones: northwest, northeast,
  /// southwest and southeast.
  static const intercardinal = const [ne, se, sw, nw];

  const Direction(int x, int y) : super(x, y);

  Direction get rotateLeft45 {
    switch (this) {
      case none: return none;
      case n: return nw;
      case ne: return n;
      case e: return ne;
      case se: return e;
      case s: return se;
      case sw: return s;
      case w: return sw;
      case nw: return w;
    }

    throw "unreachable";
  }

  Direction get rotateRight45 {
    switch (this) {
      case none: return none;
      case n: return ne;
      case ne: return e;
      case e: return se;
      case se: return s;
      case s: return sw;
      case sw: return w;
      case w: return nw;
      case nw: return n;
    }

    throw "unreachable";
  }

  Direction get rotateLeft90 {
    switch (this) {
      case none: return none;
      case n: return w;
      case ne: return nw;
      case e: return n;
      case se: return ne;
      case s: return e;
      case sw: return se;
      case w: return s;
      case nw: return sw;
    }

    throw "unreachable";
  }

  Direction get rotateRight90 {
    switch (this) {
      case none: return none;
      case n: return e;
      case ne: return se;
      case e: return s;
      case se: return sw;
      case s: return w;
      case sw: return nw;
      case w: return n;
      case nw: return ne;
    }

    throw "unreachable";
  }

  Direction get rotate180 {
    switch (this) {
      case none: return none;
      case n: return s;
      case ne: return sw;
      case e: return w;
      case se: return nw;
      case s: return n;
      case sw: return ne;
      case w: return e;
      case nw: return se;
    }

    throw "unreachable";
  }

  String toString() {
    switch (this) {
      case none: return "none";
      case n: return "n";
      case ne: return "ne";
      case e: return "e";
      case se: return "se";
      case s: return "s";
      case sw: return "sw";
      case w: return "w";
      case nw: return "nw";
    }

    throw "unreachable";
  }
}
