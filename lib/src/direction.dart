library piecemeal.src.direction;

import 'vec.dart';

class Direction extends VecBase implements Vec {
  static const NONE = const Direction(0, 0);
  static const N    = const Direction(0, -1);
  static const NE   = const Direction(1, -1);
  static const E    = const Direction(1, 0);
  static const SE   = const Direction(1, 1);
  static const S    = const Direction(0, 1);
  static const SW   = const Direction(-1, 1);
  static const W    = const Direction(-1, 0);
  static const NW   = const Direction(-1, -1);

  /// The eight cardinal and intercardinal directions.
  static const ALL = const [N, NE, E, SE, S, SW, W, NW];

  /// The four cardinal directions: north, south, east, and west.
  static const CARDINAL = const [N, E, S, W];

  /// The four directions between the cardinal ones: northwest, northeast,
  /// southwest and southeast.
  static const INTERCARDINAL = const [NE, SE, SW, NW];

  const Direction(int x, int y) : super(x, y);

  Direction get rotateLeft45 {
    switch (this) {
      case NONE: return NONE;
      case N: return NW;
      case NE: return N;
      case E: return NE;
      case SE: return E;
      case S: return SE;
      case SW: return S;
      case W: return SW;
      case NW: return W;
    }

    throw "unreachable";
  }

  Direction get rotateRight45 {
    switch (this) {
      case NONE: return NONE;
      case N: return NE;
      case NE: return E;
      case E: return SE;
      case SE: return S;
      case S: return SW;
      case SW: return W;
      case W: return NW;
      case NW: return N;
    }

    throw "unreachable";
  }

  Direction get rotateLeft90 {
    switch (this) {
      case NONE: return NONE;
      case N: return W;
      case NE: return NW;
      case E: return N;
      case SE: return NE;
      case S: return E;
      case SW: return SE;
      case W: return S;
      case NW: return SW;
    }

    throw "unreachable";
  }

  Direction get rotateRight90 {
    switch (this) {
      case NONE: return NONE;
      case N: return E;
      case NE: return SE;
      case E: return S;
      case SE: return SW;
      case S: return W;
      case SW: return NW;
      case W: return N;
      case NW: return NE;
    }

    throw "unreachable";
  }

  Direction get rotate180 {
    switch (this) {
      case NONE: return NONE;
      case N: return S;
      case NE: return SW;
      case E: return W;
      case SE: return NW;
      case S: return N;
      case SW: return NE;
      case W: return E;
      case NW: return SE;
    }

    throw "unreachable";
  }

  String toString() {
    switch (this) {
      case NONE: return "NONE";
      case N: return "N";
      case NE: return "NE";
      case E: return "E";
      case SE: return "SE";
      case S: return "S";
      case SW: return "SW";
      case W: return "W";
      case NW: return "NW";
    }

    throw "unreachable";
  }
}
