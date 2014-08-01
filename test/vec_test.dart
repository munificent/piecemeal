library piecemeal.test.vec_test;

import 'dart:math' as math;

import 'package:unittest/unittest.dart';

import 'package:piecemeal/piecemeal.dart';

void main() {
  test("ZERO", () {
    expect(Vec.ZERO.x, equals(0));
    expect(Vec.ZERO.y, equals(0));
  });

  test("coordinates", () {
    var vec = new Vec(2, 3);
    expect(vec.x, equals(2));
    expect(vec.y, equals(3));
  });

  test("area", () {
    expect(new Vec(0, 0).area, equals(0));
    expect(new Vec(2, 3).area, equals(6));
    expect(new Vec(-4, 5).area, equals(-20));
  });

  test("kingLength", () {
    expect(new Vec(0, 0).kingLength, equals(0));
    expect(new Vec(2, 3).kingLength, equals(3));
    expect(new Vec(-4, 5).kingLength, equals(5));
  });

  test("rookLength", () {
    expect(new Vec(0, 0).rookLength, equals(0));
    expect(new Vec(2, 3).rookLength, equals(5));
    expect(new Vec(-4, 5).rookLength, equals(9));
  });

  test("lengthSquared", () {
    expect(new Vec(0, 0).lengthSquared, equals(0));
    expect(new Vec(2, 3).lengthSquared, equals(13));
    expect(new Vec(-4, 5).lengthSquared, equals(41));
  });

  test("length", () {
    expect(new Vec(0, 0).length, equals(0.0));
    expect(new Vec(3, 4).length, equals(5));
    expect(new Vec(1, 2).length, equals(math.sqrt(5)));
  });

  test("*", () {
    expect(new Vec(2, 3) * -1, equals(new Vec(-2, -3)));
    expect(new Vec(2, 3) * 4, equals(new Vec(8, 12)));
  });

  test("~/", () {
    expect(new Vec(2, 5) ~/ 2, equals(new Vec(1, 2)));
    expect(new Vec(2, 5) ~/ 4, equals(new Vec(0, 1)));
  });

  group("+", () {
    test("Vec sums the vectors", () {
      expect(new Vec(2, 3) + new Vec(1, 1), equals(new Vec(3, 4)));
      expect(new Vec(2, 3) + new Vec(-1, 3), equals(new Vec(1, 6)));
    });

    test("Direction sums the vectors", () {
      expect(new Vec(2, 3) + Direction.SE, equals(new Vec(3, 4)));
      expect(new Vec(2, 3) + Direction.NW, equals(new Vec(1, 2)));
    });

    test("int offsets both coordinates", () {
      expect(new Vec(2, 3) + 1, equals(new Vec(3, 4)));
      expect(new Vec(2, 3) + 2, equals(new Vec(4, 5)));
    });

    test("any other type throws", () {
      expect(() => new Vec(2, 3) + false, throwsArgumentError);
    });
  });

  group("-", () {
    test("Vec subtracts the vectors", () {
      expect(new Vec(2, 3) - new Vec(1, 1), equals(new Vec(1, 2)));
      expect(new Vec(2, 3) - new Vec(-1, 3), equals(new Vec(3, 0)));
    });

    test("Direction subtracts the vectors", () {
      expect(new Vec(2, 3) - Direction.SE, equals(new Vec(1, 2)));
      expect(new Vec(2, 3) - Direction.NW, equals(new Vec(3, 4)));
    });

    test("int offsets both coordinates", () {
      expect(new Vec(2, 3) - 1, equals(new Vec(1, 2)));
      expect(new Vec(2, 3) - 2, equals(new Vec(0, 1)));
    });

    test("any other type throws", () {
      expect(() => new Vec(2, 3) - false, throwsArgumentError);
    });
  });

  group("<", () {
    test("Vec compares magnitude", () {
      expect(new Vec(3, 4) < new Vec(-2, 2), isFalse);
      expect(new Vec(3, 4) < new Vec(4, 3), isFalse);
      expect(new Vec(3, 4) < new Vec(5, 6), isTrue);
    });

    test("Direction compares magnitude", () {
      expect(new Vec(3, 4) < Direction.SE, isFalse);
      expect(new Vec(1, 1) < Direction.SE, isFalse);
      expect(new Vec(0, 1) < Direction.SE, isTrue);
    });

    test("num compares magnitude to value", () {
      expect(new Vec(3, 4) < 4, isFalse);
      expect(new Vec(3, 4) < 5.0, isFalse);
      expect(new Vec(3, 4) < 10, isTrue);
    });

    test("any other type throws", () {
      expect(() => new Vec(2, 3) < false, throwsArgumentError);
    });
  });

  group(">", () {
    test("Vec compares magnitude", () {
      expect(new Vec(3, 4) > new Vec(-2, 2), isTrue);
      expect(new Vec(3, 4) > new Vec(4, 3), isFalse);
      expect(new Vec(3, 4) > new Vec(5, 6), isFalse);
    });

    test("Direction compares magnitude", () {
      expect(new Vec(3, 4) > Direction.SE, isTrue);
      expect(new Vec(1, 1) > Direction.SE, isFalse);
      expect(new Vec(0, 1) > Direction.SE, isFalse);
    });

    test("num compares magnitude to value", () {
      expect(new Vec(3, 4) > 4, isTrue);
      expect(new Vec(3, 4) > 5.0, isFalse);
      expect(new Vec(3, 4) > 10, isFalse);
    });

    test("any other type throws", () {
      expect(() => new Vec(2, 3) > false, throwsArgumentError);
    });
  });

  group("<=", () {
    test("Vec compares magnitude", () {
      expect(new Vec(3, 4) <= new Vec(-2, 2), isFalse);
      expect(new Vec(3, 4) <= new Vec(4, 3), isTrue);
      expect(new Vec(3, 4) <= new Vec(5, 6), isTrue);
    });

    test("Direction compares magnitude", () {
      expect(new Vec(3, 4) <= Direction.SE, isFalse);
      expect(new Vec(1, 1) <= Direction.SE, isTrue);
      expect(new Vec(0, 1) <= Direction.SE, isTrue);
    });

    test("num compares magnitude to value", () {
      expect(new Vec(3, 4) <= 4, isFalse);
      expect(new Vec(3, 4) <= 5.0, isTrue);
      expect(new Vec(3, 4) <= 10, isTrue);
    });

    test("any other type throws", () {
      expect(() => new Vec(2, 3) <= false, throwsArgumentError);
    });
  });

  group(">=", () {
    test("Vec compares magnitude", () {
      expect(new Vec(3, 4) >= new Vec(-2, 2), isTrue);
      expect(new Vec(3, 4) >= new Vec(4, 3), isTrue);
      expect(new Vec(3, 4) >= new Vec(5, 6), isFalse);
    });

    test("Direction compares magnitude", () {
      expect(new Vec(3, 4) >= Direction.SE, isTrue);
      expect(new Vec(1, 1) >= Direction.SE, isTrue);
      expect(new Vec(0, 1) >= Direction.SE, isFalse);
    });

    test("num compares magnitude to value", () {
      expect(new Vec(3, 4) >= 4, isTrue);
      expect(new Vec(3, 4) >= 5.0, isTrue);
      expect(new Vec(3, 4) >= 10, isFalse);
    });

    test("any other type throws", () {
      expect(() => new Vec(2, 3) >= false, throwsArgumentError);
    });
  });

  test("abs()", () {
    expect(new Vec(2, -1).abs(), equals(new Vec(2, 1)));
    expect(new Vec(0, -3).abs(), equals(new Vec(0, 3)));
  });

  test("contains()", () {
    expect(new Vec(3, 4).contains(new Vec(0, 0)), isTrue);
    expect(new Vec(3, 4).contains(new Vec(2, 1)), isTrue);
    expect(new Vec(3, 4).contains(new Vec(-1, 0)), isFalse);
    expect(new Vec(3, 4).contains(new Vec(0, -1)), isFalse);
    expect(new Vec(3, 4).contains(new Vec(3, 1)), isFalse);
    expect(new Vec(3, 4).contains(new Vec(2, 4)), isFalse);

    expect(new Vec(-3, 4).contains(new Vec(-3, 0)), isTrue);
    expect(new Vec(-3, 4).contains(new Vec(-2, 1)), isTrue);
    expect(new Vec(-3, 4).contains(new Vec(-4, 0)), isFalse);
    expect(new Vec(-3, 4).contains(new Vec(0, -1)), isFalse);
    expect(new Vec(-3, 4).contains(new Vec(0, 1)), isFalse);
    expect(new Vec(-3, 4).contains(new Vec(-2, 4)), isFalse);
  });

  test("offset()", () {
    expect(new Vec(1, 2).offset(3, 4), equals(new Vec(4, 6)));
    expect(new Vec(1, 2).offset(1, -2), equals(new Vec(2, 0)));
  });

  test("offsetX()", () {
    expect(new Vec(1, 2).offsetX(3), equals(new Vec(4, 2)));
    expect(new Vec(1, 2).offsetX(-2), equals(new Vec(-1, 2)));
  });

  test("offsetY()", () {
    expect(new Vec(1, 2).offsetY(3), equals(new Vec(1, 5)));
    expect(new Vec(1, 2).offsetY(-1), equals(new Vec(1, 1)));
  });

  test("toString()", () {
    expect(new Vec(1, 2).toString(), equals("1, 2"));
    expect(new Vec(-3, 0).toString(), equals("-3, 0"));
  });

  test("equality", () {
    expect(new Vec(2, 1) == new Vec(2, 1), isTrue);
    expect(new Vec(2, 1) == new Vec(1, 2), isFalse);

    expect(new Vec(1, 1) == Direction.SE, isTrue);
    expect(new Vec(2, 1) == Direction.SE, isFalse);

    // Other types.
    expect(new Vec(0, 0) == 0, isFalse);
  });
}