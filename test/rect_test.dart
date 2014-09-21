library piecemeal.test.rect_test;

import 'dart:math' as math;

import 'package:unittest/unittest.dart';

import 'package:piecemeal/piecemeal.dart';

void main() {
  test("EMPTY", () {
    expect(Rect.EMPTY.x, equals(0));
    expect(Rect.EMPTY.y, equals(0));
    expect(Rect.EMPTY.width, equals(0));
    expect(Rect.EMPTY.height, equals(0));
  });

  test("coordinates", () {
    var rect = new Rect(-1, 2, 3, 4);
    expect(rect.pos, equals(new Vec(-1, 2)));
    expect(rect.size, equals(new Vec(3, 4)));
    expect(rect.x, equals(-1));
    expect(rect.y, equals(2));
    expect(rect.width, equals(3));
    expect(rect.height, equals(4));

    expect(rect.left, equals(-1));
    expect(rect.top, equals(2));
    expect(rect.right, equals(2));
    expect(rect.bottom, equals(6));

    expect(rect.topLeft, equals(new Vec(-1, 2)));
    expect(rect.topRight, equals(new Vec(2, 2)));
    expect(rect.bottomRight, equals(new Vec(2, 6)));
    expect(rect.bottomLeft, equals(new Vec(-1, 6)));
  });

  test("negative size coordinates", () {
    var rect = new Rect(1, 2, -3, -4);
    expect(rect.pos, equals(new Vec(1, 2)));
    expect(rect.size, equals(new Vec(-3, -4)));
    expect(rect.x, equals(1));
    expect(rect.y, equals(2));
    expect(rect.width, equals(-3));
    expect(rect.height, equals(-4));

    expect(rect.left, equals(-2));
    expect(rect.top, equals(-2));
    expect(rect.right, equals(1));
    expect(rect.bottom, equals(2));

    expect(rect.topLeft, equals(new Vec(-2, -2)));
    expect(rect.topRight, equals(new Vec(1, -2)));
    expect(rect.bottomRight, equals(new Vec(1, 2)));
    expect(rect.bottomLeft, equals(new Vec(-2, 2)));
  });

  test("area", () {
    expect(new Rect(-1, 2, 3, 4).area, equals(12));
    expect(new Rect(0, 0, 1, 4).area, equals(4));
    expect(new Rect(0, 0, 3, 1).area, equals(3));
    expect(new Rect(0, 0, 3, 0).area, equals(0));

    // Can have negative area.
    expect(new Rect(0, 0, -2, 3).area, equals(-6));
    expect(new Rect(0, 0, 2, -3).area, equals(-6));
    expect(new Rect(0, 0, -2, -3).area, equals(6));
  });

  test("Rect.posAndSize()", () {
    var rect = new Rect.posAndSize(new Vec(1, 2), new Vec(3, 4));
    expect(rect.x, equals(1));
    expect(rect.y, equals(2));
    expect(rect.width, equals(3));
    expect(rect.height, equals(4));
  });

  test("Rect.leftTopRightBottom()", () {
    var rect = new Rect.leftTopRightBottom(1, 2, 3, 4);
    expect(rect.x, equals(1));
    expect(rect.y, equals(2));
    expect(rect.width, equals(2));
    expect(rect.height, equals(2));
  });

  test("Rect.row()", () {
    var rect = new Rect.row(1, 2, 3);
    expect(rect.x, equals(1));
    expect(rect.y, equals(2));
    expect(rect.width, equals(3));
    expect(rect.height, equals(1));
  });

  test("Rect.column()", () {
    var rect = new Rect.column(1, 2, 3);
    expect(rect.x, equals(1));
    expect(rect.y, equals(2));
    expect(rect.width, equals(1));
    expect(rect.height, equals(3));
  });

  test(".toString()", () {
    expect(new Rect(1, 2, 3, 4).toString(), equals("(1, 2)-(3, 4)"));
  });

  test("==", () {
    expect(new Rect(1, 2, 3, 4) == new Rect(1, 2, 3, 4), isTrue);
    expect(new Rect(1, 2, 3, 4) == new Rect(2, 1, 3, 4), isFalse);

    expect(new Rect(1, 1, 1, 1) == new Vec(0, 1), isFalse);
  });

  // TODO: intersect().
  // TODO: centerIn().
  // TODO: center.
  // TODO: inflate().
  // TODO: contains().
  // TODO: containsRect().
  // TODO: clamp().
  // TODO: iterator.
  // TODO: distanceTo().
  // TODO: trace().
}
