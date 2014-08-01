library piecemeal.test.direction_test;

import 'dart:math' as math;

import 'package:unittest/unittest.dart';

import 'package:piecemeal/piecemeal.dart';

void main() {
  test("coordinates", () {
    expect(Direction.NE.x, equals(1));
    expect(Direction.NE.y, equals(-1));
  });

  test("area", () {
    expect(Direction.NONE.area, equals(0));
    expect(Direction.S.area, equals(0));
    expect(Direction.NE.area, equals(-1));
  });

  test("kingLength", () {
    expect(Direction.NONE.kingLength, equals(0));
    expect(Direction.S.kingLength, equals(1));
    expect(Direction.NE.kingLength, equals(1));
  });

  test("rookLength", () {
    expect(Direction.NONE.rookLength, equals(0));
    expect(Direction.S.rookLength, equals(1));
    expect(Direction.NE.rookLength, equals(2));
  });

  test("lengthSquared", () {
    expect(Direction.NONE.lengthSquared, equals(0));
    expect(Direction.S.lengthSquared, equals(1));
    expect(Direction.NE.lengthSquared, equals(2));
  });

  test("length", () {
    expect(Direction.NONE.length, equals(0));
    expect(Direction.S.length, equals(1));
    expect(Direction.NE.length, equals(math.sqrt(2)));
  });

  test("*", () {
    expect(Direction.NE * -1, equals(new Vec(-1, 1)));
    expect(Direction.NE * 4, equals(new Vec(4, -4)));
  });

  test("~/", () {
    expect(Direction.NE ~/ 2, equals(new Vec(0, 0)));
  });

  group("+", () {
    test("Vec sums the vectors", () {
      expect(Direction.NE + new Vec(1, 1), equals(new Vec(2, 0)));
      expect(Direction.NE + new Vec(-1, 3), equals(new Vec(0, 2)));
    });

    test("Direction sums the vectors", () {
      expect(Direction.NE + Direction.SE, equals(new Vec(2, 0)));
      expect(Direction.NE + Direction.NW, equals(new Vec(0, -2)));
    });

    test("int offsets both coordinates", () {
      expect(Direction.NE + 1, equals(new Vec(2, 0)));
      expect(Direction.NE + 2, equals(new Vec(3, 1)));
    });

    test("any other type throws", () {
      expect(() => Direction.NE + false, throwsArgumentError);
    });
  });

  group("-", () {
    test("Vec subtracts the vectors", () {
      expect(Direction.NE - new Vec(1, 1), equals(new Vec(0, -2)));
      expect(Direction.NE - new Vec(-1, 3), equals(new Vec(2, -4)));
    });

    test("Direction subtracts the vectors", () {
      expect(Direction.NE - Direction.SE, equals(new Vec(0, -2)));
      expect(Direction.NE - Direction.NW, equals(new Vec(2, 0)));
    });

    test("int offsets both coordinates", () {
      expect(Direction.NE - 1, equals(new Vec(0, -2)));
      expect(Direction.NE - 2, equals(new Vec(-1, -3)));
    });

    test("any other type throws", () {
      expect(() => Direction.NE - false, throwsArgumentError);
    });
  });

  group("<", () {
    test("Vec compares magnitude", () {
      expect(Direction.NE < new Vec(0, 0), isFalse);
      expect(Direction.NE < new Vec(-1, 1), isFalse);
      expect(Direction.NE < new Vec(0, 2), isTrue);
    });

    test("Direction compares magnitude", () {
      expect(Direction.N < Direction.NONE, isFalse);
      expect(Direction.N < Direction.S, isFalse);
      expect(Direction.N < Direction.SE, isTrue);
    });

    test("num compares magnitude to value", () {
      expect(Direction.N < 0.5, isFalse);
      expect(Direction.N < 1, isFalse);
      expect(Direction.N < 1.5, isTrue);
    });

    test("any other type throws", () {
      expect(() => Direction.NE < false, throwsArgumentError);
    });
  });

  group(">", () {
    test("Vec compares magnitude", () {
      expect(Direction.NE > new Vec(0, 0), isTrue);
      expect(Direction.NE > new Vec(-1, 1), isFalse);
      expect(Direction.NE > new Vec(0, 2), isFalse);
    });

    test("Direction compares magnitude", () {
      expect(Direction.N > Direction.NONE, isTrue);
      expect(Direction.N > Direction.S, isFalse);
      expect(Direction.N > Direction.SE, isFalse);
    });

    test("num compares magnitude to value", () {
      expect(Direction.N > 0.5, isTrue);
      expect(Direction.N > 1, isFalse);
      expect(Direction.N > 1.5, isFalse);
    });

    test("any other type throws", () {
      expect(() => Direction.NE > false, throwsArgumentError);
    });
  });

  group("<=", () {
    test("Vec compares magnitude", () {
      expect(Direction.NE <= new Vec(0, 0), isFalse);
      expect(Direction.NE <= new Vec(-1, 1), isTrue);
      expect(Direction.NE <= new Vec(0, 2), isTrue);
    });

    test("Direction compares magnitude", () {
      expect(Direction.N <= Direction.NONE, isFalse);
      expect(Direction.N <= Direction.S, isTrue);
      expect(Direction.N <= Direction.SE, isTrue);
    });

    test("num compares magnitude to value", () {
      expect(Direction.N <= 0.5, isFalse);
      expect(Direction.N <= 1, isTrue);
      expect(Direction.N <= 1.5, isTrue);
    });

    test("any other type throws", () {
      expect(() => Direction.NE <= false, throwsArgumentError);
    });
  });

  group(">=", () {
    test("Vec compares magnitude", () {
      expect(Direction.NE >= new Vec(0, 0), isTrue);
      expect(Direction.NE >= new Vec(-1, 1), isTrue);
      expect(Direction.NE >= new Vec(0, 2), isFalse);
    });

    test("Direction compares magnitude", () {
      expect(Direction.N >= Direction.NONE, isTrue);
      expect(Direction.N >= Direction.S, isTrue);
      expect(Direction.N >= Direction.SE, isFalse);
    });

    test("num compares magnitude to value", () {
      expect(Direction.N >= 0.5, isTrue);
      expect(Direction.N >= 1, isTrue);
      expect(Direction.N >= 1.5, isFalse);
    });

    test("any other type throws", () {
      expect(() => Direction.NE >= false, throwsArgumentError);
    });
  });

  test("abs()", () {
    expect(Direction.NE.abs(), equals(new Vec(1, 1)));
    expect(Direction.S.abs(), equals(new Vec(0, 1)));
  });

  test("contains()", () {
    expect(Direction.SE.contains(new Vec(0, 0)), isTrue);
    expect(Direction.NE.contains(new Vec(0, -1)), isTrue);
    expect(Direction.NE.contains(new Vec(1, 0)), isFalse);
    expect(Direction.NE.contains(new Vec(1, -1)), isFalse);
    expect(Direction.NE.contains(new Vec(3, 2)), isFalse);
  });

  test("offset()", () {
    expect(Direction.NE.offset(3, 4), equals(new Vec(4, 3)));
    expect(Direction.NE.offset(1, -2), equals(new Vec(2, -3)));
  });

  test("offsetX()", () {
    expect(Direction.NE.offsetX(3), equals(new Vec(4, -1)));
    expect(Direction.NE.offsetX(-2), equals(new Vec(-1, -1)));
  });

  test("offsetY()", () {
    expect(Direction.NE.offsetY(3), equals(new Vec(1, 2)));
    expect(Direction.NE.offsetY(-1), equals(new Vec(1, -2)));
  });

  test("toString()", () {
    expect(Direction.NE.toString(), equals("NE"));
    expect(Direction.NONE.toString(), equals("NONE"));
  });

  test("equality", () {
    expect(Direction.NE == Direction.NE, isTrue);
    expect(Direction.S == Direction.S, isTrue);
    expect(Direction.NE == Direction.S, isFalse);

    // Uses identity equality.
    expect(Direction.NE == new Vec(1, -1), isFalse);
    expect(Direction.NONE == Vec.ZERO, isFalse);

    // Other types.
    expect(Direction.NE == 0, isFalse);
  });
}