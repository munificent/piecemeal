import 'dart:math' as math;

import 'package:test/test.dart';

import 'package:piecemeal/piecemeal.dart';

void main() {
  test("zero", () {
    expect(Vec.zero.x, equals(0));
    expect(Vec.zero.y, equals(0));
  });

  test("coordinates", () {
    var vec = Vec(2, 3);
    expect(vec.x, equals(2));
    expect(vec.y, equals(3));
  });

  test("area", () {
    expect(Vec(0, 0).area, equals(0));
    expect(Vec(2, 3).area, equals(6));
    expect(Vec(-4, 5).area, equals(-20));
  });

  test("kingLength", () {
    expect(Vec(0, 0).kingLength, equals(0));
    expect(Vec(2, 3).kingLength, equals(3));
    expect(Vec(-4, 5).kingLength, equals(5));
  });

  test("rookLength", () {
    expect(Vec(0, 0).rookLength, equals(0));
    expect(Vec(2, 3).rookLength, equals(5));
    expect(Vec(-4, 5).rookLength, equals(9));
  });

  test("lengthSquared", () {
    expect(Vec(0, 0).lengthSquared, equals(0));
    expect(Vec(2, 3).lengthSquared, equals(13));
    expect(Vec(-4, 5).lengthSquared, equals(41));
  });

  test("length", () {
    expect(Vec(0, 0).length, equals(0.0));
    expect(Vec(3, 4).length, equals(5));
    expect(Vec(1, 2).length, equals(math.sqrt(5)));
  });

  test("nearestDirection", () {
    expect(Vec.zero.nearestDirection, Direction.none);

    // Unit distance.
    expect(Vec(0, -1).nearestDirection, Direction.n);
    expect(Vec(1, -1).nearestDirection, Direction.ne);
    expect(Vec(1, 0).nearestDirection, Direction.e);
    expect(Vec(1, 1).nearestDirection, Direction.se);
    expect(Vec(0, 1).nearestDirection, Direction.s);
    expect(Vec(-1, 1).nearestDirection, Direction.sw);
    expect(Vec(-1, 0).nearestDirection, Direction.w);

    // Farther.
    expect(Vec(0, -4).nearestDirection, Direction.n);
    expect(Vec(4, -4).nearestDirection, Direction.ne);
    expect(Vec(4, 0).nearestDirection, Direction.e);
    expect(Vec(4, 4).nearestDirection, Direction.se);
    expect(Vec(0, 4).nearestDirection, Direction.s);
    expect(Vec(-4, 4).nearestDirection, Direction.sw);
    expect(Vec(-4, 0).nearestDirection, Direction.w);

    // If not directly along line, goes to nearest. Tie-breaker goes clockwise.
    expect(Vec(2, -5).nearestDirection, Direction.n);
    expect(Vec(2, -4).nearestDirection, Direction.ne);
    expect(Vec(2, -3).nearestDirection, Direction.ne);

    expect(Vec(3, -2).nearestDirection, Direction.ne);
    expect(Vec(4, -2).nearestDirection, Direction.e);
    expect(Vec(5, -2).nearestDirection, Direction.e);

    expect(Vec(5, 2).nearestDirection, Direction.e);
    expect(Vec(4, 2).nearestDirection, Direction.se);
    expect(Vec(3, 2).nearestDirection, Direction.se);

    expect(Vec(2, 3).nearestDirection, Direction.se);
    expect(Vec(2, 4).nearestDirection, Direction.s);
    expect(Vec(2, 5).nearestDirection, Direction.s);

    expect(Vec(-2, 5).nearestDirection, Direction.s);
    expect(Vec(-2, 4).nearestDirection, Direction.sw);
    expect(Vec(-2, 3).nearestDirection, Direction.sw);

    expect(Vec(-3, 2).nearestDirection, Direction.sw);
    expect(Vec(-4, 2).nearestDirection, Direction.w);
    expect(Vec(-5, 2).nearestDirection, Direction.w);

    expect(Vec(-5, -2).nearestDirection, Direction.w);
    expect(Vec(-4, -2).nearestDirection, Direction.nw);
    expect(Vec(-3, -2).nearestDirection, Direction.nw);

    expect(Vec(-2, -3).nearestDirection, Direction.nw);
    expect(Vec(-2, -4).nearestDirection, Direction.n);
    expect(Vec(-2, -5).nearestDirection, Direction.n);
  });

  test("neighbors", () {
    expect(
        Vec(3, 4).neighbors,
        containsAllInOrder(<Vec>[
          Vec(3, 3),
          Vec(4, 3),
          Vec(4, 4),
          Vec(4, 5),
          Vec(3, 5),
          Vec(2, 5),
          Vec(2, 4),
          Vec(2, 3)
        ]));
  });

  test("cardinalNeighbors", () {
    expect(Vec(3, 4).neighbors,
        containsAllInOrder(<Vec>[Vec(3, 3), Vec(4, 4), Vec(3, 5), Vec(2, 4)]));
  });

  test("intercardinalNeighbors", () {
    expect(Vec(3, 4).intercardinalNeighbors,
        containsAllInOrder(<Vec>[Vec(4, 3), Vec(4, 5), Vec(2, 5), Vec(2, 3)]));
  });

  test("*", () {
    expect(Vec(2, 3) * -1, equals(Vec(-2, -3)));
    expect(Vec(2, 3) * 4, equals(Vec(8, 12)));
  });

  test("~/", () {
    expect(Vec(2, 5) ~/ 2, equals(Vec(1, 2)));
    expect(Vec(2, 5) ~/ 4, equals(Vec(0, 1)));
  });

  group("+", () {
    test("Vec sums the vectors", () {
      expect(Vec(2, 3) + Vec(1, 1), equals(Vec(3, 4)));
      expect(Vec(2, 3) + Vec(-1, 3), equals(Vec(1, 6)));
    });

    test("Direction sums the vectors", () {
      expect(Vec(2, 3) + Direction.se, equals(Vec(3, 4)));
      expect(Vec(2, 3) + Direction.nw, equals(Vec(1, 2)));
    });

    test("int offsets both coordinates", () {
      expect(Vec(2, 3) + 1, equals(Vec(3, 4)));
      expect(Vec(2, 3) + 2, equals(Vec(4, 5)));
    });

    test("any other type throws", () {
      expect(() => Vec(2, 3) + false, throwsArgumentError);
    });
  });

  group("-", () {
    test("Vec subtracts the vectors", () {
      expect(Vec(2, 3) - Vec(1, 1), equals(Vec(1, 2)));
      expect(Vec(2, 3) - Vec(-1, 3), equals(Vec(3, 0)));
    });

    test("Direction subtracts the vectors", () {
      expect(Vec(2, 3) - Direction.se, equals(Vec(1, 2)));
      expect(Vec(2, 3) - Direction.nw, equals(Vec(3, 4)));
    });

    test("int offsets both coordinates", () {
      expect(Vec(2, 3) - 1, equals(Vec(1, 2)));
      expect(Vec(2, 3) - 2, equals(Vec(0, 1)));
    });

    test("any other type throws", () {
      expect(() => Vec(2, 3) - false, throwsArgumentError);
    });
  });

  group("<", () {
    test("Vec compares magnitude", () {
      expect(Vec(3, 4) < Vec(-2, 2), isFalse);
      expect(Vec(3, 4) < Vec(4, 3), isFalse);
      expect(Vec(3, 4) < Vec(5, 6), isTrue);
    });

    test("Direction compares magnitude", () {
      expect(Vec(3, 4) < Direction.se, isFalse);
      expect(Vec(1, 1) < Direction.se, isFalse);
      expect(Vec(0, 1) < Direction.se, isTrue);
    });

    test("num compares magnitude to value", () {
      expect(Vec(3, 4) < 4, isFalse);
      expect(Vec(3, 4) < 5.0, isFalse);
      expect(Vec(3, 4) < 10, isTrue);
    });

    test("any other type throws", () {
      expect(() => Vec(2, 3) < false, throwsArgumentError);
    });
  });

  group(">", () {
    test("Vec compares magnitude", () {
      expect(Vec(3, 4) > Vec(-2, 2), isTrue);
      expect(Vec(3, 4) > Vec(4, 3), isFalse);
      expect(Vec(3, 4) > Vec(5, 6), isFalse);
    });

    test("Direction compares magnitude", () {
      expect(Vec(3, 4) > Direction.se, isTrue);
      expect(Vec(1, 1) > Direction.se, isFalse);
      expect(Vec(0, 1) > Direction.se, isFalse);
    });

    test("num compares magnitude to value", () {
      expect(Vec(3, 4) > 4, isTrue);
      expect(Vec(3, 4) > 5.0, isFalse);
      expect(Vec(3, 4) > 10, isFalse);
    });

    test("any other type throws", () {
      expect(() => Vec(2, 3) > false, throwsArgumentError);
    });
  });

  group("<=", () {
    test("Vec compares magnitude", () {
      expect(Vec(3, 4) <= Vec(-2, 2), isFalse);
      expect(Vec(3, 4) <= Vec(4, 3), isTrue);
      expect(Vec(3, 4) <= Vec(5, 6), isTrue);
    });

    test("Direction compares magnitude", () {
      expect(Vec(3, 4) <= Direction.se, isFalse);
      expect(Vec(1, 1) <= Direction.se, isTrue);
      expect(Vec(0, 1) <= Direction.se, isTrue);
    });

    test("num compares magnitude to value", () {
      expect(Vec(3, 4) <= 4, isFalse);
      expect(Vec(3, 4) <= 5.0, isTrue);
      expect(Vec(3, 4) <= 10, isTrue);
    });

    test("any other type throws", () {
      expect(() => Vec(2, 3) <= false, throwsArgumentError);
    });
  });

  group(">=", () {
    test("Vec compares magnitude", () {
      expect(Vec(3, 4) >= Vec(-2, 2), isTrue);
      expect(Vec(3, 4) >= Vec(4, 3), isTrue);
      expect(Vec(3, 4) >= Vec(5, 6), isFalse);
    });

    test("Direction compares magnitude", () {
      expect(Vec(3, 4) >= Direction.se, isTrue);
      expect(Vec(1, 1) >= Direction.se, isTrue);
      expect(Vec(0, 1) >= Direction.se, isFalse);
    });

    test("num compares magnitude to value", () {
      expect(Vec(3, 4) >= 4, isTrue);
      expect(Vec(3, 4) >= 5.0, isTrue);
      expect(Vec(3, 4) >= 10, isFalse);
    });

    test("any other type throws", () {
      expect(() => Vec(2, 3) >= false, throwsArgumentError);
    });
  });

  test("abs()", () {
    expect(Vec(2, -1).abs(), equals(Vec(2, 1)));
    expect(Vec(0, -3).abs(), equals(Vec(0, 3)));
  });

  test("contains()", () {
    expect(Vec(3, 4).contains(Vec(0, 0)), isTrue);
    expect(Vec(3, 4).contains(Vec(2, 1)), isTrue);
    expect(Vec(3, 4).contains(Vec(-1, 0)), isFalse);
    expect(Vec(3, 4).contains(Vec(0, -1)), isFalse);
    expect(Vec(3, 4).contains(Vec(3, 1)), isFalse);
    expect(Vec(3, 4).contains(Vec(2, 4)), isFalse);

    expect(Vec(-3, 4).contains(Vec(-3, 0)), isTrue);
    expect(Vec(-3, 4).contains(Vec(-2, 1)), isTrue);
    expect(Vec(-3, 4).contains(Vec(-4, 0)), isFalse);
    expect(Vec(-3, 4).contains(Vec(0, -1)), isFalse);
    expect(Vec(-3, 4).contains(Vec(0, 1)), isFalse);
    expect(Vec(-3, 4).contains(Vec(-2, 4)), isFalse);
  });

  test("offset()", () {
    expect(Vec(1, 2).offset(3, 4), equals(Vec(4, 6)));
    expect(Vec(1, 2).offset(1, -2), equals(Vec(2, 0)));
  });

  test("offsetX()", () {
    expect(Vec(1, 2).offsetX(3), equals(Vec(4, 2)));
    expect(Vec(1, 2).offsetX(-2), equals(Vec(-1, 2)));
  });

  test("offsetY()", () {
    expect(Vec(1, 2).offsetY(3), equals(Vec(1, 5)));
    expect(Vec(1, 2).offsetY(-1), equals(Vec(1, 1)));
  });

  test("toString()", () {
    expect(Vec(1, 2).toString(), equals("1, 2"));
    expect(Vec(-3, 0).toString(), equals("-3, 0"));
  });

  test("equality", () {
    expect(Vec(2, 1) == Vec(2, 1), isTrue);
    expect(Vec(2, 1) == Vec(1, 2), isFalse);

    expect(Vec(1, 1) == Direction.se, isTrue);
    expect(Vec(2, 1) == Direction.se, isFalse);

    // Other types.
    expect(Vec(0, 0) == 0, isFalse);
  });
}
