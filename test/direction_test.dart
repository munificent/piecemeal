import 'dart:math' as math;

import 'package:piecemeal/piecemeal.dart';
import 'package:test/test.dart';

void main() {
  test("coordinates", () {
    expect(Direction.ne.x, equals(1));
    expect(Direction.ne.y, equals(-1));
  });

  test("area", () {
    expect(Direction.none.area, equals(0));
    expect(Direction.s.area, equals(0));
    expect(Direction.ne.area, equals(-1));
  });

  test("kingLength", () {
    expect(Direction.none.kingLength, equals(0));
    expect(Direction.s.kingLength, equals(1));
    expect(Direction.ne.kingLength, equals(1));
  });

  test("rookLength", () {
    expect(Direction.none.rookLength, equals(0));
    expect(Direction.s.rookLength, equals(1));
    expect(Direction.ne.rookLength, equals(2));
  });

  test("lengthSquared", () {
    expect(Direction.none.lengthSquared, equals(0));
    expect(Direction.s.lengthSquared, equals(1));
    expect(Direction.ne.lengthSquared, equals(2));
  });

  test("length", () {
    expect(Direction.none.length, equals(0));
    expect(Direction.s.length, equals(1));
    expect(Direction.ne.length, equals(math.sqrt(2)));
  });

  test("*", () {
    expect(Direction.ne * -1, equals(Vec(-1, 1)));
    expect(Direction.ne * 4, equals(Vec(4, -4)));
  });

  test("~/", () {
    expect(Direction.ne ~/ 2, equals(Vec(0, 0)));
  });

  group("+", () {
    test("Vec sums the vectors", () {
      expect(Direction.ne + Vec(1, 1), equals(Vec(2, 0)));
      expect(Direction.ne + Vec(-1, 3), equals(Vec(0, 2)));
    });

    test("Direction sums the vectors", () {
      expect(Direction.ne + Direction.se, equals(Vec(2, 0)));
      expect(Direction.ne + Direction.nw, equals(Vec(0, -2)));
    });

    test("int offsets both coordinates", () {
      expect(Direction.ne + 1, equals(Vec(2, 0)));
      expect(Direction.ne + 2, equals(Vec(3, 1)));
    });

    test("any other type throws", () {
      expect(() => Direction.ne + false, throwsArgumentError);
    });
  });

  group("-", () {
    test("Vec subtracts the vectors", () {
      expect(Direction.ne - Vec(1, 1), equals(Vec(0, -2)));
      expect(Direction.ne - Vec(-1, 3), equals(Vec(2, -4)));
    });

    test("Direction subtracts the vectors", () {
      expect(Direction.ne - Direction.se, equals(Vec(0, -2)));
      expect(Direction.ne - Direction.nw, equals(Vec(2, 0)));
    });

    test("int offsets both coordinates", () {
      expect(Direction.ne - 1, equals(Vec(0, -2)));
      expect(Direction.ne - 2, equals(Vec(-1, -3)));
    });

    test("any other type throws", () {
      expect(() => Direction.ne - false, throwsArgumentError);
    });
  });

  group("<", () {
    test("Vec compares magnitude", () {
      expect(Direction.ne < Vec(0, 0), isFalse);
      expect(Direction.ne < Vec(-1, 1), isFalse);
      expect(Direction.ne < Vec(0, 2), isTrue);
    });

    test("Direction compares magnitude", () {
      expect(Direction.n < Direction.none, isFalse);
      expect(Direction.n < Direction.s, isFalse);
      expect(Direction.n < Direction.se, isTrue);
    });

    test("num compares magnitude to value", () {
      expect(Direction.n < 0.5, isFalse);
      expect(Direction.n < 1, isFalse);
      expect(Direction.n < 1.5, isTrue);
    });

    test("any other type throws", () {
      expect(() => Direction.ne < false, throwsArgumentError);
    });
  });

  group(">", () {
    test("Vec compares magnitude", () {
      expect(Direction.ne > Vec(0, 0), isTrue);
      expect(Direction.ne > Vec(-1, 1), isFalse);
      expect(Direction.ne > Vec(0, 2), isFalse);
    });

    test("Direction compares magnitude", () {
      expect(Direction.n > Direction.none, isTrue);
      expect(Direction.n > Direction.s, isFalse);
      expect(Direction.n > Direction.se, isFalse);
    });

    test("num compares magnitude to value", () {
      expect(Direction.n > 0.5, isTrue);
      expect(Direction.n > 1, isFalse);
      expect(Direction.n > 1.5, isFalse);
    });

    test("any other type throws", () {
      expect(() => Direction.ne > false, throwsArgumentError);
    });
  });

  group("<=", () {
    test("Vec compares magnitude", () {
      expect(Direction.ne <= Vec(0, 0), isFalse);
      expect(Direction.ne <= Vec(-1, 1), isTrue);
      expect(Direction.ne <= Vec(0, 2), isTrue);
    });

    test("Direction compares magnitude", () {
      expect(Direction.n <= Direction.none, isFalse);
      expect(Direction.n <= Direction.s, isTrue);
      expect(Direction.n <= Direction.se, isTrue);
    });

    test("num compares magnitude to value", () {
      expect(Direction.n <= 0.5, isFalse);
      expect(Direction.n <= 1, isTrue);
      expect(Direction.n <= 1.5, isTrue);
    });

    test("any other type throws", () {
      expect(() => Direction.ne <= false, throwsArgumentError);
    });
  });

  group(">=", () {
    test("Vec compares magnitude", () {
      expect(Direction.ne >= Vec(0, 0), isTrue);
      expect(Direction.ne >= Vec(-1, 1), isTrue);
      expect(Direction.ne >= Vec(0, 2), isFalse);
    });

    test("Direction compares magnitude", () {
      expect(Direction.n >= Direction.none, isTrue);
      expect(Direction.n >= Direction.s, isTrue);
      expect(Direction.n >= Direction.se, isFalse);
    });

    test("num compares magnitude to value", () {
      expect(Direction.n >= 0.5, isTrue);
      expect(Direction.n >= 1, isTrue);
      expect(Direction.n >= 1.5, isFalse);
    });

    test("any other type throws", () {
      expect(() => Direction.ne >= false, throwsArgumentError);
    });
  });

  test("abs()", () {
    expect(Direction.ne.abs(), equals(Vec(1, 1)));
    expect(Direction.s.abs(), equals(Vec(0, 1)));
  });

  test("contains()", () {
    expect(Direction.se.contains(Vec(0, 0)), isTrue);
    expect(Direction.ne.contains(Vec(0, -1)), isTrue);
    expect(Direction.ne.contains(Vec(1, 0)), isFalse);
    expect(Direction.ne.contains(Vec(1, -1)), isFalse);
    expect(Direction.ne.contains(Vec(3, 2)), isFalse);
  });

  test("offset()", () {
    expect(Direction.ne.offset(3, 4), equals(Vec(4, 3)));
    expect(Direction.ne.offset(1, -2), equals(Vec(2, -3)));
  });

  test("offsetX()", () {
    expect(Direction.ne.offsetX(3), equals(Vec(4, -1)));
    expect(Direction.ne.offsetX(-2), equals(Vec(-1, -1)));
  });

  test("offsetY()", () {
    expect(Direction.ne.offsetY(3), equals(Vec(1, 2)));
    expect(Direction.ne.offsetY(-1), equals(Vec(1, -2)));
  });

  test("toString()", () {
    expect(Direction.ne.toString(), equals("ne"));
    expect(Direction.none.toString(), equals("none"));
  });

  test("==", () {
    expect(Direction.ne == Direction.ne, isTrue);
    expect(Direction.s == Direction.s, isTrue);
    expect(Direction.ne == Direction.s, isFalse);

    // Has identity semantics.
    expect(Direction.ne == Vec(1, -1), isFalse);
    expect(Direction.none == Vec.zero, isFalse);

    // Not equal to other types.
    expect(Direction.ne == 0 as dynamic, isFalse);
  });

  test("rotateLeft45", () {
    expect(Direction.n.rotateLeft45, equals(Direction.nw));
    expect(Direction.se.rotateLeft45, equals(Direction.e));
  });

  test("rotateRight45", () {
    expect(Direction.n.rotateRight45, equals(Direction.ne));
    expect(Direction.se.rotateRight45, equals(Direction.s));
  });

  test("rotateLeft90", () {
    expect(Direction.n.rotateLeft90, equals(Direction.w));
    expect(Direction.se.rotateLeft90, equals(Direction.ne));
  });

  test("rotateRight90", () {
    expect(Direction.n.rotateRight90, equals(Direction.e));
    expect(Direction.se.rotateRight90, equals(Direction.sw));
  });

  test("rotate180", () {
    expect(Direction.n.rotate180, equals(Direction.s));
    expect(Direction.se.rotate180, equals(Direction.nw));
  });
}
