library piecemeal.test.rect_test;

import 'package:test/test.dart';

import 'package:piecemeal/piecemeal.dart';

void main() {
  test("EMPTY", () {
    expect(Rect.empty.x, equals(0));
    expect(Rect.empty.y, equals(0));
    expect(Rect.empty.width, equals(0));
    expect(Rect.empty.height, equals(0));
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

  // TODO: intersect().
  // TODO: centerIn().
  // TODO: center.
  // TODO: inflate().
  // TODO: contains().
  // TODO: containsRect().

  test(".clamp()", () {
    var rect = new Rect(1, 2, 3, 4);

    // Inside.
    expect(rect.clamp(new Vec(2, 3)), equals(new Vec(2, 3)));

    // Left.
    expect(rect.clamp(new Vec(0, 3)), equals(new Vec(1, 3)));

    // Right.
    expect(rect.clamp(new Vec(10, 3)), equals(new Vec(4, 3)));

    // Top.
    expect(rect.clamp(new Vec(2, 0)), equals(new Vec(2, 2)));

    // Bottom.
    expect(rect.clamp(new Vec(2, 8)), equals(new Vec(2, 6)));

    // Corner.
    expect(rect.clamp(new Vec(20, 30)), equals(new Vec(4, 6)));
  });

  // TODO: iterator.
  // TODO: distanceTo().
  // TODO: trace().
}
