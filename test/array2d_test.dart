import 'package:piecemeal/piecemeal.dart';
import 'package:test/test.dart';

void main() {
  group("Array2D()", () {
    test("normal", () {
      var array = Array2D(3, 2, "fill");
      expect(array.width, equals(3));
      expect(array.height, equals(2));
      expect(array.bounds, equals(Rect(0, 0, 3, 2)));
      expect(array.size, equals(Vec(3, 2)));
      expect(array.get(0, 0), equals("fill"));
    });

    test("empty", () {
      var array = Array2D(0, 0, 1);
      expect(array.width, equals(0));
      expect(array.height, equals(0));
      expect(array.bounds, equals(Rect(0, 0, 0, 0)));
      expect(array.size, equals(Vec(0, 0)));
    });
  });

  group("Array2D.generated", () {
    test("normal", () {
      var calls = <Vec>[];
      var array = Array2D.generated(2, 3, (pos) {
        calls.add(pos);
        return pos.x * 100 + pos.y;
      });

      expect(array.width, equals(2));
      expect(array.height, equals(3));
      expect(array.bounds, equals(Rect(0, 0, 2, 3)));
      expect(array.size, equals(Vec(2, 3)));
      expect(array.get(0, 0), equals(0));
      expect(array.get(1, 2), equals(102));

      expect(
          calls,
          equals([
            Vec(0, 0),
            Vec(1, 0),
            Vec(0, 1),
            Vec(1, 1),
            Vec(0, 2),
            Vec(1, 2),
          ]));
    });

    test("empty", () {
      var calls = <Vec>[];
      var array = Array2D.generated(0, 0, (pos) {
        calls.add(pos);
        return pos.x * 100 + pos.y;
      });

      expect(array.width, equals(0));
      expect(array.height, equals(0));
      expect(array.bounds, equals(Rect(0, 0, 0, 0)));
      expect(array.size, equals(Vec(0, 0)));
      expect(calls, isEmpty);
    });

    test("1x1", () {
      var calls = <Vec>[];
      var array = Array2D.generated(1, 1, (pos) {
        calls.add(pos);
        return pos.x * 100 + pos.y;
      });

      expect(array.width, equals(1));
      expect(array.height, equals(1));
      expect(array.bounds, equals(Rect(0, 0, 1, 1)));
      expect(array.size, equals(Vec(1, 1)));
      expect(array.get(0, 0), equals(0));
      expect(calls, equals([Vec(0, 0)]));
    });
  });

  group("index operator", () {
    test("[]", () {
      var array = Array2D.generated(3, 2, (pos) => pos.x * 100 + pos.y);

      expect(array[Vec(0, 0)], equals(0));
      expect(array[Vec(1, 0)], equals(100));
      expect(array[Vec(2, 0)], equals(200));
      expect(array[Vec(0, 1)], equals(1));
      expect(array[Vec(1, 1)], equals(101));
      expect(array[Vec(2, 1)], equals(201));
    });

    test("[] out of bounds", () {
      var array = Array2D(3, 2, 0);
      expect(() => array[Vec(-1, 0)], throwsRangeError);
      expect(() => array[Vec(0, -1)], throwsRangeError);
      expect(() => array[Vec(3, 0)], throwsRangeError);
      expect(() => array[Vec(0, 2)], throwsRangeError);
    });

    test("[]=", () {
      var array = Array2D(3, 2, 0);
      array[Vec(0, 0)] = 1;
      array[Vec(1, 0)] = 2;
      array[Vec(0, 1)] = 3;
      array[Vec(2, 1)] = 4;

      expect(array[Vec(0, 0)], equals(1));
      expect(array[Vec(1, 0)], equals(2));
      expect(array[Vec(0, 1)], equals(3));
      expect(array[Vec(2, 1)], equals(4));
    });

    test("[]= out of bounds", () {
      var array = Array2D(3, 2, 0);
      expect(() => array[Vec(-1, 0)] = 1, throwsRangeError);
      expect(() => array[Vec(0, -1)] = 1, throwsRangeError);
      expect(() => array[Vec(3, 0)] = 1, throwsRangeError);
      expect(() => array[Vec(0, 2)] = 1, throwsRangeError);
    });
  });

  group("get()", () {
    test("get()", () {
      var array = Array2D.generated(3, 2, (pos) => pos.x * 100 + pos.y);

      expect(array.get(0, 0), equals(0));
      expect(array.get(1, 0), equals(100));
      expect(array.get(2, 0), equals(200));
      expect(array.get(0, 1), equals(1));
      expect(array.get(1, 1), equals(101));
      expect(array.get(2, 1), equals(201));
    });

    test("out of bounds", () {
      var array = Array2D(3, 2, 0);
      expect(() => array.get(-1, 0), throwsRangeError);
      expect(() => array.get(0, -1), throwsRangeError);
      expect(() => array.get(3, 0), throwsRangeError);
      expect(() => array.get(0, 2), throwsRangeError);
    });
  });

  group("set()", () {
    test("set()", () {
      var array = Array2D(3, 2, 0);
      array.set(0, 0, 1);
      array.set(1, 0, 2);
      array.set(0, 1, 3);
      array.set(2, 1, 4);

      expect(array.get(0, 0), equals(1));
      expect(array.get(1, 0), equals(2));
      expect(array.get(0, 1), equals(3));
      expect(array.get(2, 1), equals(4));
    });

    test("out of bounds", () {
      var array = Array2D(3, 2, 0);
      expect(() => array.set(-1, 0, 1), throwsRangeError);
      expect(() => array.set(0, -1, 1), throwsRangeError);
      expect(() => array.set(3, 0, 1), throwsRangeError);
      expect(() => array.set(0, 2, 1), throwsRangeError);
    });
  });

  test("fill()", () {
    var array = Array2D(3, 2, "before");
    array.fill("after");
    expect(array.get(0, 0), equals("after"));
    expect(array.get(1, 0), equals("after"));
    expect(array.get(2, 0), equals("after"));
    expect(array.get(0, 1), equals("after"));
    expect(array.get(1, 1), equals("after"));
    expect(array.get(2, 1), equals("after"));
  });

  test("generate()", () {
    var array = Array2D(3, 2, -1);
    array.generate((pos) => pos.x * 100 + pos.y);
    expect(array.get(0, 0), equals(0));
    expect(array.get(1, 0), equals(100));
    expect(array.get(2, 0), equals(200));
    expect(array.get(0, 1), equals(1));
    expect(array.get(1, 1), equals(101));
    expect(array.get(2, 1), equals(201));
  });

  test("iterator", () {
    var array = Array2D.generated(3, 2, (pos) => pos.x * 100 + pos.y);
    expect([...array], equals([0, 100, 200, 1, 101, 201]));
  });
}
